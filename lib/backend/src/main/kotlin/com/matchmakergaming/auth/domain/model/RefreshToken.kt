package com.matchmakergaming.auth.domain.model

import com.matchmakergaming.users.domain.model.User
import jakarta.persistence.*
import java.time.Instant

@Entity(name = "refresh_token")
class RefreshToken(
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    var id: Long = 0,

    @OneToOne
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    var user: User,

    @Column(nullable = false, unique = true)
    var token: String,

    @Column(nullable = false)
    var expiryDate: Instant
)
