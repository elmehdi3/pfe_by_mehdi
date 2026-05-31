package com.matchmakergaming.notifications.infrastructure.persistence

import com.matchmakergaming.notifications.domain.model.Notification
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface NotificationRepository : JpaRepository<Notification, Long> {
    fun findByUserIdOrderByCreatedAtDesc(userId: Long): List<Notification>
    fun countByUserIdAndIsReadFalse(userId: Long): Long
}
