package com.matchmakergaming.premium.application.dto

import com.matchmakergaming.premium.domain.model.SubscriptionPlan
import java.time.LocalDateTime

data class SubscriptionDTO(
    val id: Long?,
    val userId: Long,
    val plan: SubscriptionPlan,
    val status: String,
    val startDate: LocalDateTime,
    val endDate: LocalDateTime?,
    val isActive: Boolean
)
