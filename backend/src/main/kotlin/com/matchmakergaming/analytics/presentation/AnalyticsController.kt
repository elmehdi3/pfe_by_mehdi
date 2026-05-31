package com.matchmakergaming.analytics.presentation

import com.matchmakergaming.analytics.application.AnalyticsService
import com.matchmakergaming.analytics.application.dto.GlobalStatsDTO
import com.matchmakergaming.common.presentation.ApiResponse
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/v1/analytics")
@PreAuthorize("hasRole('ADMIN')")
class AnalyticsController(private val analyticsService: AnalyticsService) {

    @GetMapping("/global")
    fun getGlobalStats(): ResponseEntity<ApiResponse<GlobalStatsDTO>> {
        val stats = analyticsService.getGlobalStats()
        return ResponseEntity.ok(ApiResponse.success(stats, "Statistiques globales récupérées"))
    }
}
