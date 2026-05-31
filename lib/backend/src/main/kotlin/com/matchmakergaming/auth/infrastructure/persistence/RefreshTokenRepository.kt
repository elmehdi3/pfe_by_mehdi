package com.matchmakergaming.auth.infrastructure.persistence

import com.matchmakergaming.auth.domain.model.RefreshToken
import com.matchmakergaming.users.domain.model.User
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Modifying
import org.springframework.stereotype.Repository
import java.util.Optional

@Repository
interface RefreshTokenRepository : JpaRepository<RefreshToken, Long> {
    fun findByToken(token: String): Optional<RefreshToken>
    
    @Modifying
    fun deleteByUser(user: User): Int
}
