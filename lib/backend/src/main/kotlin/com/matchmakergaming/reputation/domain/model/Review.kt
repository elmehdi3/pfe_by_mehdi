package com.matchmakergaming.reputation.domain.model

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "reviews")
class Review(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @Column(nullable = false)
    val reviewerId: Long,

    @Column(nullable = false)
    val reviewedId: Long,

    @Column(nullable = false)
    var rating: Int, // 1 to 5

    var comment: String? = null,

    @Enumerated(EnumType.STRING)
    var badge: Badge? = null,

    @Column(nullable = false, updatable = false)
    val createdAt: LocalDateTime = LocalDateTime.now()
)
