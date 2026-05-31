package com.matchmakergaming.matching.application.dto

import com.matchmakergaming.matching.domain.model.MatchingType
import java.time.LocalDateTime

data class MatchingHistoryDTO(
    val id: Long?,
    val matchedUserId: Long,
    val matchedUserPseudo: String,
    val matchedUserAvatar: String?,
    val type: MatchingType,
    val compatibilityScore: Int,
    val gameName: String,
    val createdAt: LocalDateTime
)
