package com.matchmakergaming.premium.domain.model

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "subscriptions")
class Subscription(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @Column(nullable = false)
    val userId: Long,

    @Enumerated(EnumType.STRING)
    var plan: SubscriptionPlan = SubscriptionPlan.FREE,

    var price: Double = 0.0,
    var status: String = "ACTIVE",

    @Column(nullable = false)
    val startDate: LocalDateTime = LocalDateTime.now(),

    var endDate: LocalDateTime? = null,

    @Column(nullable = false, updatable = false)
    val createdAt: LocalDateTime = LocalDateTime.now()
)
