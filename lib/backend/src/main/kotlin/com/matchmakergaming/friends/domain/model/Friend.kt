package com.matchmakergaming.friends.domain.model

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "friends")
class Friend(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @Column(nullable = false)
    val userId: Long,

    @Column(nullable = false)
    val friendId: Long,

    @Enumerated(EnumType.STRING)
    var status: FriendStatus = FriendStatus.PENDING,

    @Column(nullable = false, updatable = false)
    val createdAt: LocalDateTime = LocalDateTime.now()
)
