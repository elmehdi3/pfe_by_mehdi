package com.matchmakergaming.users.application

import com.matchmakergaming.users.application.dto.DeviceDTO
import com.matchmakergaming.users.application.mapper.DeviceMapper
import com.matchmakergaming.users.domain.model.UserDevice
import com.matchmakergaming.users.infrastructure.persistence.UserDeviceRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class DeviceService(
    private val userDeviceRepository: UserDeviceRepository,
    private val deviceMapper: DeviceMapper
) {

    @Transactional
    fun registerDevice(userId: Long, token: String, deviceType: String?) {
        val existingToken = userDeviceRepository.findByDeviceToken(token)
        
        if (existingToken != null) {
            if (existingToken.userId != userId) {
                userDeviceRepository.delete(existingToken)
                createNewDevice(userId, token, deviceType)
            } else {
                existingToken.isActive = true
                userDeviceRepository.save(existingToken)
            }
        } else {
            createNewDevice(userId, token, deviceType)
        }
    }

    private fun createNewDevice(userId: Long, token: String, deviceType: String?) {
        val device = UserDevice(userId = userId, deviceToken = token, deviceType = deviceType)
        userDeviceRepository.save(device)
    }

    fun getUserDevices(userId: Long): List<DeviceDTO> {
        val devices = userDeviceRepository.findByUserIdAndIsActiveTrue(userId)
        return deviceMapper.toDTOList(devices)
    }

    @Transactional
    fun unregisterDevice(deviceId: Long, userId: Long) {
        userDeviceRepository.findById(deviceId).ifPresent {
            if (it.userId == userId) {
                it.isActive = false
                userDeviceRepository.save(it)
            }
        }
    }

    fun getUserTokens(userId: Long): List<String> {
        return userDeviceRepository.findByUserIdAndIsActiveTrue(userId).map { it.deviceToken }
    }
}
