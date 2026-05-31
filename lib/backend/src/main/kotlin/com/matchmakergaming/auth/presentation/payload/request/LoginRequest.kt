package com.matchmakergaming.auth.presentation.payload.request

import jakarta.validation.constraints.NotBlank

data class LoginRequest(
    @field:NotBlank
    val pseudo: String,

    @field:NotBlank
    val password: String
)
