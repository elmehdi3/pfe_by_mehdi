package com.matchmakergaming.games.application.dto

import com.matchmakergaming.games.domain.model.Platform

data class GameDTO(
    val id: Long?,
    val name: String,
    val slug: String,
    val description: String?,
    val logo: String?,
    val banner: String?,
    val category: String?,
    val platforms: Set<Platform>,
    val isPopular: Boolean
)
