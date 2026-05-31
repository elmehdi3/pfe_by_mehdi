package com.matchmakergaming.auth.infrastructure.persistence

import com.matchmakergaming.auth.domain.model.PasswordResetToken
import com.matchmakergaming.users.domain.model.User
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional

@Repository
interface PasswordResetTokenRepository : JpaRepository<PasswordResetToken, Long> {
    fun findByToken(token: String): Optional<PasswordResetToken>
    fun findByUser(user: User): Optional<PasswordResetToken>
}
