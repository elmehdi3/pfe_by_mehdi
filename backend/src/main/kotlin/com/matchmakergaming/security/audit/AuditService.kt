package com.matchmakergaming.security.audit

import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import jakarta.servlet.http.HttpServletRequest

@Service
class AuditService(private val auditLogRepository: AuditLogRepository) {

    @Transactional
    fun log(userId: Long?, action: String, details: String?, ipAddress: String? = null) {
        val log = AuditLog(
            userId = userId,
            action = action,
            details = details,
            ipAddress = ipAddress
        )
        auditLogRepository.save(log)
    }
}
