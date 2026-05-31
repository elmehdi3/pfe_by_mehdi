package com.matchmakergaming.chat.domain.model

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "conversations")
class Conversation(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @Enumerated(EnumType.STRING)
    var type: ConversationType = ConversationType.PRIVATE,

    val teamId: Long? = null, // Référence à l'équipe pour les conversations de type TEAM

    @Column(nullable = false, updatable = false)
    val createdAt: LocalDateTime = LocalDateTime.now(),

    var updatedAt: LocalDateTime = LocalDateTime.now()
)
