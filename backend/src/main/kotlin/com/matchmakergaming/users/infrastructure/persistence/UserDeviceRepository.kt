package com.matchmakergaming.users.infrastructure.persistence

import com.matchmakergaming.users.domain.model.UserDevice
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface UserDeviceRepository : JpaRepository<UserDevice, Long> {
    fun findByUserIdAndIsActiveTrue(userId: Long): List<UserDevice>
    fun findByDeviceToken(deviceToken: String): UserDevice?
}
