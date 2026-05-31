package com.matchmakergaming.games.presentation

import com.matchmakergaming.common.presentation.ApiResponse
import com.matchmakergaming.games.application.GameService
import com.matchmakergaming.games.application.dto.GameDTO
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/v1/games")
class GameController(private val gameService: GameService) {

    @GetMapping
    fun getAllGames(): ResponseEntity<ApiResponse<List<GameDTO>>> {
        val games = gameService.getAllActiveGames()
        return ResponseEntity.ok(ApiResponse.success(games))
    }

    @GetMapping("/{slug}")
    fun getGameBySlug(@PathVariable slug: String): ResponseEntity<ApiResponse<GameDTO>> {
        val game = gameService.getGameBySlug(slug)
        return if (game != null) {
            ResponseEntity.ok(ApiResponse.success(game))
        } else {
            ResponseEntity.status(404).body(ApiResponse.error("Jeu non trouvé"))
        }
    }

    @GetMapping("/popular")
    fun getPopularGames(): ResponseEntity<ApiResponse<List<GameDTO>>> {
        val popularGames = gameService.getPopularGames()
        return ResponseEntity.ok(ApiResponse.success(popularGames))
    }

    @PostMapping
    fun createGame(@RequestBody game: com.matchmakergaming.games.domain.model.Game): ResponseEntity<ApiResponse<GameDTO>> {
        val savedGame = gameService.createGame(game)
        return ResponseEntity.ok(ApiResponse.success(savedGame, "Jeu créé avec succès"))
    }
}
