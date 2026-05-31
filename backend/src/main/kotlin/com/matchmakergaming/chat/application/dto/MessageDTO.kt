package com.matchmakergaming.chat.application.dto

import com.matchmakergaming.chat.domain.model.MessageType
import java.time.LocalDateTime

data class MessageDTO(
    val id: Long?,
    val conversationId: Long,
    val senderId: Long,
    val senderPseudo: String,
    val senderAvatar: String?,
    val content: String,
    val messageType: MessageType,
    val isRead: Boolean,
    val createdAt: LocalDateTime
)
