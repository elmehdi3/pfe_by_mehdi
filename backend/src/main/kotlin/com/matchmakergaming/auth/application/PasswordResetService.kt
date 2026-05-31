package com.matchmakergaming.auth.application

import com.matchmakergaming.auth.domain.model.PasswordResetToken
import com.matchmakergaming.auth.infrastructure.persistence.PasswordResetTokenRepository
import com.matchmakergaming.common.infrastructure.email.EmailService
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class PasswordResetService(
    private val tokenRepository: PasswordResetTokenRepository,
    private val userRepository: UserRepository,
    private val emailService: EmailService,
    private val passwordEncoder: PasswordEncoder
) {

    @Transactional
    fun createResetToken(email: String) {
        val user = userRepository.findByEmail(email)
            .orElseThrow { RuntimeException("User not found with email: ${email}") }

        // Remove existing token
        tokenRepository.findByUser(user).ifPresent { tokenRepository.delete(it) }

        val token = PasswordResetToken(user = user)
        tokenRepository.save(token)

        val resetLink = "https://matchmakergaming.com/reset-password?token=${token.token}"
        val body = """
            <h1>Réinitialisation de votre mot de passe</h1>
            <p>Cliquez sur le lien ci-dessous pour réinitialiser votre mot de passe :</p>
            <a href="$resetLink">Réinitialiser le mot de passe</a>
            <p>Ce lien expirera dans 1 heure.</p>
        """.trimIndent()

        emailService.sendHtmlEmail(user.email, "Réinitialisation de mot de passe", body)
    }

    @Transactional
    fun resetPassword(token: String, newPassword: String): Boolean {
        val resetToken = tokenRepository.findByToken(token)
            .orElse(null) ?: return false

        if (resetToken.isExpired()) {
            tokenRepository.delete(resetToken)
            return false
        }

        val user = resetToken.user
        user.password = passwordEncoder.encode(newPassword)
        userRepository.save(user)

        tokenRepository.delete(resetToken)
        return true
    }
}
