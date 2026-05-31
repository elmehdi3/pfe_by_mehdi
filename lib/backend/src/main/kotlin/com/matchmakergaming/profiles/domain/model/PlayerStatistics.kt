package com.matchmakergaming.profiles.domain.model

import jakarta.persistence.Embeddable

@Embeddable
data class PlayerStatistics(
    var matchesPlayed: Int = 0,
    var matchesWon: Int = 0,
    var winRate: Double = 0.0,
    var hoursPlayed: Int = 0,
    var favoriteRole: String? = null,
    var currentStreak: Int = 0
) {
    fun updateWinRate() {
        if (matchesPlayed > 0) {
            winRate = (matchesWon.toDouble() / matchesPlayed.toDouble()) * 100.0
        }
    }
}
