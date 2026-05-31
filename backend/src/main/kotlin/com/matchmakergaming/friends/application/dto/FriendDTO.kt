package com.matchmakergaming.friends.application.dto

import com.matchmakergaming.friends.domain.model.FriendStatus

data class FriendDTO(
    val id: Long?,
    val friendId: Long,
    val friendPseudo: String,
    val friendAvatar: String?,
    val status: FriendStatus,
    val isOnline: Boolean,
    val createdAt: String
)
