package com.matchmakergaming.invitations.infrastructure.persistence

import com.matchmakergaming.invitations.domain.model.Invitation
import com.matchmakergaming.invitations.domain.model.InvitationStatus
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface InvitationRepository : JpaRepository<Invitation, Long> {
    fun findByReceiverIdAndStatus(receiverId: Long, status: InvitationStatus): List<Invitation>
    fun findBySenderId(senderId: Long): List<Invitation>
}
