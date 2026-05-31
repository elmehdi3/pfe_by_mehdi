package com.matchmakergaming.profiles.application.mapper

import com.matchmakergaming.profiles.application.dto.PlayerProfileDTO
import com.matchmakergaming.profiles.domain.model.PlayerProfile
import org.springframework.stereotype.Component
import java.time.format.DateTimeFormatter

@Component
class PlayerProfileMapper {
    fun toDTO(profile: PlayerProfile): PlayerProfileDTO {
        return PlayerProfileDTO(
            id = profile.id,
            userId = profile.user.id!!,
            pseudo = profile.user.pseudo,
            bio = profile.bio,
            level = profile.level,
            languages = profile.languages,
            availability = profile.availability,
            reputationScore = profile.reputationScore,
            totalReviews = profile.totalReviews,
            badges = profile.badges.toSet(),
            statistics = profile.statistics,
            platforms = mapOf(
                "discord" to profile.discord,
                "steam" to profile.steam,
                "riotId" to profile.riotId,
                "xbox" to profile.xboxGamertag,
                "psn" to profile.psn
            ),
            isOnline = profile.user.isOnline,
            isPremium = profile.user.isPremium,
            lastSeen = profile.user.lastSeen.format(DateTimeFormatter.ISO_DATE_TIME)
        )
    }
}
