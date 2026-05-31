package com.matchmakergaming.matching.application.mapper

import com.matchmakergaming.matching.application.dto.MatchResponseDTO
import com.matchmakergaming.profiles.application.mapper.PlayerProfileMapper
import com.matchmakergaming.profiles.domain.model.PlayerProfile
import org.springframework.stereotype.Component
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

@Component
class MatchingMapper(private val profileMapper: PlayerProfileMapper) {

    fun toMatchResponseDTO(
        profile: PlayerProfile, 
        score: Int, 
        type: String
    ): MatchResponseDTO {
        return MatchResponseDTO(
            player = profileMapper.toDTO(profile),
            compatibilityScore = score,
            matchingType = type,
            matchedAt = LocalDateTime.now().format(DateTimeFormatter.ISO_DATE_TIME)
        )
    }
}
