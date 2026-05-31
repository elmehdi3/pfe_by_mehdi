package com.matchmakergaming.moderation.application.mapper

import com.matchmakergaming.moderation.application.dto.ReportDTO
import com.matchmakergaming.moderation.domain.model.Report
import com.matchmakergaming.users.domain.model.User
import org.springframework.stereotype.Component

@Component
class ReportMapper {
    fun toDTO(report: Report, reporter: User, reported: User): ReportDTO {
        return ReportDTO(
            id = report.id,
            reporterId = report.reporterId,
            reporterPseudo = reporter.pseudo,
            reportedId = report.reportedId,
            reportedPseudo = reported.pseudo,
            reason = report.reason,
            description = report.description,
            status = report.status,
            createdAt = report.createdAt
        )
    }

    fun toDTOList(reports: List<Report>, userRepository: com.matchmakergaming.users.infrastructure.persistence.UserRepository): List<ReportDTO> {
        return reports.map { report ->
            val reporter = userRepository.findById(report.reporterId).orElseThrow { RuntimeException("Reporter not found") }
            val reported = userRepository.findById(report.reportedId).orElseThrow { RuntimeException("Reported user not found") }
            toDTO(report, reporter, reported)
        }
    }
}
