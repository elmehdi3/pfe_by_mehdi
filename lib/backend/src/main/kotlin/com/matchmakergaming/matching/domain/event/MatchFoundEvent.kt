package com.matchmakergaming.matching.domain.event

import com.matchmakergaming.common.domain.event.DomainEvent

data class MatchFoundEvent(
    val userId: Long,
    val matchedUserId: Long,
    val gameId: Long?,
    val type: String
) : DomainEvent()
