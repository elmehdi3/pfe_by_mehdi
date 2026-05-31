package com.matchmakergaming.chat.application.dto

import com.matchmakergaming.chat.domain.model.ConversationType
import java.time.LocalDateTime

data class ConversationDTO(
    val id: Long?,
    val type: ConversationType,
    val teamId: Long? = null,
    val participantId: Long? = null,
    val displayName: String,
    val displayAvatar: String?,
    val lastMessage: String?,
    val lastMessageTime: LocalDateTime?,
    val unreadCount: Int,
    val updatedAt: LocalDateTime
)
