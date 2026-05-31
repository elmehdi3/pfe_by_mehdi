package com.matchmakergaming.profiles.presentation

import com.matchmakergaming.common.presentation.ApiResponse
import com.matchmakergaming.common.infrastructure.storage.FileStorageService
import com.matchmakergaming.profiles.application.ProfileService
import com.matchmakergaming.profiles.application.dto.PlayerProfileDTO
import com.matchmakergaming.profiles.domain.model.PlayerLevel
import com.matchmakergaming.profiles.domain.model.PlayerProfile
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import org.springframework.web.multipart.MultipartFile

@RestController
@RequestMapping("/api/v1/profiles")
class ProfileController(
    private val profileService: ProfileService,
    private val fileStorageService: FileStorageService,
    private val userRepository: UserRepository
) {

    @GetMapping("/{userId}")
    fun getProfile(@PathVariable userId: Long): ResponseEntity<ApiResponse<PlayerProfileDTO>> {
        val profile = profileService.getProfile(userId)
        return if (profile != null) {
            ResponseEntity.ok(ApiResponse.success(profile))
        } else {
            ResponseEntity.status(404).body(ApiResponse.error("Profil non trouvé"))
        }
    }

    @PutMapping("/{userId}")
    fun updateProfile(
        @PathVariable userId: Long,
        @RequestBody updatedProfile: PlayerProfile
    ): ResponseEntity<ApiResponse<PlayerProfileDTO>> {
        val profile = profileService.updateProfile(userId, updatedProfile)
        return ResponseEntity.ok(ApiResponse.success(profile, "Profil mis à jour avec succès"))
    }

    /**
     * Upload de l'avatar vers AWS S3 et mise à jour de l'entité User.
     */
    @PostMapping("/{userId}/avatar")
    fun uploadAvatar(
        @PathVariable userId: Long,
        @RequestParam("file") file: MultipartFile
    ): ResponseEntity<ApiResponse<String>> {
        val user = userRepository.findById(userId).orElseThrow { RuntimeException("Utilisateur non trouvé") }
        
        // 1. Upload vers S3
        val avatarUrl = fileStorageService.uploadAvatar(userId, file)
        
        // 2. Mise à jour de l'utilisateur
        user.avatar = avatarUrl
        userRepository.save(user)
        
        return ResponseEntity.ok(ApiResponse.success(avatarUrl, "Avatar mis à jour avec succès"))
    }

    @GetMapping("/search")
    fun searchProfiles(
        @RequestParam(required = false) level: PlayerLevel?,
        @RequestParam(required = false) language: String?,
        @RequestParam(defaultValue = "false") onlyOnline: Boolean,
        pageable: Pageable
    ): ResponseEntity<ApiResponse<Page<PlayerProfileDTO>>> {
        val results = profileService.searchProfiles(level, language, onlyOnline, pageable)
        return ResponseEntity.ok(ApiResponse.success(results))
    }
}
