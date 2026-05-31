package com.matchmakergaming.premium.application.mapper

import com.matchmakergaming.premium.application.dto.SubscriptionDTO
import com.matchmakergaming.premium.domain.model.Subscription
import org.springframework.stereotype.Component
import java.time.LocalDateTime

@Component
class SubscriptionMapper {
    fun toDTO(subscription: Subscription): SubscriptionDTO {
        return SubscriptionDTO(
            id = subscription.id,
            userId = subscription.userId,
            plan = subscription.plan,
            status = subscription.status,
            startDate = subscription.startDate,
            endDate = subscription.endDate,
            isActive = isCurrentlyActive(subscription)
        )
    }

    private fun isCurrentlyActive(sub: Subscription): Boolean {
        return sub.status == "ACTIVE" && (sub.endDate == null || sub.endDate!!.isAfter(LocalDateTime.now()))
    }
}
