package com.matchmakergaming.security.audit

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface AuditLogRepository : JpaRepository<AuditLog, Long> {
    fun findByUserId(userId: Long): List<AuditLog>
}
