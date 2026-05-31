package com.matchmakergaming.notifications.application.listener

import com.matchmakergaming.matching.domain.event.MatchFoundEvent
import com.matchmakergaming.notifications.application.NotificationService
import com.matchmakergaming.notifications.domain.model.NotificationType
import org.springframework.context.event.EventListener
import org.springframework.scheduling.annotation.Async
import org.springframework.stereotype.Component

@Component
class MatchEventListener(private val notificationService: NotificationService) {

    @Async // Exécution asynchrone pour ne pas bloquer le thread de matching
    @EventListener
    fun handleMatchFound(event: MatchFoundEvent) {
        // Notification pour l'initiateur
        notificationService.createAndSendNotification(
            userId = event.userId,
            title = "Nouveau partenaire trouvé !",
            body = "Nous avons trouvé un joueur compatible pour votre session.",
            type = if (event.type == "SMART") NotificationType.MATCH_FOUND else NotificationType.MATCH_RANDOM_FOUND
        )

        // Notification pour le partenaire trouvé
        notificationService.createAndSendNotification(
            userId = event.matchedUserId,
            title = "Match trouvé !",
            body = "Un joueur souhaite faire équipe avec vous.",
            type = if (event.type == "SMART") NotificationType.MATCH_FOUND else NotificationType.MATCH_RANDOM_FOUND
        )
    }
}
