package com.matchmakergaming.security.audit

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "audit_logs")
class AuditLog(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    val userId: Long?,
    val action: String,
    val details: String?,
    val ipAddress: String?,
    val createdAt: LocalDateTime = LocalDateTime.now()
)
