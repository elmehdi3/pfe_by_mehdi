package com.matchmakergaming.invitations.presentation

import com.matchmakergaming.common.presentation.ApiResponse
import com.matchmakergaming.invitations.application.InvitationService
import com.matchmakergaming.invitations.application.dto.InvitationDTO
import com.matchmakergaming.invitations.domain.model.InvitationStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/v1/invitations")
class InvitationController(private val invitationService: InvitationService) {

    @PostMapping("/send")
    fun sendInvitation(
        @RequestParam senderId: Long,
        @RequestParam receiverId: Long,
        @RequestParam(required = false) message: String?
    ): ResponseEntity<ApiResponse<InvitationDTO>> {
        val result = invitationService.sendInvitation(senderId, receiverId, message)
        return ResponseEntity.ok(ApiResponse.success(result, "Invitation envoyée avec succès"))
    }

    @PatchMapping("/{id}/status")
    fun updateStatus(
        @PathVariable id: Long,
        @RequestParam status: InvitationStatus
    ): ResponseEntity<ApiResponse<InvitationDTO>> {
        val result = invitationService.updateInvitationStatus(id, status)
        return ResponseEntity.ok(ApiResponse.success(result, "Statut de l'invitation mis à jour"))
    }

    @GetMapping("/pending/{userId}")
    fun getPendingInvitations(@PathVariable userId: Long): ResponseEntity<ApiResponse<List<InvitationDTO>>> {
        val result = invitationService.getPendingInvitations(userId)
        return ResponseEntity.ok(ApiResponse.success(result))
    }
}
