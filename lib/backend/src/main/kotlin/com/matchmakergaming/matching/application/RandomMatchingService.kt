package com.matchmakergaming.matching.application

import com.matchmakergaming.premium.application.PremiumValidator
import org.springframework.data.redis.core.RedisTemplate
import org.springframework.stereotype.Service
import java.util.concurrent.TimeUnit

@Service
class RandomMatchingService(
    private val redisTemplate: RedisTemplate<String, Any>,
    private val premiumValidator: PremiumValidator
) {
    private val QUEUE_PREFIX = "matching:queue:"

    fun joinQueue(userId: Long, gameId: Long?, region: String?) {
        // 1. Vérification des privilèges Premium
        if (!premiumValidator.canPerformMatching(userId)) {
            throw RuntimeException("Limite de matching aléatoire atteinte pour aujourd'hui. Devenez Premium !")
        }

        val key = buildKey(gameId, region)
        redisTemplate.opsForSet().add(key, userId.toString())
        redisTemplate.expire(key, 10, TimeUnit.MINUTES)
    }

    fun findMatch(userId: Long, gameId: Long?, region: String?): Long? {
        val key = buildKey(gameId, region)
        val members = redisTemplate.opsForSet().members(key) ?: return null
        
        val opponentId = members
            .map { it.toString().toLong() }
            .filter { it != userId }
            .randomOrNull()

        if (opponentId != null) {
            redisTemplate.opsForSet().remove(key, userId.toString(), opponentId.toString())
        }
        
        return opponentId
    }

    private fun buildKey(gameId: Long?, region: String?): String {
        return when {
            gameId != null -> "${QUEUE_PREFIX}game:$gameId"
            region != null -> "${QUEUE_PREFIX}region:$region"
            else -> "${QUEUE_PREFIX}global"
        }
    }
}
