package com.matchmakergaming.games.application.mapper

import com.matchmakergaming.games.application.dto.GameDTO
import com.matchmakergaming.games.domain.model.Game
import org.springframework.stereotype.Component

@Component
class GameMapper {
    fun toDTO(game: Game): GameDTO {
        return GameDTO(
            id = game.id,
            name = game.name,
            slug = game.slug,
            description = game.description,
            logo = game.logo,
            banner = game.banner,
            category = game.category,
            platforms = game.platforms,
            isPopular = game.isPopular
        )
    }

    fun toDTOList(games: List<Game>): List<GameDTO> {
        return games.map { toDTO(it) }
    }
}
