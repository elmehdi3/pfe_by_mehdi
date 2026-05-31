package com.matchmakergaming.moderation.application.dto

import com.matchmakergaming.moderation.domain.model.ReportStatus
import java.time.LocalDateTime

data class ReportDTO(
    val id: Long?,
    val reporterId: Long,
    val reporterPseudo: String,
    val reportedId: Long,
    val reportedPseudo: String,
    val reason: String,
    val description: String?,
    val status: ReportStatus,
    val createdAt: LocalDateTime
)
