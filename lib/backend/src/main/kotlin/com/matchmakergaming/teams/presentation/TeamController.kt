import com.matchmakergaming.common.presentation.ApiResponse
import com.matchmakergaming.teams.application.TeamService
import com.matchmakergaming.teams.application.dto.TeamDTO
import com.matchmakergaming.teams.application.dto.TeamMemberDTO
import com.matchmakergaming.teams.domain.model.Team
import com.matchmakergaming.teams.domain.model.TeamMemberRole
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.web.PageableDefault
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/v1/teams")
class TeamController(private val teamService: TeamService) {

    @PostMapping
    fun createTeam(@RequestBody team: Team): ResponseEntity<ApiResponse<TeamDTO>> {
        val result = teamService.createTeam(team)
        return ResponseEntity.ok(ApiResponse.success(result, "Équipe créée avec succès"))
    }

    @GetMapping("/{id}")
    fun getTeam(@PathVariable id: Long): ResponseEntity<ApiResponse<TeamDTO>> {
        val team = teamService.getTeamById(id)
        return if (team != null) {
            ResponseEntity.ok(ApiResponse.success(team))
        } else {
            ResponseEntity.status(404).body(ApiResponse.error("Équipe non trouvée"))
        }
    }

    @GetMapping("/user/{userId}")
    fun getUserTeams(@PathVariable userId: Long): ResponseEntity<ApiResponse<List<TeamDTO>>> {
        val teams = teamService.getUserTeams(userId)
        return ResponseEntity.ok(ApiResponse.success(teams))
    }

    @GetMapping("/search")
    fun searchTeams(
        @RequestParam(required = false) name: String?,
        @RequestParam(required = false) visibility: String?,
        @PageableDefault(size = 20) pageable: Pageable
    ): ResponseEntity<ApiResponse<Page<TeamDTO>>> {
        val teams = teamService.searchTeams(name, visibility, pageable)
        return ResponseEntity.ok(ApiResponse.success(teams))
    }

    @DeleteMapping("/{id}")
    fun deleteTeam(@PathVariable id: Long): ResponseEntity<ApiResponse<Unit>> {
        teamService.deleteTeam(id)
        return ResponseEntity.ok(ApiResponse.success(Unit, "Équipe supprimée"))
    }

    // --- Gestion des Membres ---

    @PostMapping("/{teamId}/members")
    fun addMember(
        @PathVariable teamId: Long,
        @RequestParam userId: Long,
        @RequestParam(defaultValue = "MEMBER") role: TeamMemberRole
    ): ResponseEntity<ApiResponse<TeamMemberDTO>> {
        val member = teamService.addMember(teamId, userId, role)
        return ResponseEntity.ok(ApiResponse.success(member, "Membre ajouté à l'équipe"))
    }

    @GetMapping("/{teamId}/members")
    fun getTeamMembers(@PathVariable teamId: Long): ResponseEntity<ApiResponse<List<TeamMemberDTO>>> {
        val members = teamService.getTeamMembers(teamId)
        return ResponseEntity.ok(ApiResponse.success(members))
    }

    @DeleteMapping("/{teamId}/members/{userId}")
    fun removeMember(
        @PathVariable teamId: Long,
        @PathVariable userId: Long
    ): ResponseEntity<ApiResponse<Unit>> {
        teamService.removeMember(teamId, userId)
        return ResponseEntity.ok(ApiResponse.success(Unit, "Membre retiré de l'équipe"))
    }
}
