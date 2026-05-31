package com.matchmakergaming.auth.application

import com.matchmakergaming.users.domain.model.User
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.*

@Service
class SocialAuthService(
    private val userRepository: UserRepository
) {

    @Transactional
    fun processSocialLogin(idToken: String, provider: String): User {
        // En production, ici on appellerait :
        // GoogleIdTokenVerifier pour Google
        // Ou le service de validation Apple (REST) pour Apple
        
        // Simulation du décodage du jeton (Mock)
        val email = "user-${provider.lowercase()}@example.com"
        val pseudo = "Gamer_${UUID.randomUUID().toString().take(5)}"

        return userRepository.findByEmail(email).orElseGet {
            val newUser = User(
                email = email,
                pseudo = pseudo,
                password = "", // Pas de mot de passe pour OAuth2
                isVerified = true // L'email est déjà vérifié par le provider
            )
            userRepository.save(newUser)
        }
    }
}
