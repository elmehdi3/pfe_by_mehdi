package com.matchmakergaming.profiles.domain.model

import com.matchmakergaming.users.domain.model.User
import com.matchmakergaming.reputation.domain.model.Badge
import jakarta.persistence.*

@Entity
@Table(name = "player_profiles")
class PlayerProfile(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    val user: User,

    var bio: String? = null,

    @Enumerated(EnumType.STRING)
    var level: PlayerLevel = PlayerLevel.BEGINNER,

    @ElementCollection
    @CollectionTable(name = "profile_languages", joinColumns = [JoinColumn(name = "profile_id")])
    @Column(name = "language")
    var languages: MutableSet<String> = mutableSetOf(),

    var availability: String? = null,

    var discord: String? = null,
    var steam: String? = null,
    var riotId: String? = null,
    var xboxGamertag: String? = null,
    var psn: String? = null,

    var reputationScore: Double = 5.0,
    var totalReviews: Int = 0,

    @ElementCollection(targetClass = Badge::class)
    @CollectionTable(name = "profile_badges", joinColumns = [JoinColumn(name = "profile_id")])
    @Enumerated(EnumType.STRING)
    @Column(name = "badge")
    var badges: MutableSet<Badge> = mutableSetOf(),

    @Embedded
    var statistics: PlayerStatistics = PlayerStatistics()
)
