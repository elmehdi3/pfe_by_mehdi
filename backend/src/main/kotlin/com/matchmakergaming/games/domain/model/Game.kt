package com.matchmakergaming.games.domain.model

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "games")
class Game(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @Column(nullable = false, unique = true)
    var name: String,

    @Column(nullable = false, unique = true)
    var slug: String,

    var description: String? = null,
    var logo: String? = null,
    var banner: String? = null,
    var category: String? = null,

    @ElementCollection(targetClass = Platform::class)
    @CollectionTable(name = "game_platforms", joinColumns = [JoinColumn(name = "game_id")])
    @Enumerated(EnumType.STRING)
    @Column(name = "platform")
    var platforms: Set<Platform> = emptySet(),

    var isPopular: Boolean = false,
    var isActive: Boolean = true,

    @Column(nullable = false, updatable = false)
    val createdAt: LocalDateTime = LocalDateTime.now(),

    var updatedAt: LocalDateTime = LocalDateTime.now()
)
