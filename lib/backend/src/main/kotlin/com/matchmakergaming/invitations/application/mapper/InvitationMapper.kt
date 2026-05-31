package com.matchmakergaming.invitations.application.mapper

import com.matchmakergaming.invitations.application.dto.InvitationDTO
import com.matchmakergaming.invitations.domain.model.Invitation
import com.matchmakergaming.users.domain.model.User
import org.springframework.stereotype.Component

@Component
class InvitationMapper {
    fun toDTO(invitation: Invitation, sender: User): InvitationDTO {
        return InvitationDTO(
            id = invitation.id,
            senderId = invitation.senderId,
            senderPseudo = sender.pseudo,
            receiverId = invitation.receiverId,
            type = invitation.type,
            targetId = invitation.targetId,
            message = invitation.message,
            status = invitation.status,
            createdAt = invitation.createdAt,
            expiresAt = invitation.expiresAt
        )
    }
}
