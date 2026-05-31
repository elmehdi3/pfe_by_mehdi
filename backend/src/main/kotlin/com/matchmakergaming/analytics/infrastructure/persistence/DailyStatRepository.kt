package com.matchmakergaming.analytics.infrastructure.persistence

import com.matchmakergaming.analytics.domain.model.DailyStat
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.time.LocalDate
import java.util.Optional

@Repository
interface DailyStatRepository : JpaRepository<DailyStat, Long> {
    fun findByDate(date: LocalDate): Optional<DailyStat>
}
