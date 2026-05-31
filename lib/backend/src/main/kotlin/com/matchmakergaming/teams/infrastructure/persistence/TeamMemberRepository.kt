package com.matchmakergaming.teams.infrastructure.persistence

import com.matchmakergaming.teams.domain.model.TeamMember
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.*

@Repository
interface TeamMemberRepository : JpaRepository<TeamMember, Long> {
    fun findByTeamId(teamId: Long): List<TeamMember>
    fun findByUserId(userId: Long): List<TeamMember>
    fun findByTeamIdAndUserId(teamId: Long, userId: Long): Optional<TeamMember>
    fun countByTeamId(teamId: Long): Long
}
