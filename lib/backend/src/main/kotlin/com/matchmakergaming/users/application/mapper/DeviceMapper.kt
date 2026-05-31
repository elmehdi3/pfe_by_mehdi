package com.matchmakergaming.users.application.mapper

import com.matchmakergaming.users.application.dto.DeviceDTO
import com.matchmakergaming.users.domain.model.UserDevice
import org.springframework.stereotype.Component

@Component
class DeviceMapper {
    fun toDTO(device: UserDevice): DeviceDTO {
        return DeviceDTO(
            id = device.id,
            deviceType = device.deviceType,
            lastLogin = device.lastLogin,
            isActive = device.isActive
        )
    }

    fun toDTOList(devices: List<UserDevice>): List<DeviceDTO> {
        return devices.map { toDTO(it) }
    }
}
