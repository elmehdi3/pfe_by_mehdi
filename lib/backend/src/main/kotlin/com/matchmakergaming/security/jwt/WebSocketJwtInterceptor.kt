package com.matchmakergaming.security.jwt

import org.springframework.messaging.Message
import org.springframework.messaging.MessageChannel
import org.springframework.messaging.simp.stomp.StompCommand
import org.springframework.messaging.simp.stomp.StompHeaderAccessor
import org.springframework.messaging.support.ChannelInterceptor
import org.springframework.messaging.support.MessageHeaderAccessor
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.stereotype.Component

@Component
class WebSocketJwtInterceptor(
    private val jwtUtils: JwtUtils,
    private val userDetailsService: UserDetailsService
) : ChannelInterceptor {

    override fun preSend(message: Message<*>, channel: MessageChannel): Message<*>? {
        val accessor = MessageHeaderAccessor.getAccessor(message, StompHeaderAccessor::class.java)

        if (accessor != null && StompCommand.CONNECT == accessor.command) {
            val authToken = accessor.getFirstNativeHeader("Authorization")
            
            if (authToken != null && authToken.startsWith("Bearer ")) {
                val jwt = authToken.substring(7)
                if (jwtUtils.validateJwtToken(jwt)) {
                    val username = jwtUtils.getUserNameFromJwtToken(jwt)
                    val userDetails = userDetailsService.loadUserByUsername(username)
                    
                    val authentication = UsernamePasswordAuthenticationToken(
                        userDetails, null, userDetails.authorities
                    )
                    
                    accessor.user = authentication
                    SecurityContextHolder.getContext().authentication = authentication
                }
            }
        }
        return message
    }
}
