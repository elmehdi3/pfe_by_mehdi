package com.matchmakergaming.chat.domain.model

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "conversation_participants")
class ConversationParticipant(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @Column(nullable = false)
    val conversationId: Long,

    @Column(nullable = false)
    val userId: Long,

    var lastReadAt: LocalDateTime = LocalDateTime.now(),
    
    @Column(nullable = false, updatable = false)
    val joinedAt: LocalDateTime = LocalDateTime.now()
)
