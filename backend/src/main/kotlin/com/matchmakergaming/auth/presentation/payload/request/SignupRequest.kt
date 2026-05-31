package com.matchmakergaming.auth.presentation.payload.request

import jakarta.validation.constraints.*

data class SignupRequest(
    @field:NotBlank
    @field:Size(min = 3, max = 20)
    val pseudo: String,

    @field:NotBlank
    @field:Size(max = 50)
    @field:Email
    val email: String,

    @field:NotBlank
    @field:Size(min = 6, max = 40)
    val password: String,

    val role: Set<String>? = null
)
