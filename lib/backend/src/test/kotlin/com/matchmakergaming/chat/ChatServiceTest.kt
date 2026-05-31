package com.matchmakergaming.chat

import com.matchmakergaming.chat.application.ChatService
import com.matchmakergaming.chat.application.mapper.ConversationMapper
import com.matchmakergaming.chat.application.mapper.MessageMapper
import com.matchmakergaming.chat.domain.model.Message
import com.matchmakergaming.chat.infrastructure.persistence.ConversationParticipantRepository
import com.matchmakergaming.chat.infrastructure.persistence.ConversationRepository
import com.matchmakergaming.chat.infrastructure.persistence.MessageRepository
import com.matchmakergaming.common.infrastructure.monitoring.BusinessMetricsService
import com.matchmakergaming.moderation.application.ChatModerationService
import com.matchmakergaming.moderation.application.ModerationService
import com.matchmakergaming.users.domain.model.User
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import org.mockito.Mockito.*
import org.springframework.messaging.simp.SimpMessagingTemplate
import java.util.*

class ChatServiceTest {

    private val messageRepo = mock(MessageRepository::class.java)
    private val convRepo = mock(ConversationRepository::class.java)
    private val partRepo = mock(ConversationParticipantRepository::class.java)
    private val userRepo = mock(UserRepository::class.java)
    private val messagingTemplate = mock(SimpMessagingTemplate::class.java)
    private val msgMapper = mock(MessageMapper::class.java)
    private val convMapper = mock(ConversationMapper::class.java)
    private val metrics = mock(BusinessMetricsService::class.java)
    private val moderation = mock(ChatModerationService::class.java)
    private val modService = mock(ModerationService::class.java)

    private val chatService = ChatService(
        convRepo, partRepo, messageRepo, userRepo, 
        messagingTemplate, msgMapper, convMapper, metrics, moderation, modService
    )

    @Test
    fun `sendMessage should filter content before saving`() {
        // GIVEN
        val rawContent = "Ceci est un message toxic2"
        val filteredContent = "Ceci est un message ****"
        val msg = Message(conversationId = 1L, senderId = 1L, content = rawContent)
        val user = User(id = 1L, email = "test@test.com", password = "", pseudo = "Tester")
        
        val conversation = com.matchmakergaming.chat.domain.model.Conversation(id = 1L)

        `when`(moderation.filterMessage(rawContent)).thenReturn(filteredContent)
        `when`(messageRepo.save(any())).thenAnswer { it.arguments[0] as Message }
        `when`(convRepo.findById(1L)).thenReturn(Optional.of(conversation))
        `when`(userRepo.findById(1L)).thenReturn(Optional.of(user))

        // WHEN
        val result = chatService.sendMessage(msg)

        // THEN
        verify(messageRepo).save(argThat { it.content == filteredContent })
        verify(metrics).incrementMessages()
    }
}
