package com.matchmakergaming.games.infrastructure.persistence

import com.matchmakergaming.games.domain.model.Game
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional

@Repository
interface GameRepository : JpaRepository<Game, Long> {
    fun findBySlug(slug: String): Optional<Game>
    fun findByIsActiveTrue(): List<Game>
}
