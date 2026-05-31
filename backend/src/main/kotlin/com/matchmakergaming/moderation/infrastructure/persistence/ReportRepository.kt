package com.matchmakergaming.moderation.infrastructure.persistence

import com.matchmakergaming.moderation.domain.model.Report
import com.matchmakergaming.moderation.domain.model.ReportStatus
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface ReportRepository : JpaRepository<Report, Long> {
    fun findByStatus(status: ReportStatus): List<Report>
    fun findByReportedId(reportedId: Long): List<Report>
}
