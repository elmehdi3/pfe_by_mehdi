package com.matchmakergaming.profiles.application

import com.matchmakergaming.profiles.application.dto.PlayerProfileDTO
import com.matchmakergaming.profiles.application.mapper.PlayerProfileMapper
import com.matchmakergaming.profiles.domain.model.PlayerLevel
import com.matchmakergaming.profiles.infrastructure.persistence.PlayerProfileRepository
import com.matchmakergaming.profiles.infrastructure.persistence.ProfileSpecifications
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.domain.Specification
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class ProfileService(
    private val profileRepository: PlayerProfileRepository,
    private val profileMapper: PlayerProfileMapper
) {

    fun getProfile(userId: Long): PlayerProfileDTO? {
        return profileRepository.findByUserId(userId).map { profileMapper.toDTO(it) }.orElse(null)
    }

    @Transactional
    fun updateProfile(userId: Long, updatedProfile: com.matchmakergaming.profiles.domain.model.PlayerProfile): PlayerProfileDTO {
        val profile = profileRepository.findByUserId(userId)
            .orElseThrow { RuntimeException("Profile not found") }
        
        profile.bio = updatedProfile.bio
        profile.level = updatedProfile.level
        profile.languages = updatedProfile.languages
        profile.availability = updatedProfile.availability
        profile.discord = updatedProfile.discord
        profile.steam = updatedProfile.steam
        profile.riotId = updatedProfile.riotId
        profile.xboxGamertag = updatedProfile.xboxGamertag
        profile.psn = updatedProfile.psn
        
        return profileMapper.toDTO(profileRepository.save(profile))
    }

    /**
     * Recherche avancée de joueurs avec filtres dynamiques.
     */
    fun searchProfiles(
        level: PlayerLevel?,
        language: String?,
        onlyOnline: Boolean,
        pageable: Pageable
    ): Page<PlayerProfileDTO> {
        val spec = Specification.where(ProfileSpecifications.hasLevel(level))
            .and(ProfileSpecifications.speaksLanguage(language))
            .and(ProfileSpecifications.isOnline(onlyOnline))

        return profileRepository.findAll(spec, pageable).map { profileMapper.toDTO(it) }
    }
}
