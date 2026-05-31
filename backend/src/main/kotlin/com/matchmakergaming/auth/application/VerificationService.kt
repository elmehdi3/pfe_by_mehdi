package com.matchmakergaming.auth.application

import com.matchmakergaming.auth.domain.model.VerificationToken
import com.matchmakergaming.auth.infrastructure.persistence.VerificationTokenRepository
import com.matchmakergaming.common.infrastructure.email.EmailService
import com.matchmakergaming.users.domain.model.User
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.security.SecureRandom
import java.util.*

@Service
class VerificationService(
    private val tokenRepository: VerificationTokenRepository,
    private val userRepository: UserRepository,
    private val emailService: EmailService
) {

    private val random = SecureRandom()

    @Transactional
    fun createVerificationToken(user: User): String {
        // Generate a 6-digit numeric code for easier mobile entry
        val code = String.format("%06d", random.nextInt(1000000))
        
        // Remove old token if exists
        tokenRepository.findByUser(user).ifPresent { tokenRepository.delete(it) }

        val verificationToken = VerificationToken(
            token = code,
            user = user
        )
        
        tokenRepository.save(verificationToken)
        emailService.sendVerificationEmail(user.email, code)
        
        return code
    }

    @Transactional
    fun verifyUser(token: String): Boolean {
        val verificationToken = tokenRepository.findByToken(token)
            .orElse(null) ?: return false

        if (verificationToken.isExpired()) {
            tokenRepository.delete(verificationToken)
            return false
        }

        val user = verificationToken.user
        user.isVerified = true
        userRepository.save(user)
        
        tokenRepository.delete(verificationToken)
        return true
    }
}
