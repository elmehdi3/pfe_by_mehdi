package com.matchmakergaming.matching.application

import com.matchmakergaming.friends.domain.model.FriendStatus
import com.matchmakergaming.friends.infrastructure.persistence.FriendRepository
import com.matchmakergaming.matching.application.dto.MatchResponseDTO
import com.matchmakergaming.matching.application.mapper.MatchingMapper
import com.matchmakergaming.matching.domain.event.MatchFoundEvent
import com.matchmakergaming.matching.domain.model.MatchingHistory
import com.matchmakergaming.matching.domain.model.MatchingType
import com.matchmakergaming.matching.infrastructure.persistence.MatchingHistoryRepository
import com.matchmakergaming.profiles.domain.model.PlayerProfile
import com.matchmakergaming.profiles.infrastructure.persistence.PlayerProfileRepository
import com.matchmakergaming.premium.application.PremiumValidator
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import com.matchmakergaming.common.infrastructure.monitoring.BusinessMetricsService
import org.springframework.context.ApplicationEventPublisher
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class MatchingService(
    private val profileRepository: PlayerProfileRepository,
    private val userRepository: UserRepository,
    private val friendRepository: FriendRepository,
    private val matchingHistoryRepository: MatchingHistoryRepository,
    private val matchingMapper: MatchingMapper,
    private val premiumValidator: PremiumValidator,
    private val metricsService: BusinessMetricsService,
    private val eventPublisher: ApplicationEventPublisher
) {

    @Transactional
    fun findCompatiblePlayers(userId: Long, gameId: Long): List<MatchResponseDTO> {
        if (!premiumValidator.canPerformMatching(userId)) {
            throw RuntimeException("Limite de matching quotidienne atteinte. Passez au Premium !")
        }

        val userProfile = profileRepository.findByUserId(userId)
            .orElseThrow { RuntimeException("Profil non trouvé") }

        val potentialCandidates = profileRepository.findPotentialMatches(userId)

        return potentialCandidates
            .map { other ->
                val score = calculateCompatibility(userProfile, other, gameId)
                
                // Enregistrement de l'historique
                matchingHistoryRepository.save(MatchingHistory(
                    userId = userId,
                    matchedUserId = other.user.id!!,
                    matchingType = MatchingType.SMART,
                    compatibilityScore = score,
                    gameId = gameId
                ))
                
                metricsService.incrementMatches()
                
                eventPublisher.publishEvent(MatchFoundEvent(
                    userId = userId,
                    matchedUserId = other.user.id!!,
                    gameId = gameId,
                    type = "SMART"
                ))

                matchingMapper.toMatchResponseDTO(other, score, "SMART")
            }
            // TRI AVANCÉ : Les Premium en premier, puis par score
            .sortedWith(compareByDescending<MatchResponseDTO> { it.player.isPremium }
                .thenByDescending { it.compatibilityScore })
            .take(10)
    }

    /**
     * Suggère des joueurs à ajouter en ami basés sur la compatibilité globale.
     * Met en avant les profils Premium (Featured Profiles).
     */
    fun getRecommendedPlayers(userId: Long): List<MatchResponseDTO> {
        val userProfile = profileRepository.findByUserId(userId)
            .orElseThrow { RuntimeException("Profil non trouvé") }
        
        val potentialCandidates = profileRepository.findPotentialMatches(userId)
        
        val friendIds = friendRepository.findByUserIdAndStatus(userId, FriendStatus.ACCEPTED).map { it.friendId }
        val pendingIds = friendRepository.findByUserIdAndStatus(userId, FriendStatus.PENDING).map { it.friendId }

        return potentialCandidates
            .filter { !friendIds.contains(it.user.id) && !pendingIds.contains(it.user.id) }
            .map { other ->
                val score = calculateCompatibility(userProfile, other, 0)
                matchingMapper.toMatchResponseDTO(other, score, "RECOMMENDATION")
            }
            // Mise en avant des Premium dans les recommandations
            .sortedWith(compareByDescending<MatchResponseDTO> { it.player.isPremium }
                .thenByDescending { it.compatibilityScore })
            .take(5)
    }

    fun calculateCompatibility(p1: PlayerProfile, p2: PlayerProfile, gameId: Long): Int {
        var score = 0
        if (gameId != 0L) score += 30 
        if (p1.level == p2.level) score += 25
        val commonLanguages = p1.languages.intersect(p2.languages)
        if (commonLanguages.isNotEmpty()) score += 20
        if (p1.availability == p2.availability) score += 15
        if (p2.reputationScore >= 4.0) score += 10
        return score
    }
}
