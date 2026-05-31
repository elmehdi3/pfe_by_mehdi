package com.matchmakergaming.users.application.mapper

import com.matchmakergaming.users.application.dto.UserDTO
import com.matchmakergaming.users.domain.model.User
import org.springframework.stereotype.Component

@Component
class UserMapper {
    fun toDTO(user: User): UserDTO {
        return UserDTO(
            uuid = user.uuid,
            email = user.email,
            pseudo = user.pseudo,
            avatar = user.avatar,
            bio = user.bio,
            country = user.country,
            role = user.role,
            isPremium = user.isPremium,
            isOnline = user.isOnline,
            lastSeen = user.lastSeen
        )
    }
}
