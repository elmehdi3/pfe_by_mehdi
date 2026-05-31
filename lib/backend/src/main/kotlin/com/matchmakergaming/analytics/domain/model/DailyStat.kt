package com.matchmakergaming.analytics.domain.model

import jakarta.persistence.*
import java.time.LocalDate

@Entity
@Table(name = "daily_stats")
class DailyStat(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @Column(nullable = false, unique = true)
    val date: LocalDate,

    val newUsers: Long,
    val matchesCreated: Long,
    val messagesSent: Long,
    val activeUsers: Long,
    val revenue: Double
)
