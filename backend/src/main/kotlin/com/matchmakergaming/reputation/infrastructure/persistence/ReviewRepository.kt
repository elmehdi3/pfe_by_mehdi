package com.matchmakergaming.reputation.infrastructure.persistence

import com.matchmakergaming.reputation.domain.model.Review
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface ReviewRepository : JpaRepository<Review, Long> {
    fun findByReviewedId(reviewedId: Long): List<Review>
    fun countByReviewedId(reviewedId: Long): Long
}
