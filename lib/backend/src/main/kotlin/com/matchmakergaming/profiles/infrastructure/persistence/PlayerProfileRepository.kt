package com.matchmakergaming.profiles.infrastructure.persistence

import com.matchmakergaming.profiles.domain.model.PlayerProfile
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.JpaSpecificationExecutor
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository
import java.util.*

@Repository
interface PlayerProfileRepository : JpaRepository<PlayerProfile, Long>, JpaSpecificationExecutor<PlayerProfile> {
    fun findByUserId(userId: Long): Optional<PlayerProfile>

    @Query("""
        SELECT p FROM PlayerProfile p 
        JOIN p.user u 
        WHERE u.id != :userId 
        AND u.isOnline = true 
        AND u.status = 'ACTIVE' 
        AND u.id NOT IN (
            SELECT f.friendId FROM Friend f WHERE f.userId = :userId AND f.status = 'BLOCKED'
        )
    """)
    fun findPotentialMatches(@Param("userId") userId: Long): List<PlayerProfile>
}
