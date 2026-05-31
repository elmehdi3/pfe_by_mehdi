package com.matchmakergaming.chat.application.dto

data class TypingEventDTO(
    val conversationId: Long,
    val userId: Long,
    val isTyping: Boolean
)
