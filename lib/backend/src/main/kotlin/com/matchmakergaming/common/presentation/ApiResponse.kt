package com.matchmakergaming.common.presentation

import java.time.LocalDateTime

data class ApiResponse<T>(
    val success: Boolean,
    val message: String? = null,
    val data: T? = null,
    val timestamp: LocalDateTime = LocalDateTime.now()
) {
    companion object {
        fun <T> success(data: T, message: String? = null): ApiResponse<T> {
            return ApiResponse(true, message, data)
        }

        fun <T> error(message: String): ApiResponse<T> {
            return ApiResponse(false, message, null)
        }
    }
}
