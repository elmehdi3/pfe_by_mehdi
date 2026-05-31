package com.matchmakergaming.auth.presentation.payload.response

data class TokenRefreshResponse(
    val accessToken: String,
    val refreshToken: String,
    val tokenType: String = "Bearer"
)
