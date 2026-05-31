package com.matchmakergaming.notifications.application

import com.matchmakergaming.notifications.application.dto.NotificationDTO
import com.matchmakergaming.notifications.application.mapper.NotificationMapper
import com.matchmakergaming.notifications.domain.model.Notification
import com.matchmakergaming.notifications.domain.model.NotificationType
import com.matchmakergaming.notifications.infrastructure.persistence.NotificationRepository
import org.springframework.amqp.rabbit.core.RabbitTemplate
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.messaging.simp.SimpMessagingTemplate
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import com.matchmakergaming.config.RabbitMQConfig

@Service
class NotificationService(
    private val notificationRepository: NotificationRepository,
    private val rabbitTemplate: RabbitTemplate,
    private val messagingTemplate: SimpMessagingTemplate,
    private val notificationMapper: NotificationMapper
) {

    @Transactional
    fun createAndSendNotification(userId: Long, title: String, body: String, type: NotificationType) {
        val notification = Notification(
            userId = userId,
            title = title,
            body = body,
            type = type
        )
        val savedNotification = notificationRepository.save(notification)
        val notificationDTO = notificationMapper.toDTO(savedNotification)

        messagingTemplate.convertAndSendToUser(
            userId.toString(), 
            "/queue/notifications", 
            notificationDTO
        )

        rabbitTemplate.convertAndSend(
            RabbitMQConfig.MATCHING_EXCHANGE,
            RabbitMQConfig.NOTIFICATION_ROUTING_KEY,
            savedNotification
        )
    }

    /**
     * Récupération paginée des notifications pour l'utilisateur.
     */
    fun getUserNotifications(userId: Long, pageable: Pageable): Page<NotificationDTO> {
        return notificationRepository.findByUserId(userId, pageable).map { notificationMapper.toDTO(it) }
    }

    @Transactional
    fun markAsRead(notificationId: Long) {
        notificationRepository.findById(notificationId).ifPresent {
            it.isRead = true
            notificationRepository.save(it)
        }
    }

    fun getUnreadCount(userId: Long): Long {
        return notificationRepository.countByUserIdAndIsReadFalse(userId)
    }
}
