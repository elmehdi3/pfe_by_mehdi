package com.matchmakergaming.analytics.application

import org.springframework.data.redis.core.RedisTemplate
import org.springframework.stereotype.Service

@Service
class RealTimeStatsService(private val redisTemplate: RedisTemplate<String, Any>) {

    private val ONLINE_USERS_KEY = "stats:online_users"
    private val ACTIVE_MATCHES_KEY = "stats:active_matches"
    private val TOTAL_MESSAGES_KEY = "stats:messages_today"

    fun incrementOnlineUsers() {
        redisTemplate.opsForValue().increment(ONLINE_USERS_KEY)
    }

    fun decrementOnlineUsers() {
        val count = redisTemplate.opsForValue().get(ONLINE_USERS_KEY) as? Int ?: 0
        if (count > 0) {
            redisTemplate.opsForValue().decrement(ONLINE_USERS_KEY)
        }
    }

    fun logMatchCreated() {
        redisTemplate.opsForValue().increment(ACTIVE_MATCHES_KEY)
    }

    fun logMessageSent() {
        redisTemplate.opsForValue().increment(TOTAL_MESSAGES_KEY)
    }

    fun getLiveSnapshot(): Map<String, Any> {
        return mapOf(
            "onlineUsers" to (redisTemplate.opsForValue().get(ONLINE_USERS_KEY) ?: 0),
            "activeMatches" to (redisTemplate.opsForValue().get(ACTIVE_MATCHES_KEY) ?: 0),
            "messagesSentToday" to (redisTemplate.opsForValue().get(TOTAL_MESSAGES_KEY) ?: 0),
            "serverTime" to java.time.LocalDateTime.now().toString()
        )
    }
    
    fun resetDailyStats() {
        redisTemplate.delete(TOTAL_MESSAGES_KEY)
        redisTemplate.delete(ACTIVE_MATCHES_KEY)
    }
}
