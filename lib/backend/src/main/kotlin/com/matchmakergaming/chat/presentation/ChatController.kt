package com.matchmakergaming.chat.presentation

import com.matchmakergaming.chat.application.ChatService
import com.matchmakergaming.chat.application.dto.ConversationDTO
import com.matchmakergaming.chat.application.dto.MessageDTO
import com.matchmakergaming.chat.application.dto.TypingEventDTO
import com.matchmakergaming.chat.domain.model.Message
import com.matchmakergaming.common.presentation.ApiResponse
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.web.PageableDefault
import org.springframework.data.domain.Sort
import org.springframework.messaging.handler.annotation.DestinationVariable
import org.springframework.messaging.handler.annotation.MessageMapping
import org.springframework.messaging.handler.annotation.Payload
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*
import org.springframework.http.ResponseEntity

@RestController
@RequestMapping("/api/v1/chat")
class ChatRestController(private val chatService: ChatService) {

    @GetMapping("/conversations/{userId}")
    fun getConversations(@PathVariable userId: Long): ResponseEntity<ApiResponse<List<ConversationDTO>>> {
        val conversations = chatService.getUserConversations(userId)
        return ResponseEntity.ok(ApiResponse.success(conversations))
    }

    /**
     * Récupération paginée de l'historique des messages.
     * Par défaut : les 20 derniers messages, triés par date décroissante.
     */
    @GetMapping("/history/{conversationId}")
    fun getHistory(
        @PathVariable conversationId: Long,
        @PageableDefault(size = 20, sort = ["createdAt"], direction = Sort.Direction.DESC) pageable: Pageable
    ): ResponseEntity<ApiResponse<Page<MessageDTO>>> {
        val history = chatService.getConversationHistory(conversationId, pageable)
        return ResponseEntity.ok(ApiResponse.success(history))
    }

    @PostMapping("/conversations/private")
    fun startPrivateChat(@RequestParam user1Id: Long, @RequestParam user2Id: Long): ResponseEntity<ApiResponse<ConversationDTO>> {
        val conversation = chatService.createPrivateConversation(user1Id, user2Id)
        return ResponseEntity.ok(ApiResponse.success(conversation, "Conversation démarrée"))
    }

    @PatchMapping("/conversations/{conversationId}/read")
    fun markAsRead(@PathVariable conversationId: Long, @RequestParam userId: Long): ResponseEntity<ApiResponse<Unit>> {
        chatService.markAsRead(conversationId, userId)
        return ResponseEntity.ok(ApiResponse.success(Unit, "Messages marqués comme lus"))
    }
}

@Controller
class ChatWebSocketController(private val chatService: ChatService) {

    @MessageMapping("/chat.sendMessage/{conversationId}")
    fun sendMessage(
        @DestinationVariable conversationId: Long,
        @Payload message: Message
    ) {
        chatService.sendMessage(message)
    }

    @MessageMapping("/chat.typing")
    fun handleTyping(@Payload event: TypingEventDTO) {
        chatService.handleTypingEvent(event)
    }
}
