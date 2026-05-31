package com.matchmakergaming.moderation.domain.model

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "reports")
class Report(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @Column(nullable = false)
    val reporterId: Long,

    @Column(nullable = false)
    val reportedId: Long,

    @Column(nullable = false)
    val reason: String,

    @Column(columnDefinition = "TEXT")
    val description: String? = null,

    @Enumerated(EnumType.STRING)
    var status: ReportStatus = ReportStatus.PENDING,

    @Column(nullable = false, updatable = false)
    val createdAt: LocalDateTime = LocalDateTime.now()
)
