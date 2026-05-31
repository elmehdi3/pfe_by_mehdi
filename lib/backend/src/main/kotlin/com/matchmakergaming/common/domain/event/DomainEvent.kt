package com.matchmakergaming.common.domain.event

import java.time.LocalDateTime
import java.util.*

abstract class DomainEvent {
    val eventId: String = UUID.randomUUID().toString()
    val occurredOn: LocalDateTime = LocalDateTime.now()
}
