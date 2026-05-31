package com.matchmakergaming.moderation.application

import com.matchmakergaming.moderation.application.dto.ReportDTO
import com.matchmakergaming.moderation.application.mapper.ReportMapper
import com.matchmakergaming.moderation.domain.model.Report
import com.matchmakergaming.moderation.domain.model.ReportStatus
import com.matchmakergaming.moderation.infrastructure.persistence.ReportRepository
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import com.matchmakergaming.security.audit.AuditService
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class ModerationService(
    private val reportRepository: ReportRepository,
    private val userRepository: UserRepository,
    private val auditService: AuditService,
    private val reportMapper: ReportMapper
) {

    @Transactional
    fun submitReport(report: Report): ReportDTO {
        val savedReport = reportRepository.save(report)
        val reporter = userRepository.findById(report.reporterId).orElseThrow { RuntimeException("Rapporteur non trouvé") }
        val reported = userRepository.findById(report.reportedId).orElseThrow { RuntimeException("Utilisateur signalé non trouvé") }
        
        auditService.log(report.reporterId, "REPORT_SUBMITTED", "Signalement créé contre ${reported.pseudo}")
        return reportMapper.toDTO(savedReport, reporter, reported)
    }

    @Transactional
    fun resolveReport(reportId: Long, status: ReportStatus): ReportDTO {
        val report = reportRepository.findById(reportId)
            .orElseThrow { RuntimeException("Signalement non trouvé") }
        
        report.status = status
        val savedReport = reportRepository.save(report)
        
        val reporter = userRepository.findById(report.reporterId).get()
        val reported = userRepository.findById(report.reportedId).get()
        
        auditService.log(null, "REPORT_RESOLVED", "Signalement $reportId résolu avec le statut $status")
        return reportMapper.toDTO(savedReport, reporter, reported)
    }

    @Transactional
    fun banUser(userId: Long, reason: String?) {
        val user = userRepository.findById(userId)
            .orElseThrow { RuntimeException("Utilisateur non trouvé") }
        
        user.status = "BANNED"
        userRepository.save(user)
        
        auditService.log(userId, "USER_BAN", "Utilisateur ${user.pseudo} banni. Raison : $reason")
    }

    /**
     * Récupération paginée des signalements filtrés par statut.
     */
    fun getPendingReports(pageable: Pageable): Page<ReportDTO> {
        val reports = reportRepository.findByStatus(ReportStatus.PENDING, pageable)
        return reports.map { report ->
            val reporter = userRepository.findById(report.reporterId).get()
            val reported = userRepository.findById(report.reportedId).get()
            reportMapper.toDTO(report, reporter, reported)
        }
    }
}
