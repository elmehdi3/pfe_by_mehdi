package com.matchmakergaming.teams.application.dto

import com.matchmakergaming.teams.domain.model.TeamMemberRole
import java.time.LocalDateTime

data class TeamMemberDTO(
    val id: Long?,
    val userId: Long,
    val pseudo: String,
    val avatar: String?,
    val role: TeamMemberRole,
    val joinedAt: LocalDateTime
)
