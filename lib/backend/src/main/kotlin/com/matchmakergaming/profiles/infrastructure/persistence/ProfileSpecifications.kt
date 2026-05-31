package com.matchmakergaming.profiles.infrastructure.persistence

import com.matchmakergaming.profiles.domain.model.PlayerLevel
import com.matchmakergaming.profiles.domain.model.PlayerProfile
import org.springframework.data.jpa.domain.Specification

object ProfileSpecifications {

    fun hasLevel(level: PlayerLevel?): Specification<PlayerProfile> {
        return Specification { root, _, cb ->
            level?.let { cb.equal(root.get<PlayerLevel>("level"), it) }
        }
    }

    fun speaksLanguage(language: String?): Specification<PlayerProfile> {
        return Specification { root, _, cb ->
            language?.let { cb.isMember(it, root.get<Collection<String>>("languages")) }
        }
    }

    fun isOnline(onlyOnline: Boolean): Specification<PlayerProfile> {
        return Specification { root, _, cb ->
            if (onlyOnline) {
                cb.equal(root.get<com.matchmakergaming.users.domain.model.User>("user").get<Boolean>("isOnline"), true)
            } else null
        }
    }
}
