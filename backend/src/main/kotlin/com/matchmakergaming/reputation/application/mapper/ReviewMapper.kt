package com.matchmakergaming.reputation.application.mapper

import com.matchmakergaming.reputation.application.dto.ReviewDTO
import com.matchmakergaming.reputation.domain.model.Review
import com.matchmakergaming.users.domain.model.User
import org.springframework.stereotype.Component

@Component
class ReviewMapper {
    fun toDTO(review: Review, reviewer: User): ReviewDTO {
        return ReviewDTO(
            id = review.id,
            reviewerId = review.reviewerId,
            reviewerPseudo = reviewer.pseudo,
            reviewedId = review.reviewedId,
            rating = review.rating,
            comment = review.comment,
            badge = review.badge,
            createdAt = review.createdAt
        )
    }

    fun toDTOList(reviewsWithUsers: List<Pair<Review, User>>): List<ReviewDTO> {
        return reviewsWithUsers.map { toDTO(it.first, it.second) }
    }
}
