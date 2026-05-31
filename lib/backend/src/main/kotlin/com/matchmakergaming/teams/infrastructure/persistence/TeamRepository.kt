package com.matchmakergaming.teams.infrastructure.persistence

import com.matchmakergaming.teams.domain.model.Team
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.JpaSpecificationExecutor
import org.springframework.stereotype.Repository

@Repository
interface TeamRepository : JpaRepository<Team, Long>, JpaSpecificationExecutor<Team> {
    fun findByOwnerId(ownerId: Long): List<Team>
    fun findByNameContainingIgnoreCase(name: String): List<Team>
}
