package com.matchmakergaming.auth.presentation.payload.request

import jakarta.validation.constraints.NotBlank

data class SocialLoginRequest(
    @field:NotBlank
    val idToken: String,
    
    @field:NotBlank
    val provider: String
)
