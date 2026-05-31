package com.matchmakergaming.auth.application

import com.matchmakergaming.common.infrastructure.email.EmailService
import com.matchmakergaming.users.domain.model.User
import org.springframework.data.redis.core.RedisTemplate
import org.springframework.stereotype.Service
import java.security.SecureRandom
import java.util.concurrent.TimeUnit

@Service
class TwoFactorService(
    private val redisTemplate: RedisTemplate<String, Any>,
    private val emailService: EmailService
) {
    private val random = SecureRandom()
    private val OTP_PREFIX = "2fa:code:"

    fun generateAndSendCode(user: User) {
        val code = String.format("%06d", random.nextInt(1000000))
        val key = "$OTP_PREFIX${user.id}"
        
        // Stockage du code dans Redis pendant 5 minutes
        redisTemplate.opsForValue().set(key, code, 5, TimeUnit.MINUTES)

        val body = """
            <h1>Code de sécurité MatchMaker</h1>
            <p>Utilisez le code suivant pour valider votre connexion :</p>
            <h2 style="color: #6200EE; letter-spacing: 5px;">$code</h2>
            <p>Ce code expirera dans 5 minutes.</p>
        """.trimIndent()

        emailService.sendHtmlEmail(user.email, "Code de connexion 2FA", body)
    }

    fun verifyCode(userId: Long, code: String): Boolean {
        val key = "$OTP_PREFIX$userId"
        val savedCode = redisTemplate.opsForValue().get(key) as? String
        
        if (savedCode == code) {
            redisTemplate.delete(key)
            return true
        }
        return false
    }
}
