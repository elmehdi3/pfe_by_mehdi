package com.matchmakergaming.users.application

import com.matchmakergaming.analytics.application.RealTimeStatsService
import com.matchmakergaming.users.domain.event.UserPresenceEvent
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import org.springframework.context.ApplicationEventPublisher
import org.springframework.data.redis.core.RedisTemplate
import org.springframework.stereotype.Service
import java.time.LocalDateTime
import java.util.concurrent.TimeUnit

@Service
class PresenceService(
    private val redisTemplate: RedisTemplate<String, Any>,
    private val userRepository: UserRepository,
    private val realTimeStatsService: RealTimeStatsService,
    private val eventPublisher: ApplicationEventPublisher
) {
    private val PRESENCE_KEY_PREFIX = "user:presence:"

    fun setUserOnline(userId: Long) {
        val key = "$PRESENCE_KEY_PREFIX$userId"
        val isAlreadyOnline = redisTemplate.hasKey(key)
        
        redisTemplate.opsForValue().set(key, "online", 5, TimeUnit.MINUTES)
        
        if (!isAlreadyOnline) {
            realTimeStatsService.incrementOnlineUsers()
            notifyPresenceChange(userId, true)
        }
        
        userRepository.findById(userId).ifPresent {
            it.isOnline = true
            it.lastSeen = LocalDateTime.now()
            userRepository.save(it)
        }
    }

    fun setUserOffline(userId: Long) {
        val wasOnline = redisTemplate.hasKey("$PRESENCE_KEY_PREFIX$userId")
        redisTemplate.delete("$PRESENCE_KEY_PREFIX$userId")
        
        if (wasOnline) {
            realTimeStatsService.decrementOnlineUsers()
            notifyPresenceChange(userId, false)
        }

        userRepository.findById(userId).ifPresent {
            it.isOnline = false
            userRepository.save(it)
        }
    }

    private fun notifyPresenceChange(userId: Long, isOnline: Boolean) {
        userRepository.findById(userId).ifPresent {
            eventPublisher.publishEvent(UserPresenceEvent(userId, it.pseudo, isOnline))
        }
    }

    fun isUserOnline(userId: Long): Boolean {
        return redisTemplate.hasKey("$PRESENCE_KEY_PREFIX$userId")
    }
}
