package com.matchmakergaming.premium.presentation

import com.matchmakergaming.common.presentation.ApiResponse
import com.matchmakergaming.premium.application.PremiumService
import com.matchmakergaming.premium.application.dto.SubscriptionDTO
import com.matchmakergaming.premium.domain.model.SubscriptionPlan
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/v1/subscriptions")
class PremiumController(private val premiumService: PremiumService) {

    @PostMapping("/subscribe")
    fun subscribe(
        @RequestParam userId: Long, 
        @RequestParam plan: SubscriptionPlan
    ): ResponseEntity<ApiResponse<SubscriptionDTO>> {
        val result = premiumService.subscribe(userId, plan)
        return ResponseEntity.ok(ApiResponse.success(result, "Abonnement activé avec succès"))
    }

    @GetMapping("/user/{userId}")
    fun getUserSubscription(@PathVariable userId: Long): ResponseEntity<ApiResponse<SubscriptionDTO>> {
        val subscription = premiumService.getUserSubscription(userId)
        return if (subscription != null) {
            ResponseEntity.ok(ApiResponse.success(subscription))
        } else {
            ResponseEntity.status(404).body(ApiResponse.error("Aucun abonnement trouvé pour cet utilisateur"))
        }
    }
}
