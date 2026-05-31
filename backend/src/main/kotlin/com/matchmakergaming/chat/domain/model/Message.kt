package com.matchmakergaming.chat.domain.model

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "messages")
class Message(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @Column(nullable = false)
    val conversationId: Long,

    @Column(nullable = false)
    val senderId: Long,

    @Column(columnDefinition = "TEXT")
    var content: String,

    @Enumerated(EnumType.STRING)
    var messageType: MessageType = MessageType.TEXT,

    var isRead: Boolean = false,

    @Column(nullable = false, updatable = false)
    val createdAt: LocalDateTime = LocalDateTime.now()
)
