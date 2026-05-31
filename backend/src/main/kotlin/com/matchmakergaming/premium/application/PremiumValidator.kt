package com.matchmakergaming.premium.application

import com.matchmakergaming.matching.infrastructure.persistence.MatchingHistoryRepository
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import org.springframework.stereotype.Service
import java.time.LocalDateTime

@Service
class PremiumValidator(
    private val userRepository: UserRepository,
    private val matchingHistoryRepository: MatchingHistoryRepository
) {
    private val FREE_DAILY_MATCH_LIMIT = 10

    fun canPerformMatching(userId: Long): Boolean {
        val user = userRepository.findById(userId).orElseThrow { RuntimeException("User not found") }
        
        // Les utilisateurs Premium n'ont aucune limite
        if (user.isPremium) return true

        // Pour les utilisateurs Free, on compte les matchs des dernières 24h
        val today = LocalDateTime.now().minusDays(1)
        val matchCount = matchingHistoryRepository.findAll()
            .count { it.userId == userId && it.createdAt.isAfter(today) }

        return matchCount < FREE_DAILY_MATCH_LIMIT
    }

    fun hasAdvancedFilters(userId: Long): Boolean {
        val user = userRepository.findById(userId).orElseThrow { RuntimeException("User not found") }
        return user.isPremium
    }
}
