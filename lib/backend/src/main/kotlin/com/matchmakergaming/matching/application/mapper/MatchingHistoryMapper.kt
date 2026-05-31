package com.matchmakergaming.matching.application.mapper

import com.matchmakergaming.games.infrastructure.persistence.GameRepository
import com.matchmakergaming.matching.application.dto.MatchingHistoryDTO
import com.matchmakergaming.matching.domain.model.MatchingHistory
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import org.springframework.stereotype.Component

@Component
class MatchingHistoryMapper(
    private val userRepository: UserRepository,
    private val gameRepository: GameRepository
) {
    fun toDTO(history: MatchingHistory): MatchingHistoryDTO {
        val matchedUser = userRepository.findById(history.matchedUserId).orElse(null)
        val game = gameRepository.findById(history.gameId).orElse(null)

        return MatchingHistoryDTO(
            id = history.id,
            matchedUserId = history.matchedUserId,
            matchedUserPseudo = matchedUser?.pseudo ?: "Joueur inconnu",
            matchedUserAvatar = matchedUser?.avatar,
            type = history.matchingType,
            compatibilityScore = history.compatibilityScore,
            gameName = game?.name ?: "Jeu inconnu",
            createdAt = history.createdAt
        )
    }
}
