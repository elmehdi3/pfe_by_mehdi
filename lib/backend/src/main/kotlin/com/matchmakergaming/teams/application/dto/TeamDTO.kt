package com.matchmakergaming.teams.application.dto

import java.time.LocalDateTime

data class TeamDTO(
    val id: Long?,
    val name: String,
    val logo: String?,
    val description: String?,
    val ownerId: Long,
    val maxMembers: Int,
    val memberCount: Int,
    val visibility: String,
    val createdAt: LocalDateTime
)
