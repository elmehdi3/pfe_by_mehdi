package com.matchmakergaming.teams.application

import com.matchmakergaming.chat.application.ChatService
import com.matchmakergaming.teams.application.dto.TeamDTO
import com.matchmakergaming.teams.application.dto.TeamMemberDTO
import com.matchmakergaming.teams.application.mapper.TeamMapper
import com.matchmakergaming.teams.application.mapper.TeamMemberMapper
import com.matchmakergaming.teams.domain.model.Team
import com.matchmakergaming.teams.domain.model.TeamMember
import com.matchmakergaming.teams.domain.model.TeamMemberRole
import com.matchmakergaming.teams.infrastructure.persistence.TeamMemberRepository
import com.matchmakergaming.teams.infrastructure.persistence.TeamRepository
import com.matchmakergaming.teams.infrastructure.persistence.TeamSpecifications
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.domain.Specification
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class TeamService(
    private val teamRepository: TeamRepository,
    private val teamMemberRepository: TeamMemberRepository,
    private val userRepository: UserRepository,
    private val chatService: ChatService,
    private val teamMapper: TeamMapper,
    private val teamMemberMapper: TeamMemberMapper
) {

    @Transactional
    fun createTeam(team: Team): TeamDTO {
        val savedTeam = teamRepository.save(team)
        
        val ownerMember = TeamMember(
            teamId = savedTeam.id!!,
            userId = savedTeam.ownerId,
            role = TeamMemberRole.OWNER
        )
        teamMemberRepository.save(ownerMember)

        chatService.createTeamConversation(savedTeam.id, savedTeam.ownerId)
        
        return teamMapper.toDTO(savedTeam).copy(memberCount = 1)
    }

    @Transactional
    fun addMember(teamId: Long, userId: Long, role: TeamMemberRole = TeamMemberRole.MEMBER): TeamMemberDTO {
        val team = teamRepository.findById(teamId).orElseThrow { RuntimeException("Team not found") }
        val currentMemberCount = teamMemberRepository.countByTeamId(teamId)
        
        if (currentMemberCount >= team.maxMembers) {
            throw RuntimeException("Team is full")
        }

        val member = TeamMember(teamId = teamId, userId = userId, role = role)
        val savedMember = teamMemberRepository.save(member)

        // Ajout automatique au canal de chat de l'équipe
        chatService.addParticipantToConversation(teamId, userId)
        
        val user = userRepository.findById(userId).get()
        return teamMemberMapper.toDTO(savedMember, user)
    }

    fun searchTeams(name: String?, visibility: String?, pageable: Pageable): Page<TeamDTO> {
        val spec = Specification.where(TeamSpecifications.hasName(name))
            .and(TeamSpecifications.isVisible(visibility))

        return teamRepository.findAll(spec, pageable).map { team ->
            val count = teamMemberRepository.countByTeamId(team.id!!).toInt()
            teamMapper.toDTO(team).copy(memberCount = count)
        }
    }

    fun getTeamById(id: Long): TeamDTO? {
        val team = teamRepository.findById(id).orElse(null) ?: return null
        val memberCount = teamMemberRepository.countByTeamId(id).toInt()
        return teamMapper.toDTO(team).copy(memberCount = memberCount)
    }

    fun getTeamMembers(teamId: Long): List<TeamMemberDTO> {
        val members = teamMemberRepository.findByTeamId(teamId)
        return members.map { member ->
            val user = userRepository.findById(member.userId).get()
            teamMemberMapper.toDTO(member, user)
        }
    }

    fun getUserTeams(userId: Long): List<TeamDTO> {
        val memberShips = teamMemberRepository.findByUserId(userId)
        return memberShips.map { ms ->
            val team = teamRepository.findById(ms.teamId).get()
            val count = teamMemberRepository.countByTeamId(ms.teamId).toInt()
            teamMapper.toDTO(team).copy(memberCount = count)
        }
    }

    @Transactional
    fun removeMember(teamId: Long, userId: Long) {
        val member = teamMemberRepository.findByTeamIdAndUserId(teamId, userId)
            .orElseThrow { RuntimeException("Member not found") }
        
        if (member.role == TeamMemberRole.OWNER) {
            throw RuntimeException("Owner cannot leave without transferring ownership")
        }
        
        teamMemberRepository.delete(member)
    }

    @Transactional
    fun deleteTeam(id: Long) {
        teamRepository.deleteById(id)
    }
}
