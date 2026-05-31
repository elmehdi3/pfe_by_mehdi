package com.matchmakergaming.matching

import com.matchmakergaming.matching.application.MatchingService
import com.matchmakergaming.profiles.domain.model.PlayerLevel
import com.matchmakergaming.profiles.domain.model.PlayerProfile
import com.matchmakergaming.profiles.infrastructure.persistence.PlayerProfileRepository
import com.matchmakergaming.users.domain.model.User
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import org.junit.jupiter.api.Assertions.assertFalse
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.DynamicPropertyRegistry
import org.springframework.test.context.DynamicPropertySource
import org.testcontainers.containers.MySQLContainer
import org.testcontainers.junit.jupiter.Container
import org.testcontainers.junit.jupiter.Testcontainers
import org.testcontainers.containers.GenericContainer

@SpringBootTest
@Testcontainers
class MatchingIntegrationTest {

    @Autowired
    private lateinit var matchingService: MatchingService

    @Autowired
    private lateinit var userRepository: UserRepository

    @Autowired
    private lateinit var profileRepository: PlayerProfileRepository

    companion object {
        @Container
        val mysql = MySQLContainer("mysql:8.0")
            .withDatabaseName("matchmaker_test")
            .withUsername("test")
            .withPassword("test")

        @Container
        val redis = GenericContainer("redis:alpine").withExposedPorts(6379)

        @JvmStatic
        @DynamicPropertySource
        fun properties(registry: DynamicPropertyRegistry) {
            registry.add("spring.datasource.url", mysql::getJdbcUrl)
            registry.add("spring.datasource.username", mysql::getUsername)
            registry.add("spring.datasource.password", mysql::getPassword)
            registry.add("spring.data.redis.host", redis::getHost)
            registry.add("spring.data.redis.port") { redis.getMappedPort(6379) }
        }
    }

    @Test
    fun `should find compatible player based on level and language`() {
        // 1. Création de deux joueurs
        val user1 = userRepository.save(User(email = "p1@test.com", password = "pwd", pseudo = "ProGamer", isOnline = true, isVerified = true))
        val user2 = userRepository.save(User(email = "p2@test.com", password = "pwd", pseudo = "ExpertGamer", isOnline = true, isVerified = true))

        // 2. Création des profils compatibles
        profileRepository.save(PlayerProfile(
            user = user1,
            level = PlayerLevel.PRO,
            languages = mutableSetOf("FR", "EN")
        ))
        
        profileRepository.save(PlayerProfile(
            user = user2,
            level = PlayerLevel.PRO,
            languages = mutableSetOf("FR")
        ))

        // 3. Exécution du Matching (Recherche pour user1 sur le jeu ID 1)
        val matches = matchingService.findCompatiblePlayers(user1.id!!, 1L)

        // 4. Vérifications
        assertFalse(matches.isEmpty(), "On devrait trouver au moins un match")
        assertTrue(matches.any { it.player.pseudo == "ExpertGamer" }, "User2 devrait être dans les résultats")
        assertTrue(matches.first().compatibilityScore >= 75, "Le score devrait être élevé (Same Game + Level + Lang)")
    }
}
