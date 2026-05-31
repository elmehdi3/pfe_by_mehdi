package com.matchmakergaming.friends.presentation

import com.matchmakergaming.common.presentation.ApiResponse
import com.matchmakergaming.friends.application.FriendService
import com.matchmakergaming.friends.application.dto.FriendDTO
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/v1/friends")
class FriendController(private val friendService: FriendService) {

    @PostMapping("/request")
    fun sendFriendRequest(
        @RequestParam userId: Long, 
        @RequestParam friendId: Long
    ): ResponseEntity<ApiResponse<FriendDTO>> {
        val result = friendService.sendFriendRequest(userId, friendId)
        return ResponseEntity.ok(ApiResponse.success(result, "Demande d'ami envoyée"))
    }

    @PostMapping("/accept")
    fun acceptFriendRequest(
        @RequestParam userId: Long, 
        @RequestParam requesterId: Long
    ): ResponseEntity<ApiResponse<FriendDTO>> {
        val result = friendService.acceptFriendRequest(userId, requesterId)
        return ResponseEntity.ok(ApiResponse.success(result, "Demande d'ami acceptée"))
    }

    @GetMapping("/{userId}")
    fun getFriends(@PathVariable userId: Long): ResponseEntity<ApiResponse<List<FriendDTO>>> {
        val friends = friendService.getFriendsList(userId)
        return ResponseEntity.ok(ApiResponse.success(friends))
    }

    @GetMapping("/pending/{userId}")
    fun getPendingRequests(@PathVariable userId: Long): ResponseEntity<ApiResponse<List<FriendDTO>>> {
        val pending = friendService.getPendingRequests(userId)
        return ResponseEntity.ok(ApiResponse.success(pending))
    }

    @PostMapping("/block")
    fun blockUser(
        @RequestParam userId: Long, 
        @RequestParam targetId: Long
    ): ResponseEntity<ApiResponse<Void>> {
        friendService.blockUser(userId, targetId)
        return ResponseEntity.ok(ApiResponse.success(null, "Utilisateur bloqué"))
    }
}
