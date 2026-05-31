package com.matchmakergaming.auth.infrastructure.persistence

import com.matchmakergaming.auth.domain.model.VerificationToken
import com.matchmakergaming.users.domain.model.User
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional

@Repository
interface VerificationTokenRepository : JpaRepository<VerificationToken, Long> {
    fun findByToken(token: String): Optional<VerificationToken>
    fun findByUser(user: User): Optional<VerificationToken>
}
