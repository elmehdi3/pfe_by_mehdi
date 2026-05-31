package com.matchmakergaming.users.domain.model

import jakarta.persistence.*
import java.time.LocalDate
import java.time.LocalDateTime
import java.util.UUID

@Entity
@Table(name = "users")
class User(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @Column(unique = true, nullable = false)
    val uuid: String = UUID.randomUUID().toString(),

    @Column(unique = true, nullable = false)
    var email: String,

    @Column(nullable = false)
    var password: String,

    @Column(unique = true, nullable = false)
    var pseudo: String,

    var avatar: String? = null,
    var bio: String? = null,
    var country: String? = null,
    var region: String? = null,
    var birthDate: LocalDate? = null,
    var gender: String? = null,

    @Enumerated(EnumType.STRING)
    var role: UserRole = UserRole.ROLE_USER,

    var status: String = "ACTIVE",
    var isPremium: Boolean = false,
    var isVerified: Boolean = false,
    var is2faEnabled: Boolean = false,
    var isOnline: Boolean = false,
    var lastSeen: LocalDateTime = LocalDateTime.now(),

    @Column(nullable = false, updatable = false)
    val createdAt: LocalDateTime = LocalDateTime.now(),

    var updatedAt: LocalDateTime = LocalDateTime.now(),
    var deletedAt: LocalDateTime? = null
)
