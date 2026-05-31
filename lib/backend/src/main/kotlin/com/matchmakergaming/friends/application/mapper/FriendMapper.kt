package com.matchmakergaming.friends.application.mapper

import com.matchmakergaming.friends.application.dto.FriendDTO
import com.matchmakergaming.friends.domain.model.Friend
import com.matchmakergaming.users.domain.model.User
import org.springframework.stereotype.Component
import java.time.format.DateTimeFormatter

@Component
class FriendMapper {
    fun toDTO(friend: Friend, friendUser: User): FriendDTO {
        return FriendDTO(
            id = friend.id,
            friendId = friendUser.id!!,
            friendPseudo = friendUser.pseudo,
            friendAvatar = friendUser.avatar,
            status = friend.status,
            isOnline = friendUser.isOnline,
            createdAt = friend.createdAt.format(DateTimeFormatter.ISO_DATE_TIME)
        )
    }
}
