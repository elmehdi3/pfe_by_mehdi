package com.matchmakergaming.teams.application.mapper

import com.matchmakergaming.teams.application.dto.TeamMemberDTO
import com.matchmakergaming.teams.domain.model.TeamMember
import com.matchmakergaming.users.domain.model.User
import org.springframework.stereotype.Component

@Component
class TeamMemberMapper {
    fun toDTO(member: TeamMember, user: User): TeamMemberDTO {
        return TeamMemberDTO(
            id = member.id,
            userId = user.id!!,
            pseudo = user.pseudo,
            avatar = user.avatar,
            role = member.role,
            joinedAt = member.joinedAt
        )
    }

    fun toDTOList(membersWithUsers: List<Pair<TeamMember, User>>): List<TeamMemberDTO> {
        return membersWithUsers.map { toDTO(it.first, it.second) }
    }
}
