package com.matchmakergaming.chat.infrastructure.persistence

import com.matchmakergaming.chat.domain.model.ConversationParticipant
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.*

@Repository
interface ConversationParticipantRepository : JpaRepository<ConversationParticipant, Long> {
    fun findByUserId(userId: Long): List<ConversationParticipant>
    fun findByConversationId(conversationId: Long): List<ConversationParticipant>
    fun findByConversationIdAndUserId(conversationId: Long, userId: Long): Optional<ConversationParticipant>
}
