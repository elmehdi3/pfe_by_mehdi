package com.matchmakergaming.analytics.application.dto

import java.time.LocalDateTime

data class GlobalStatsDTO(
    val totalUsers: Long,
    val activeUsers24h: Long,
    val totalMatchesCreated: Long,
    val totalMessagesSent: Long,
    val premiumConversionRate: Double,
    val totalRevenue: Double,
    val lastUpdate: LocalDateTime = LocalDateTime.now()
)
