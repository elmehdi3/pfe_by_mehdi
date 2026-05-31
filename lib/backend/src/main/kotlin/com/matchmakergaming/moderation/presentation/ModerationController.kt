package com.matchmakergaming.moderation.presentation

import com.matchmakergaming.common.presentation.ApiResponse
import com.matchmakergaming.moderation.application.ModerationService
import com.matchmakergaming.moderation.application.dto.ReportDTO
import com.matchmakergaming.moderation.domain.model.Report
import com.matchmakergaming.moderation.domain.model.ReportStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/v1/reports")
class ModerationController(private val moderationService: ModerationService) {

    @PostMapping
    fun submitReport(@RequestBody report: Report): ResponseEntity<ApiResponse<ReportDTO>> {
        val result = moderationService.submitReport(report)
        return ResponseEntity.ok(ApiResponse.success(result, "Signalement envoyé. Merci de nous aider à garder la communauté saine."))
    }

    @PatchMapping("/{id}/resolve")
    fun resolveReport(
        @PathVariable id: Long,
        @RequestParam status: ReportStatus
    ): ResponseEntity<ApiResponse<ReportDTO>> {
        val result = moderationService.resolveReport(id, status)
        return ResponseEntity.ok(ApiResponse.success(result, "Signalement traité avec succès"))
    }
}
