package com.matchmakergaming.users.infrastructure.persistence

import com.matchmakergaming.users.domain.model.User
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional

@Repository
interface UserRepository : JpaRepository<User, Long> {
    fun findByEmail(email: String): Optional<User>
    fun findByPseudo(pseudo: String): Optional<User>
    fun findByUuid(uuid: String): Optional<User>
    fun existsByEmail(email: String): Boolean
    fun existsByPseudo(pseudo: String): Boolean
}
