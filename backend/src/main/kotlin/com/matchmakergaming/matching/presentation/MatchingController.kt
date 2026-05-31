package com.matchmakergaming.matching.presentation

import com.matchmakergaming.common.presentation.ApiResponse
import com.matchmakergaming.matching.application.MatchingService
import com.matchmakergaming.matching.application.RandomMatchingService
import com.matchmakergaming.matching.application.dto.MatchResponseDTO
import com.matchmakergaming.notifications.application.NotificationService
import com.matchmakergaming.notifications.domain.model.NotificationType
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/v1/matching")
class MatchingController(
    private val matchingService: MatchingService,
    private val randomMatchingService: RandomMatchingService,
    private val notificationService: NotificationService
) {

    @GetMapping("/smart/{gameId}")
    fun getSmartMatches(
        @PathVariable gameId: Long, 
        @RequestParam userId: Long
    ): ResponseEntity<ApiResponse<List<MatchResponseDTO>>> {
        val matches = matchingService.findCompatiblePlayers(userId, gameId)
        return ResponseEntity.ok(ApiResponse.success(matches, "Matches intelligents récupérés"))
    }

    @PostMapping("/random/global")
    fun joinGlobalQueue(@RequestParam userId: Long): ResponseEntity<ApiResponse<Map<String, String>>> {
        randomMatchingService.joinQueue(userId, null, null)
        return ResponseEntity.ok(ApiResponse.success(mapOf("status" to "QUEUED_GLOBAL"), "Recherche mondiale lancée"))
    }

    @PostMapping("/random/game")
    fun joinGameQueue(
        @RequestParam userId: Long, 
        @RequestParam gameId: Long
    ): ResponseEntity<ApiResponse<Map<String, Any>>> {
        randomMatchingService.joinQueue(userId, gameId, null)
        return ResponseEntity.ok(ApiResponse.success(
            mapOf("status" to "QUEUED_GAME", "gameId" to gameId), 
            "Recherche lancée pour ce jeu"
        ))
    }

    @GetMapping("/random/quick")
    fun quickMatch(
        @RequestParam userId: Long, 
        @RequestParam(required = false) gameId: Long?
    ): ResponseEntity<ApiResponse<Map<String, Long>>> {
        val opponentId = randomMatchingService.findMatch(userId, gameId, null)
        
        return if (opponentId != null) {
            notificationService.createAndSendNotification(
                userId, "Match trouvé !", "Un coéquipier vous attend.", NotificationType.MATCH_RANDOM_FOUND
            )
            notificationService.createAndSendNotification(
                opponentId, "Match trouvé !", "Un coéquipier vous attend.", NotificationType.MATCH_RANDOM_FOUND
            )
            ResponseEntity.ok(ApiResponse.success(mapOf("matchedUserId" to opponentId), "Match trouvé avec succès"))
        } else {
            randomMatchingService.joinQueue(userId, gameId, null)
            ResponseEntity.ok(ApiResponse(true, "Toujours en recherche...", null))
        }
    }
}
