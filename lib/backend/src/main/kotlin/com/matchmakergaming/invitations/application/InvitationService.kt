package com.matchmakergaming.invitations.application

import com.matchmakergaming.friends.application.FriendService
import com.matchmakergaming.invitations.application.dto.InvitationDTO
import com.matchmakergaming.invitations.application.mapper.InvitationMapper
import com.matchmakergaming.invitations.domain.model.Invitation
import com.matchmakergaming.invitations.domain.model.InvitationStatus
import com.matchmakergaming.invitations.domain.model.InvitationType
import com.matchmakergaming.invitations.infrastructure.persistence.InvitationRepository
import com.matchmakergaming.teams.application.TeamService
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class InvitationService(
    private val invitationRepository: InvitationRepository,
    private val userRepository: UserRepository,
    private val invitationMapper: InvitationMapper,
    private val teamService: TeamService,
    private val friendService: FriendService
) {

    @Transactional
    fun sendInvitation(senderId: Long, receiverId: Long, type: InvitationType, targetId: Long?, message: String?): InvitationDTO {
        val invitation = Invitation(
            senderId = senderId,
            receiverId = receiverId,
            type = type,
            targetId = targetId,
            message = message,
            status = InvitationStatus.PENDING
        )
        val saved = invitationRepository.save(invitation)
        val sender = userRepository.findById(senderId).orElseThrow { RuntimeException("Sender not found") }
        return invitationMapper.toDTO(saved, sender)
    }

    @Transactional
    fun updateInvitationStatus(invitationId: Long, status: InvitationStatus): InvitationDTO {
        val invitation = invitationRepository.findById(invitationId)
            .orElseThrow { RuntimeException("Invitation not found") }
        
        invitation.status = status
        val saved = invitationRepository.save(invitation)

        // Logique métier spécifique lors de l'acceptation
        if (status == InvitationStatus.ACCEPTED) {
            when (invitation.type) {
                InvitationType.TEAM_INVITE -> {
                    invitation.targetId?.let { teamService.addMember(it, invitation.receiverId) }
                }
                InvitationType.FRIEND_REQUEST -> {
                    friendService.acceptFriendRequest(invitation.receiverId, invitation.senderId)
                }
                InvitationType.MATCH_INVITE -> {
                    // Logique pour créer une session de jeu ou une conversation
                }
            }
        }

        val sender = userRepository.findById(invitation.senderId).get()
        return invitationMapper.toDTO(saved, sender)
    }

    fun getPendingInvitations(userId: Long): List<InvitationDTO> {
        return invitationRepository.findByReceiverIdAndStatus(userId, InvitationStatus.PENDING).map { 
            val sender = userRepository.findById(it.senderId).get()
            invitationMapper.toDTO(it, sender)
        }
    }
}
