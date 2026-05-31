package com.matchmakergaming.friends.application

import com.matchmakergaming.friends.application.dto.FriendDTO
import com.matchmakergaming.friends.application.mapper.FriendMapper
import com.matchmakergaming.friends.domain.model.Friend
import com.matchmakergaming.friends.domain.model.FriendStatus
import com.matchmakergaming.friends.infrastructure.persistence.FriendRepository
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class FriendService(
    private val friendRepository: FriendRepository,
    private val userRepository: UserRepository,
    private val friendMapper: FriendMapper
) {

    @Transactional
    fun sendFriendRequest(userId: Long, friendId: Long): FriendDTO {
        val existing = friendRepository.findByUserIdAndFriendId(userId, friendId)
        if (existing != null) {
            val friendUser = userRepository.findById(friendId).get()
            return friendMapper.toDTO(existing, friendUser)
        }
        
        val friendRequest = Friend(userId = userId, friendId = friendId, status = FriendStatus.PENDING)
        val saved = friendRepository.save(friendRequest)
        val friendUser = userRepository.findById(friendId).get()
        return friendMapper.toDTO(saved, friendUser)
    }

    @Transactional
    fun acceptFriendRequest(userId: Long, requesterId: Long): FriendDTO {
        val friendRequest = friendRepository.findByUserIdAndFriendId(requesterId, userId)
            ?: throw RuntimeException("Friend request not found")
        
        friendRequest.status = FriendStatus.ACCEPTED
        friendRepository.save(friendRequest)
        
        // Création de la relation réciproque
        val reciprocal = Friend(userId = userId, friendId = requesterId, status = FriendStatus.ACCEPTED)
        friendRepository.save(reciprocal)
        
        val requesterUser = userRepository.findById(requesterId).get()
        return friendMapper.toDTO(friendRequest, requesterUser)
    }

    fun getFriendsList(userId: Long): List<FriendDTO> {
        return friendRepository.findByUserIdAndStatus(userId, FriendStatus.ACCEPTED).map {
            val friendUser = userRepository.findById(it.friendId).get()
            friendMapper.toDTO(it, friendUser)
        }
    }

    fun getPendingRequests(userId: Long): List<FriendDTO> {
        return friendRepository.findByUserIdAndStatus(userId, FriendStatus.PENDING).map {
            val friendUser = userRepository.findById(it.friendId).get()
            friendMapper.toDTO(it, friendUser)
        }
    }

    @Transactional
    fun blockUser(userId: Long, targetId: Long) {
        val relationship = friendRepository.findByUserIdAndFriendId(userId, targetId)
            ?: Friend(userId = userId, friendId = targetId)
        
        relationship.status = FriendStatus.BLOCKED
        friendRepository.save(relationship)
    }
}
