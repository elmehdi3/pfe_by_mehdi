package com.matchmakergaming.friends.infrastructure.persistence

import com.matchmakergaming.friends.domain.model.Friend
import com.matchmakergaming.friends.domain.model.FriendStatus
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface FriendRepository : JpaRepository<Friend, Long> {
    fun findByUserIdAndStatus(userId: Long, status: FriendStatus): List<Friend>
    fun findByUserIdAndFriendId(userId: Long, friendId: Long): Friend?
}
