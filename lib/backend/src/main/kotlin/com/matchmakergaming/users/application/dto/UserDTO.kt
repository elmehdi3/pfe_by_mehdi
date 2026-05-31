package com.matchmakergaming.users.application.dto

import com.matchmakergaming.users.domain.model.UserRole
import java.time.LocalDateTime

data class UserDTO(
    val uuid: String,
    val email: String,
    val pseudo: String,
    val avatar: String?,
    val bio: String?,
    val country: String?,
    val role: UserRole,
    val isPremium: Boolean,
    val isOnline: Boolean,
    val lastSeen: LocalDateTime
)
