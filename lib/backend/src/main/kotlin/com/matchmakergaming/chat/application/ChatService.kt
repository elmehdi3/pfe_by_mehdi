package com.matchmakergaming.chat.application

import com.matchmakergaming.chat.application.dto.ConversationDTO
import com.matchmakergaming.chat.application.dto.MessageDTO
import com.matchmakergaming.chat.application.dto.TypingEventDTO
import com.matchmakergaming.chat.application.mapper.ConversationMapper
import com.matchmakergaming.chat.application.mapper.MessageMapper
import com.matchmakergaming.chat.domain.model.Conversation
import com.matchmakergaming.chat.domain.model.ConversationParticipant
import com.matchmakergaming.chat.domain.model.ConversationType
import com.matchmakergaming.chat.domain.model.Message
import com.matchmakergaming.chat.infrastructure.persistence.ConversationParticipantRepository
import com.matchmakergaming.chat.infrastructure.persistence.ConversationRepository
import com.matchmakergaming.chat.infrastructure.persistence.MessageRepository
import com.matchmakergaming.moderation.application.ChatModerationService
import com.matchmakergaming.moderation.application.ModerationService
import com.matchmakergaming.moderation.domain.model.Report
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import com.matchmakergaming.common.infrastructure.monitoring.BusinessMetricsService
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort
import org.springframework.messaging.simp.SimpMessagingTemplate
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDateTime

@Service
class ChatService(
    private val conversationRepository: ConversationRepository,
    private val conversationParticipantRepository: ConversationParticipantRepository,
    private val messageRepository: MessageRepository,
    private val userRepository: UserRepository,
    private val messagingTemplate: SimpMessagingTemplate,
    private val messageMapper: MessageMapper,
    private val conversationMapper: ConversationMapper,
    private val metricsService: BusinessMetricsService,
    private val chatModerationService: ChatModerationService,
    private val moderationService: ModerationService
) {

    @Transactional
    fun createPrivateConversation(user1Id: Long, user2Id: Long): ConversationDTO {
        val conversation = Conversation(type = ConversationType.PRIVATE)
        val savedConversation = conversationRepository.save(conversation)
        conversationParticipantRepository.save(ConversationParticipant(conversationId = savedConversation.id!!, userId = user1Id))
        conversationParticipantRepository.save(ConversationParticipant(conversationId = savedConversation.id!!, userId = user2Id))
        val otherUser = userRepository.findById(user2Id).get()
        return conversationMapper.toDTO(savedConversation, otherUser, null, 0)
    }

    @Transactional
    fun createTeamConversation(teamId: Long, ownerId: Long): ConversationDTO {
        val conversation = Conversation(type = ConversationType.TEAM, teamId = teamId)
        val savedConversation = conversationRepository.save(conversation)
        // Ajout du créateur comme premier participant
        conversationParticipantRepository.save(ConversationParticipant(conversationId = savedConversation.id!!, userId = ownerId))
        return conversationMapper.toDTO(savedConversation, null, null, 0)
    }

    @Transactional
    fun addParticipantToConversation(conversationId: Long, userId: Long) {
        if (conversationParticipantRepository.findByConversationIdAndUserId(conversationId, userId).isEmpty) {
            conversationParticipantRepository.save(ConversationParticipant(conversationId = conversationId, userId = userId))
        }
    }

    fun getUserConversations(userId: Long): List<ConversationDTO> {
        val participations = conversationParticipantRepository.findByUserId(userId)
        
        return participations.map { participation ->
            val conv = conversationRepository.findById(participation.conversationId).get()
            val participants = conversationParticipantRepository.findByConversationId(conv.id!!)
            
            val otherParticipant = if (conv.type == ConversationType.PRIVATE) {
                participants.firstOrNull { it.userId != userId }?.let { userRepository.findById(it.userId).orElse(null) }
            } else null
            
            val lastMessagePage = messageRepository.findByConversationId(
                conv.id!!, 
                PageRequest.of(0, 1, Sort.by(Sort.Direction.DESC, "createdAt"))
            )
            val lastMessage = if (lastMessagePage.hasContent()) lastMessagePage.content[0] else null
            
            val unreadCount = messageRepository.countByConversationIdAndSenderIdNotAndCreatedAtAfter(
                conv.id!!, 
                userId, 
                participation.lastReadAt
            ).toInt()

            conversationMapper.toDTO(conv, otherParticipant, lastMessage, unreadCount)
        }.sortedByDescending { it.updatedAt }
    }

    @Transactional
    fun sendMessage(message: Message): MessageDTO {
        val originalContent = message.content
        message.content = chatModerationService.filterMessage(originalContent)
        
        if (chatModerationService.containsExtremeToxicity(originalContent)) {
            moderationService.submitReport(Report(
                reporterId = 0,
                reportedId = message.senderId,
                reason = "AUTO_MODERATION",
                description = "Message toxique : $originalContent"
            ))
        }

        val savedMessage = messageRepository.save(message)
        val conversation = conversationRepository.findById(message.conversationId).get()
        conversation.updatedAt = LocalDateTime.now()
        conversationRepository.save(conversation)

        val sender = userRepository.findById(message.senderId).get()
        val messageDTO = messageMapper.toDTO(savedMessage, sender)
        
        metricsService.incrementMessages()
        messagingTemplate.convertAndSend("/topic/conversations/${message.conversationId}", messageDTO)
        return messageDTO
    }

    fun getConversationHistory(conversationId: Long, pageable: Pageable): Page<MessageDTO> {
        return messageRepository.findByConversationId(conversationId, pageable).map { message ->
            val sender = userRepository.findById(message.senderId).get()
            messageMapper.toDTO(message, sender)
        }
    }

    @Transactional
    fun markAsRead(conversationId: Long, userId: Long) {
        val participation = conversationParticipantRepository.findByConversationIdAndUserId(conversationId, userId)
            .orElseThrow { RuntimeException("Participant not found") }
        participation.lastReadAt = LocalDateTime.now()
        conversationParticipantRepository.save(participation)
        messagingTemplate.convertAndSend("/topic/conversations/$conversationId/read", userId)
    }

    fun handleTypingEvent(event: TypingEventDTO) {
        messagingTemplate.convertAndSend("/topic/conversations/${event.conversationId}/typing", event)
    }
}
