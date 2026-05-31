package com.matchmakergaming.auth.presentation.payload.response

data class JwtResponse(
    val token: String,
    val refreshToken: String,
    val id: Long,
    val pseudo: String,
    val email: String,
    val roles: List<String>,
    val type: String = "Bearer"
)
