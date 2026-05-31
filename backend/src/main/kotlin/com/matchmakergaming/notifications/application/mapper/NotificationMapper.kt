package com.matchmakergaming.notifications.application.mapper

import com.matchmakergaming.notifications.application.dto.NotificationDTO
import com.matchmakergaming.notifications.domain.model.Notification
import org.springframework.stereotype.Component

@Component
class NotificationMapper {
    fun toDTO(notification: Notification): NotificationDTO {
        return NotificationDTO(
            id = notification.id,
            title = notification.title,
            body = notification.body,
            type = notification.type,
            isRead = notification.isRead,
            createdAt = notification.createdAt
        )
    }

    fun toDTOList(notifications: List<Notification>): List<NotificationDTO> {
        return notifications.map { toDTO(it) }
    }
}
