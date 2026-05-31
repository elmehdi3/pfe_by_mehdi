package com.matchmakergaming.premium.infrastructure.persistence

import com.matchmakergaming.premium.domain.model.Subscription
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface SubscriptionRepository : JpaRepository<Subscription, Long> {
    fun countByStatus(status: String): Long
}
