import com.matchmakergaming.common.presentation.ApiResponse
import com.matchmakergaming.notifications.application.NotificationService
import com.matchmakergaming.notifications.application.dto.NotificationDTO
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.web.PageableDefault
import org.springframework.data.domain.Sort
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/v1/notifications")
class NotificationController(private val notificationService: NotificationService) {

    @GetMapping("/user/{userId}")
    fun getNotifications(
        @PathVariable userId: Long,
        @PageableDefault(size = 20, sort = ["createdAt"], direction = Sort.Direction.DESC) pageable: Pageable
    ): ResponseEntity<ApiResponse<Page<NotificationDTO>>> {
        val notifications = notificationService.getUserNotifications(userId, pageable)
        return ResponseEntity.ok(ApiResponse.success(notifications))
    }

    @PatchMapping("/{id}/read")
    fun markAsRead(@PathVariable id: Long): ResponseEntity<ApiResponse<Unit>> {
        notificationService.markAsRead(id)
        return ResponseEntity.ok(ApiResponse.success(Unit, "Notification marquée comme lue"))
    }
}
