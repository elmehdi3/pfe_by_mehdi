package com.matchmakergaming.auth.application

import com.matchmakergaming.auth.domain.model.RefreshToken
import com.matchmakergaming.auth.infrastructure.persistence.RefreshTokenRepository
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.Instant
import java.util.*

@Service
class RefreshTokenService(
    private val refreshTokenRepository: RefreshTokenRepository,
    private val userRepository: UserRepository
) {
    @Value("\${matchmaker.jwt.refreshExpirationMs}")
    private var refreshTokenDurationMs: Long = 0

    fun findByToken(token: String): Optional<RefreshToken> {
        return refreshTokenRepository.findByToken(token)
    }

    @Transactional
    fun createRefreshToken(userId: Long): RefreshToken {
        val user = userRepository.findById(userId).get()
        
        // Delete existing tokens for this user
        refreshTokenRepository.deleteByUser(user)

        val refreshToken = RefreshToken(
            user = user,
            token = UUID.randomUUID().toString(),
            expiryDate = Instant.now().plusMillis(refreshTokenDurationMs)
        )

        return refreshTokenRepository.save(refreshToken)
    }

    fun verifyExpiration(token: RefreshToken): RefreshToken {
        if (token.expiryDate < Instant.now()) {
            refreshTokenRepository.delete(token)
            throw RuntimeException("Refresh token was expired. Please make a new signin request")
        }
        return token
    }
}
