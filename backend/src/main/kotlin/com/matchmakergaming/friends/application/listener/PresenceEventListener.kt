package com.matchmakergaming.friends.application.listener

import com.matchmakergaming.friends.domain.model.FriendStatus
import com.matchmakergaming.friends.infrastructure.persistence.FriendRepository
import com.matchmakergaming.users.domain.event.UserPresenceEvent
import org.springframework.context.event.EventListener
import org.springframework.messaging.simp.SimpMessagingTemplate
import org.springframework.scheduling.annotation.Async
import org.springframework.stereotype.Component

@Component
class PresenceEventListener(
    private val friendRepository: FriendRepository,
    private val messagingTemplate: SimpMessagingTemplate
) {

    @Async
    @EventListener
    fun handleUserPresenceChange(event: UserPresenceEvent) {
        // 1. Récupérer la liste des amis du joueur
        val friends = friendRepository.findByUserIdAndStatus(event.userId, FriendStatus.ACCEPTED)

        // 2. Notifier chaque ami via leur canal privé WebSocket
        friends.forEach { friend ->
            // Le client Flutter de l'ami écoute sur /user/queue/friends-presence
            messagingTemplate.convertAndSendToUser(
                friend.friendId.toString(),
                "/queue/friends-presence",
                mapOf(
                    "userId" to event.userId,
                    "pseudo" to event.pseudo,
                    "isOnline" to event.isOnline
                )
            )
        }
    }
}
