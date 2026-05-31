package com.matchmakergaming.chat.infrastructure.persistence

import com.matchmakergaming.chat.domain.model.Message
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface MessageRepository : JpaRepository<Message, Long> {
    fun findByConversationIdOrderByCreatedAtAsc(conversationId: Long): List<Message>
    fun findByConversationId(conversationId: Long, pageable: org.springframework.data.domain.Pageable): org.springframework.data.domain.Page<Message>
    fun countByConversationIdAndSenderIdNotAndCreatedAtAfter(conversationId: Long, senderId: Long, createdAt: java.time.LocalDateTime): Long
}
