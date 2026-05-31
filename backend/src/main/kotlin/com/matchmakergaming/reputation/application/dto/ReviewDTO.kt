package com.matchmakergaming.reputation.application.dto

import com.matchmakergaming.reputation.domain.model.Badge
import java.time.LocalDateTime

data class ReviewDTO(
    val id: Long?,
    val reviewerId: Long,
    val reviewerPseudo: String,
    val reviewedId: Long,
    val rating: Int,
    val comment: String?,
    val badge: Badge?,
    val createdAt: LocalDateTime
)
