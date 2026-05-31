package com.matchmakergaming.chat.application.mapper

import com.matchmakergaming.chat.application.dto.MessageDTO
import com.matchmakergaming.chat.domain.model.Message
import com.matchmakergaming.users.domain.model.User
import org.springframework.stereotype.Component

@Component
class MessageMapper {
    fun toDTO(message: Message, sender: User): MessageDTO {
        return MessageDTO(
            id = message.id,
            conversationId = message.conversationId,
            senderId = message.senderId,
            senderPseudo = sender.pseudo,
            senderAvatar = sender.avatar,
            content = message.content,
            messageType = message.messageType,
            isRead = message.isRead,
            createdAt = message.createdAt
        )
    }
}
