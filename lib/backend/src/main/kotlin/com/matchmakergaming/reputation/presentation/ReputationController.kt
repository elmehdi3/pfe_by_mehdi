package com.matchmakergaming.reputation.presentation

import com.matchmakergaming.reputation.application.ReputationService
import com.matchmakergaming.reputation.application.dto.ReviewDTO
import com.matchmakergaming.reputation.domain.model.Review
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/v1/reputation")
class ReputationController(private val reputationService: ReputationService) {

    @PostMapping("/review")
    fun addReview(@RequestBody review: Review): ResponseEntity<ReviewDTO> {
        return ResponseEntity.ok(reputationService.addReview(review))
    }

    @GetMapping("/user/{userId}")
    fun getUserReviews(@PathVariable userId: Long): ResponseEntity<List<ReviewDTO>> {
        return ResponseEntity.ok(reputationService.getPlayerReviews(userId))
    }
}
