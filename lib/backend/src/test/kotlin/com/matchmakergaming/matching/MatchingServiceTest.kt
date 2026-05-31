package com.matchmakergaming.matching

import com.matchmakergaming.common.infrastructure.monitoring.BusinessMetricsService
import com.matchmakergaming.friends.domain.model.FriendStatus
import com.matchmakergaming.friends.infrastructure.persistence.FriendRepository
import com.matchmakergaming.matching.application.MatchingService
import com.matchmakergaming.matching.application.mapper.MatchingMapper
import com.matchmakergaming.matching.infrastructure.persistence.MatchingHistoryRepository
import com.matchmakergaming.premium.application.PremiumValidator
import com.matchmakergaming.profiles.domain.model.PlayerLevel
import com.matchmakergaming.profiles.domain.model.PlayerProfile
import com.matchmakergaming.profiles.infrastructure.persistence.PlayerProfileRepository
import com.matchmakergaming.users.domain.model.User
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import org.springframework.context.ApplicationEventPublisher
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.Mockito.*
import java.util.*

class MatchingServiceTest {

    private lateinit var matchingService: MatchingService
    private val profileRepo = mock(PlayerProfileRepository::class.java)
    private val userRepo = mock(UserRepository::class.java)
    private val friendRepo = mock(FriendRepository::class.java)
    private val historyRepo = mock(MatchingHistoryRepository::class.java)
    private val mapper = mock(MatchingMapper::class.java)
    private val premiumValidator = mock(PremiumValidator::class.java)
    private val metricsService = mock(BusinessMetricsService::class.java)
    private val eventPublisher = mock(ApplicationEventPublisher::class.java)

    @BeforeEach
    fun setup() {
        matchingService = MatchingService(
            profileRepo, userRepo, friendRepo, historyRepo, mapper, premiumValidator, metricsService, eventPublisher
        )
    }

    @Test
    fun `calculateCompatibility should return 100 for perfect match without social bonus`() {
        // GIVEN
        val user1 = User(id = 1L, email = "u1@test.com", password = "", pseudo = "P1")
        val user2 = User(id = 2L, email = "u2@test.com", password = "", pseudo = "P2")

        val p1 = PlayerProfile(
            user = user1,
            level = PlayerLevel.EXPERT,
            languages = mutableSetOf("FR", "EN"),
            availability = "EVENING",
            reputationScore = 5.0
        )

        val p2 = PlayerProfile(
            user = user2,
            level = PlayerLevel.EXPERT,
            languages = mutableSetOf("FR"),
            availability = "EVENING",
            reputationScore = 4.5
        )

        `when`(friendRepo.findByUserIdAndStatus(1L, FriendStatus.ACCEPTED)).thenReturn(listOf())
        `when`(friendRepo.findByUserIdAndStatus(2L, FriendStatus.ACCEPTED)).thenReturn(listOf())

        // WHEN
        val score = matchingService.calculateCompatibility(p1, p2, 1L)

        // THEN
        // Same Game(30) + Same Level(25) + Common Lang(20) + Same Avail(15) + Rep > 4(10) = 100
        assertEquals(100, score)
    }

    @Test
    fun `calculateCompatibility should include social bonus for friend of friend`() {
        // GIVEN
        val p1 = createBaseProfile(1L, PlayerLevel.BEGINNER)
        val p2 = createBaseProfile(2L, PlayerLevel.ADVANCED)

        // Mocking friend of friend: User 1 and User 2 share User 3 as a friend
        val friendRelation = mock(com.matchmakergaming.friends.domain.model.Friend::class.java)
        `when`(friendRelation.friendId).thenReturn(3L)
        
        `when`(friendRepo.findByUserIdAndStatus(1L, FriendStatus.ACCEPTED)).thenReturn(listOf(friendRelation))
        `when`(friendRepo.findByUserIdAndStatus(2L, FriendStatus.ACCEPTED)).thenReturn(listOf(friendRelation))

        // WHEN
        val score = matchingService.calculateCompatibility(p1, p2, 1L)

        // THEN
        // Same Game(30) + Social Bonus(5) = 35
        assertEquals(35, score)
    }

    private fun createBaseProfile(userId: Long, level: PlayerLevel): PlayerProfile {
        return PlayerProfile(
            user = User(id = userId, email = "", password = "", pseudo = ""),
            level = level,
            languages = mutableSetOf(),
            reputationScore = 0.0
        )
    }
}
