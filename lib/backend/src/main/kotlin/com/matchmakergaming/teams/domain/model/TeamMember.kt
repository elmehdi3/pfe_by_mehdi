package com.matchmakergaming.teams.domain.model

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "team_members")
class TeamMember(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @Column(nullable = false)
    val teamId: Long,

    @Column(nullable = false)
    val userId: Long,

    @Enumerated(EnumType.STRING)
    var role: TeamMemberRole = TeamMemberRole.MEMBER,

    @Column(nullable = false, updatable = false)
    val joinedAt: LocalDateTime = LocalDateTime.now()
)
