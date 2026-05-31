package com.matchmakergaming.users.application.listener

import com.matchmakergaming.users.application.PresenceService
import com.matchmakergaming.security.services.UserDetailsImpl
import org.slf4j.LoggerFactory
import org.springframework.context.event.EventListener
import org.springframework.messaging.simp.SimpMessageHeaderAccessor
import org.springframework.messaging.simp.stomp.StompHeaderAccessor
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.stereotype.Component
import org.springframework.web.socket.messaging.SessionConnectedEvent
import org.springframework.web.socket.messaging.SessionDisconnectEvent

@Component
class PresenceWebSocketListener(private val presenceService: PresenceService) {
    private val logger = LoggerFactory.getLogger(PresenceWebSocketListener::class.java)

    @EventListener
    fun handleWebSocketConnectListener(event: SessionConnectedEvent) {
        val headerAccessor = StompHeaderAccessor.wrap(event.message)
        val user = headerAccessor.user as? UsernamePasswordAuthenticationToken
        val userDetails = user?.principal as? UserDetailsImpl

        userDetails?.let {
            presenceService.setUserOnline(it.id)
            logger.info("Joueur connecté via WebSocket : ${it.username} (ID: ${it.id})")
        }
    }

    @EventListener
    fun handleWebSocketDisconnectListener(event: SessionDisconnectEvent) {
        val headerAccessor = StompHeaderAccessor.wrap(event.message)
        val user = headerAccessor.user as? UsernamePasswordAuthenticationToken
        val userDetails = user?.principal as? UserDetailsImpl

        userDetails?.let {
            presenceService.setUserOffline(it.id)
            logger.info("Joueur déconnecté : ${it.username}")
        }
    }
}
