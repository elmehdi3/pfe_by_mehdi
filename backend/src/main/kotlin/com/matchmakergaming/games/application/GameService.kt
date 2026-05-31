package com.matchmakergaming.games.application

import com.matchmakergaming.games.application.dto.GameDTO
import com.matchmakergaming.games.application.mapper.GameMapper
import com.matchmakergaming.games.domain.model.Game
import com.matchmakergaming.games.infrastructure.persistence.GameRepository
import org.springframework.cache.annotation.CacheEvict
import org.springframework.cache.annotation.Cacheable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class GameService(
    private val gameRepository: GameRepository,
    private val gameMapper: GameMapper
) {

    @Cacheable(value = ["games"], key = "'all_active'")
    fun getAllActiveGames(): List<GameDTO> {
        return gameMapper.toDTOList(gameRepository.findByIsActiveTrue())
    }

    @Cacheable(value = ["games"], key = "#slug")
    fun getGameBySlug(slug: String): GameDTO? {
        return gameRepository.findBySlug(slug).map { gameMapper.toDTO(it) }.orElse(null)
    }

    @Transactional
    @CacheEvict(value = ["games"], allEntries = true)
    fun createGame(game: Game): GameDTO {
        val savedGame = gameRepository.save(game)
        return gameMapper.toDTO(savedGame)
    }

    @Cacheable(value = ["games"], key = "'popular'")
    fun getPopularGames(): List<GameDTO> {
        return gameMapper.toDTOList(gameRepository.findByIsActiveTrue().filter { it.isPopular })
    }
}
