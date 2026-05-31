package com.matchmakergaming.chat.application.mapper

import com.matchmakergaming.chat.application.dto.ConversationDTO
import com.matchmakergaming.chat.domain.model.Conversation
import com.matchmakergaming.chat.domain.model.ConversationType
import com.matchmakergaming.chat.domain.model.Message
import com.matchmakergaming.users.domain.model.User
import com.matchmakergaming.teams.infrastructure.persistence.TeamRepository
import org.springframework.stereotype.Component

@Component
class ConversationMapper(private val teamRepository: TeamRepository) {

    fun toDTO(
        conversation: Conversation,
        otherParticipant: User?, // Nullable car en cas de TEAM, on utilise l'entité Team
        lastMessage: Message?,
        unreadCount: Int
    ): ConversationDTO {
        
        var name = "Inconnu"
        var avatar: String? = null

        if (conversation.type == ConversationType.TEAM && conversation.teamId != null) {
            val team = teamRepository.findById(conversation.teamId).orElse(null)
            name = team?.name ?: "Équipe supprimée"
            avatar = team?.logo
        } else if (otherParticipant != null) {
            name = otherParticipant.pseudo
            avatar = otherParticipant.avatar
        }

        return ConversationDTO(
            id = conversation.id,
            type = conversation.type,
            teamId = conversation.teamId,
            displayName = name,
            displayAvatar = avatar,
            lastMessage = lastMessage?.content,
            lastMessageTime = lastMessage?.createdAt,
            unreadCount = unreadCount,
            updatedAt = conversation.updatedAt
        )
    }
}
