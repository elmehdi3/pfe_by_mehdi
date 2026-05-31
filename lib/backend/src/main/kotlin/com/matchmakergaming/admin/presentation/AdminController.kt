package com.matchmakergaming.admin.presentation

import com.matchmakergaming.analytics.application.AnalyticsService
import com.matchmakergaming.analytics.application.RealTimeStatsService
import com.matchmakergaming.analytics.application.dto.GlobalStatsDTO
import com.matchmakergaming.common.presentation.ApiResponse
import com.matchmakergaming.users.application.dto.UserDTO
import com.matchmakergaming.users.application.mapper.UserMapper
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import com.matchmakergaming.moderation.application.ModerationService
import com.matchmakergaming.moderation.application.dto.ReportDTO
import com.matchmakergaming.security.audit.AuditLog
import com.matchmakergaming.security.audit.AuditLogRepository
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.web.PageableDefault
import org.springframework.data.domain.Sort
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/v1/admin")
@PreAuthorize("hasRole('ADMIN')")
class AdminController(
    private val analyticsService: AnalyticsService,
    private val realTimeStatsService: RealTimeStatsService,
    private val userRepository: UserRepository,
    private val moderationService: ModerationService,
    private val auditLogRepository: AuditLogRepository,
    private val userMapper: UserMapper
) {

    /**
     * Statistiques consolidées (Batch de la veille)
     */
    @GetMapping("/stats/global")
    fun getGlobalStats(): ResponseEntity<ApiResponse<GlobalStatsDTO>> {
        return ResponseEntity.ok(ApiResponse.success(analyticsService.getGlobalStats()))
    }

    /**
     * Statistiques "Live" (Redis) pour monitoring instantané
     */
    @GetMapping("/stats/live")
    fun getLiveStats(): ResponseEntity<ApiResponse<Map<String, Any>>> {
        return ResponseEntity.ok(ApiResponse.success(realTimeStatsService.getLiveSnapshot()))
    }

    @GetMapping("/users")
    fun getAllUsers(
        @PageableDefault(size = 50) pageable: Pageable
    ): ResponseEntity<ApiResponse<Page<UserDTO>>> {
        val usersPage = userRepository.findAll(pageable).map { userMapper.toDTO(it) }
        return ResponseEntity.ok(ApiResponse.success(usersPage))
    }

    /**
     * Consultation des journaux d'audit pour la sécurité
     */
    @GetMapping("/audit-logs")
    fun getAuditLogs(
        @PageableDefault(size = 20, sort = ["createdAt"], direction = Sort.Direction.DESC) pageable: Pageable
    ): ResponseEntity<ApiResponse<Page<AuditLog>>> {
        return ResponseEntity.ok(ApiResponse.success(auditLogRepository.findAll(pageable)))
    }

    @PostMapping("/users/{id}/ban")
    fun banUser(@PathVariable id: Long, @RequestParam(required = false) reason: String?): ResponseEntity<ApiResponse<Unit>> {
        moderationService.banUser(id, reason)
        return ResponseEntity.ok(ApiResponse.success(Unit, "Utilisateur banni avec succès"))
    }

    @GetMapping("/reports/pending")
    fun getPendingReports(
        @PageableDefault(size = 20) pageable: Pageable
    ): ResponseEntity<ApiResponse<Page<ReportDTO>>> {
        return ResponseEntity.ok(ApiResponse.success(moderationService.getPendingReports(pageable)))
    }
}
