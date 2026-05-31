package com.matchmakergaming.notifications.infrastructure.fcm

import com.matchmakergaming.notifications.domain.model.Notification
import com.matchmakergaming.users.application.DeviceService
import org.springframework.amqp.rabbit.annotation.RabbitListener
import org.springframework.stereotype.Service
import org.slf4j.LoggerFactory
import com.matchmakergaming.config.RabbitMQConfig

@Service
class FcmService(private val deviceService: DeviceService) {
    private val logger = LoggerFactory.getLogger(FcmService::class.java)

    @RabbitListener(queues = [RabbitMQConfig.NOTIFICATION_QUEUE])
    fun handleNotification(notification: Notification) {
        val tokens = deviceService.getUserTokens(notification.userId)
        
        if (tokens.isEmpty()) {
            logger.info("No active devices found for user ${notification.userId}. Skipping push.")
            return
        }

        logger.info("Sending Push Notification to ${tokens.size} devices for user ${notification.userId}: ${notification.title}")
        
        tokens.forEach { token ->
            // Ici, nous appellerions le SDK Firebase Admin
            // sendToFirebase(token, notification.title, notification.body)
            logger.debug("Push sent to token: ${token.take(10)}...")
        }
    }
}
