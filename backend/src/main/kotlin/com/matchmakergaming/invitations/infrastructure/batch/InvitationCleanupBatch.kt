package com.matchmakergaming.invitations.infrastructure.batch

import com.matchmakergaming.invitations.domain.model.InvitationStatus
import com.matchmakergaming.invitations.infrastructure.persistence.InvitationRepository
import org.slf4j.LoggerFactory
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDateTime

@Component
class InvitationCleanupBatch(private val invitationRepository: InvitationRepository) {
    private val logger = LoggerFactory.getLogger(InvitationCleanupBatch::class.java)

    @Scheduled(cron = "0 0 * * * *") // Every hour
    @Transactional
    fun expireInvitations() {
        logger.info("Starting invitation cleanup batch...")
        val pendingInvitations = invitationRepository.findAll().filter { 
            it.status == InvitationStatus.PENDING && it.expiresAt.isBefore(LocalDateTime.now()) 
        }
        
        pendingInvitations.forEach {
            it.status = InvitationStatus.EXPIRED
        }
        
        invitationRepository.saveAll(pendingInvitations)
        logger.info("Expired ${pendingInvitations.size} invitations.")
    }
}
