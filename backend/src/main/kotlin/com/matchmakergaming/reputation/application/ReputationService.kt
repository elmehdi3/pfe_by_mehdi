package com.matchmakergaming.reputation.application

import com.matchmakergaming.profiles.domain.model.PlayerProfile
import com.matchmakergaming.profiles.infrastructure.persistence.PlayerProfileRepository
import com.matchmakergaming.reputation.application.dto.ReviewDTO
import com.matchmakergaming.reputation.application.mapper.ReviewMapper
import com.matchmakergaming.reputation.domain.model.Badge
import com.matchmakergaming.reputation.domain.model.Review
import com.matchmakergaming.reputation.infrastructure.persistence.ReviewRepository
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDateTime

@Service
class ReputationService(
    private val reviewRepository: ReviewRepository,
    private val profileRepository: PlayerProfileRepository,
    private val userRepository: UserRepository,
    private val reviewMapper: ReviewMapper
) {

    private val BADGE_THRESHOLD = 5 // Un badge est acquis après 5 mentions

    @Transactional
    fun addReview(review: Review): ReviewDTO {
        val savedReview = reviewRepository.save(review)
        calculateAndUpdateTrustScore(review.reviewedId)
        
        val reviewer = userRepository.findById(review.reviewerId)
            .orElseThrow { RuntimeException("Reviewer not found") }
            
        return reviewMapper.toDTO(savedReview, reviewer)
    }

    private fun calculateAndUpdateTrustScore(playerId: Long) {
        val reviews = reviewRepository.findByReviewedId(playerId)
        if (reviews.isEmpty()) return

        val now = LocalDateTime.now()
        var weightedSum = 0.0
        var weightTotal = 0.0

        reviews.forEach { review ->
            val weight = if (review.createdAt.isAfter(now.minusMonths(1))) 1.0 else 0.5
            weightedSum += review.rating * weight
            weightTotal += weight
        }

        val trustScore = weightedSum / weightTotal

        profileRepository.findByUserId(playerId).ifPresent { profile ->
            profile.reputationScore = Math.round(trustScore * 10.0) / 10.0
            profile.totalReviews = reviews.size
            
            // Attribution automatique de badges
            assignAutomaticBadges(profile, reviews)
            
            profileRepository.save(profile)
        }
    }

    /**
     * Analyse les reviews pour décerner des badges automatiques.
     */
    private fun assignAutomaticBadges(profile: PlayerProfile, reviews: List<Review>) {
        val badgeCounts = reviews
            .filter { it.badge != null }
            .groupingBy { it.badge!! }
            .eachCount()

        badgeCounts.forEach { (badge, count) ->
            if (count >= BADGE_THRESHOLD) {
                profile.badges.add(badge)
            }
        }
        
        // Badge spécial pour score parfait avec plus de 10 reviews
        if (profile.reputationScore >= 4.8 && profile.totalReviews >= 10) {
            profile.badges.add(Badge.TRUSTED_PLAYER)
        }
    }

    fun getPlayerReviews(playerId: Long): List<ReviewDTO> {
        return reviewRepository.findByReviewedId(playerId).map { review ->
            val reviewer = userRepository.findById(review.reviewerId).get()
            reviewMapper.toDTO(review, reviewer)
        }
    }
}
