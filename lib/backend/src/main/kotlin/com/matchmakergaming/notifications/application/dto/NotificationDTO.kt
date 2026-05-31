package com.matchmakergaming.notifications.application.dto

import com.matchmakergaming.notifications.domain.model.NotificationType
import java.time.LocalDateTime

data class NotificationDTO(
    val id: Long?,
    val title: String,
    val body: String,
    val type: NotificationType,
    val isRead: Boolean,
    val createdAt: LocalDateTime
)
