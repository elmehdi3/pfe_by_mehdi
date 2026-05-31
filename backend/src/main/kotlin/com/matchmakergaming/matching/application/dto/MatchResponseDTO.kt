package com.matchmakergaming.matching.application.dto

import com.matchmakergaming.profiles.application.dto.PlayerProfileDTO

data class MatchResponseDTO(
    val player: PlayerProfileDTO,
    val compatibilityScore: Int,
    val matchingType: String,
    val matchedAt: String
)
