package com.matchmakergaming.invitations.domain.model

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "invitations")
class Invitation(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @Column(nullable = false)
    val senderId: Long,

    @Column(nullable = false)
    val receiverId: Long,

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    var type: InvitationType = InvitationType.MATCH_INVITE,

    val targetId: Long? = null, // ID de l'équipe ou du jeu concerné

    var message: String? = null,

    @Enumerated(EnumType.STRING)
    var status: InvitationStatus = InvitationStatus.PENDING,

    @Column(nullable = false, updatable = false)
    val createdAt: LocalDateTime = LocalDateTime.now(),

    var expiresAt: LocalDateTime = LocalDateTime.now().plusDays(1)
)
