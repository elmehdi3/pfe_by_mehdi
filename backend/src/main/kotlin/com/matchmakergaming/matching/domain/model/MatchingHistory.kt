package com.matchmakergaming.matching.domain.model

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "matching_history")
class MatchingHistory(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @Column(nullable = false)
    val userId: Long,

    @Column(nullable = false)
    val matchedUserId: Long,

    @Enumerated(EnumType.STRING)
    val matchingType: MatchingType,

    val compatibilityScore: Int,
    val gameId: Long,

    @Column(nullable = false, updatable = false)
    val createdAt: LocalDateTime = LocalDateTime.now()
)
