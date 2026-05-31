package com.matchmakergaming.users.domain.model

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "user_devices")
class UserDevice(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @Column(nullable = false)
    val userId: Long,

    @Column(nullable = false)
    val deviceToken: String, // FCM Token

    val deviceType: String? = null, // IOS, ANDROID, WEB
    val lastLogin: LocalDateTime = LocalDateTime.now(),
    var isActive: Boolean = true
)
