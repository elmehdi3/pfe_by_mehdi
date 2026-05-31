package com.matchmakergaming.teams.infrastructure.persistence

import com.matchmakergaming.teams.domain.model.Team
import org.springframework.data.jpa.domain.Specification

object TeamSpecifications {

    fun hasName(name: String?): Specification<Team> {
        return Specification { root, _, cb ->
            name?.let { cb.like(cb.lower(root.get("name")), "%${it.lowercase()}%") }
        }
    }

    fun isVisible(visibility: String?): Specification<Team> {
        return Specification { root, _, cb ->
            visibility?.let { cb.equal(root.get<String>("visibility"), it) }
        }
    }

    // On pourrait ajouter des filtres par jeu favori de l'équipe si on ajoute ce champ à l'entité Team
}
