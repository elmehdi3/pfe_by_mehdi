package com.matchmakergaming.invitations.application.dto

import com.matchmakergaming.invitations.domain.model.InvitationStatus
import com.matchmakergaming.invitations.domain.model.InvitationType
import java.time.LocalDateTime

data class InvitationDTO(
    val id: Long?,
    val senderId: Long,
    val senderPseudo: String,
    val receiverId: Long,
    val type: InvitationType,
    val targetId: Long?,
    val message: String?,
    val status: InvitationStatus,
    val createdAt: LocalDateTime,
    val expiresAt: LocalDateTime
)
