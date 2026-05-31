package com.matchmakergaming.users.application.dto

import java.time.LocalDateTime

data class DeviceDTO(
    val id: Long?,
    val deviceType: String?,
    val lastLogin: LocalDateTime,
    val isActive: Boolean
)
