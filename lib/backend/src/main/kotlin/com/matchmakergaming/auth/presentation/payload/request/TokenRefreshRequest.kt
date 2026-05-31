package com.matchmakergaming.auth.presentation.payload.request

import jakarta.validation.constraints.NotBlank

data class TokenRefreshRequest(
    @field:NotBlank
    val refreshToken: String
)
