package com.matchmakergaming.teams.domain.model

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "teams")
class Team(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @Column(nullable = false)
    var name: String,

    var logo: String? = null,
    var description: String? = null,

    @Column(nullable = false)
    var ownerId: Long,

    var maxMembers: Int = 5,
    var visibility: String = "PUBLIC", // PUBLIC, PRIVATE

    @Column(nullable = false, updatable = false)
    val createdAt: LocalDateTime = LocalDateTime.now()
)
