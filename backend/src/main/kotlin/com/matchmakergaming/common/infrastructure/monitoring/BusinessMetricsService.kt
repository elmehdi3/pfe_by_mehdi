package com.matchmakergaming.common.infrastructure.monitoring

import io.micrometer.core.instrument.MeterRegistry
import io.micrometer.core.instrument.Counter
import org.springframework.stereotype.Service
import java.util.concurrent.atomic.AtomicInteger

@Service
class BusinessMetricsService(private val registry: MeterRegistry) {

    // Compteurs (Valeurs qui ne font que croître)
    private val messagesCounter: Counter = Counter.builder("matchmaker.chat.messages.total")
        .description("Nombre total de messages envoyés")
        .register(registry)

    private val matchesCounter: Counter = Counter.builder("matchmaker.matching.total")
        .description("Nombre total de matchs réussis")
        .register(registry)

    // Jauges (Valeurs qui montent et descendent)
    private val activeSearchingPlayers = registry.gauge("matchmaker.matching.searching.players", AtomicInteger(0))
    private val onlineUsers = registry.gauge("matchmaker.users.online", AtomicInteger(0))

    fun incrementMessages() = messagesCounter.increment()
    
    fun incrementMatches() = matchesCounter.increment()

    fun updateActiveSearchingPlayers(count: Int) {
        activeSearchingPlayers?.set(count)
    }

    fun updateOnlineUsers(count: Int) {
        onlineUsers?.set(count)
    }
}
