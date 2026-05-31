package com.matchmakergaming.analytics.application

import com.matchmakergaming.analytics.application.dto.GlobalStatsDTO
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import com.matchmakergaming.matching.infrastructure.persistence.MatchingHistoryRepository
import com.matchmakergaming.premium.infrastructure.persistence.SubscriptionRepository
import com.matchmakergaming.chat.infrastructure.persistence.MessageRepository
import org.springframework.stereotype.Service
import java.time.LocalDateTime

@Service
class AnalyticsService(
    private val userRepository: UserRepository,
    private val matchingHistoryRepository: MatchingHistoryRepository,
    private val subscriptionRepository: SubscriptionRepository,
    private val messageRepository: MessageRepository
) {

    fun getGlobalStats(): GlobalStatsDTO {
        val totalUsers = userRepository.count()
        val premiumUsers = subscriptionRepository.countByStatus("ACTIVE")
        
        // Calcul simplifié pour la démo, en production on utiliserait une requête optimisée
        val activeUsers24h = userRepository.findAll().count { 
            it.lastSeen.isAfter(LocalDateTime.now().minusDays(1)) 
        }.toLong()

        val premiumConversionRate = if (totalUsers > 0) {
            (premiumUsers.toDouble() / totalUsers.toDouble()) * 100.0
        } else 0.0

        val totalRevenue = subscriptionRepository.findAll()
            .filter { it.status == "ACTIVE" }
            .sumOf { it.price }

        return GlobalStatsDTO(
            totalUsers = totalUsers,
            activeUsers24h = activeUsers24h,
            totalMatchesCreated = matchingHistoryRepository.count(),
            totalMessagesSent = messageRepository.count(),
            premiumConversionRate = premiumConversionRate,
            totalRevenue = totalRevenue
        )
    }
}
