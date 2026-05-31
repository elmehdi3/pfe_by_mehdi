package com.matchmakergaming.profiles.application.dto

import com.matchmakergaming.profiles.domain.model.PlayerLevel
import com.matchmakergaming.profiles.domain.model.PlayerStatistics
import com.matchmakergaming.reputation.domain.model.Badge

data class PlayerProfileDTO(
    val id: Long?,
    val userId: Long,
    val pseudo: String,
    val bio: String?,
    val level: PlayerLevel,
    val languages: Set<String>,
    val availability: String?,
    val reputationScore: Double,
    val totalReviews: Int,
    val badges: Set<Badge>,
    val statistics: PlayerStatistics,
    val platforms: Map<String, String?>,
    val isOnline: Boolean,
    val lastSeen: String
)
