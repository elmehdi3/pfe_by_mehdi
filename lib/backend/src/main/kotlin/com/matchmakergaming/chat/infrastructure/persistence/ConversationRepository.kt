package com.matchmakergaming.chat.infrastructure.persistence

import com.matchmakergaming.chat.domain.model.Conversation
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.*

@Repository
interface ConversationRepository : JpaRepository<Conversation, Long> {
    fun findByTeamId(teamId: Long): Optional<Conversation>
}
