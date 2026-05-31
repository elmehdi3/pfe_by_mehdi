package com.matchmakergaming.teams.application.mapper

import com.matchmakergaming.teams.application.dto.TeamDTO
import com.matchmakergaming.teams.domain.model.Team
import org.springframework.stereotype.Component

@Component
class TeamMapper {
    fun toDTO(team: Team): TeamDTO {
        return TeamDTO(
            id = team.id,
            name = team.name,
            logo = team.logo,
            description = team.description,
            ownerId = team.ownerId,
            maxMembers = team.maxMembers,
            memberCount = 0, // Should be calculated if we had a member list
            visibility = team.visibility,
            createdAt = team.createdAt
        )
    }

    fun toDTOList(teams: List<Team>): List<TeamDTO> {
        return teams.map { toDTO(it) }
    }
}
