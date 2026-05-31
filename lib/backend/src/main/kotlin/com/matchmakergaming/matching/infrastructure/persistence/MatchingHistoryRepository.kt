package com.matchmakergaming.matching.infrastructure.persistence

import com.matchmakergaming.matching.domain.model.MatchingHistory
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface MatchingHistoryRepository : JpaRepository<MatchingHistory, Long> {
    fun findByUserIdOrderByCreatedAtDesc(userId: Long): List<MatchingHistory>
    fun countByUserIdAndCreatedAtAfter(userId: Long, createdAt: java.time.LocalDateTime): Long
}
