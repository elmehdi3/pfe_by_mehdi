package com.matchmakergaming.users.domain.event

import com.matchmakergaming.common.domain.event.DomainEvent

data class UserPresenceEvent(
    val userId: Long,
    val pseudo: String,
    val isOnline: Boolean
) : DomainEvent()
