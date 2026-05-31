package com.matchmakergaming.auth.domain.model

import com.matchmakergaming.users.domain.model.User
import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "verification_tokens")
class VerificationToken(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @Column(nullable = false, unique = true)
    val token: String,

    @OneToOne(targetEntity = User::class, fetch = FetchType.EAGER)
    @JoinColumn(nullable = false, name = "user_id")
    val user: User,

    @Column(nullable = false)
    val expiryDate: LocalDateTime = LocalDateTime.now().plusHours(24)
) {
    fun isExpired(): Boolean = LocalDateTime.now().isAfter(expiryDate)
}
