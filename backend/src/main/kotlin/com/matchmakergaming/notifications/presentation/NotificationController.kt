package com.matchmakergaming.notifications.presentation

import com.matchmakergaming.common.presentation.ApiResponse
import com.matchmakergaming.notifications.application.NotificationService
import com.matchmakergaming.notifications.application.dto.NotificationDTO
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/v1/notifications")
class NotificationController(private val notificationService: NotificationService) {

    @GetMapping("/user/{userId}")
    fun getNotifications(@PathVariable userId: Long): ResponseEntity<ApiResponse<List<NotificationDTO>>> {
        val notifications = notificationService.getUserNotifications(userId)
        return ResponseEntity.ok(ApiResponse.success(notifications))
    }

    @PatchMapping("/{id}/read")
    fun markAsRead(@PathVariable id: Long): ResponseEntity<ApiResponse<Void>> {
        notificationService.markAsRead(id)
        return ResponseEntity.ok(ApiResponse.success(null, "Notification marquée comme lue"))
    }
}
