package com.matchmakergaming.matching.application

import com.matchmakergaming.matching.infrastructure.persistence.MatchingHistoryRepository
import org.springframework.stereotype.Service
import java.time.LocalDateTime

@Service
class MatchingStatsService(
    private val matchingHistoryRepository: MatchingHistoryRepository
) {

    fun getUserStats(userId: Long): Map<String, Any> {
        val allMatches = matchingHistoryRepository.findByUserIdOrderByCreatedAtDesc(userId)
        val totalMatches = allMatches.size
        
        // Mock win rate calculation (in a real app, you'd check match results)
        val winRate = if (totalMatches > 0) 50 else 0 
        
        val matchesToday = matchingHistoryRepository.countByUserIdAndCreatedAtAfter(
            userId, 
            LocalDateTime.now().withHour(0).withMinute(0)
        )
        
        val matchesThisWeek = matchingHistoryRepository.countByUserIdAndCreatedAtAfter(
            userId, 
            LocalDateTime.now().minusDays(7)
        )

        return mapOf(
            "totalMatches" to totalMatches,
            "winRate" to "$winRate%",
            "matchesToday" to matchesToday,
            "matchesThisWeek" to matchesThisWeek,
            "history" to allMatches.take(10)
        )
    }
}
