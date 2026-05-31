package com.matchmakergaming.analytics.infrastructure.batch

import com.matchmakergaming.analytics.domain.model.DailyStat
import com.matchmakergaming.analytics.infrastructure.persistence.DailyStatRepository
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import com.matchmakergaming.matching.infrastructure.persistence.MatchingHistoryRepository
import com.matchmakergaming.chat.infrastructure.persistence.MessageRepository
import com.matchmakergaming.premium.infrastructure.persistence.SubscriptionRepository
import org.springframework.batch.core.Job
import org.springframework.batch.core.Step
import org.springframework.batch.core.job.builder.JobBuilder
import org.springframework.batch.core.repository.JobRepository
import org.springframework.batch.core.step.builder.StepBuilder
import org.springframework.batch.repeat.RepeatStatus
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.transaction.PlatformTransactionManager
import java.time.LocalDate
import java.time.LocalDateTime

@Configuration
class DailyStatsBatchConfig(
    private val dailyStatRepository: DailyStatRepository,
    private val userRepository: UserRepository,
    private val matchingHistoryRepository: MatchingHistoryRepository,
    private val messageRepository: MessageRepository,
    private val subscriptionRepository: SubscriptionRepository
) {

    @Bean
    fun dailyStatsJob(jobRepository: JobRepository, statsStep: Step): Job {
        return JobBuilder("dailyStatsJob", jobRepository)
            .start(statsStep)
            .build()
    }

    @Bean
    fun statsStep(jobRepository: JobRepository, transactionManager: PlatformTransactionManager): Step {
        return StepBuilder("statsStep", jobRepository)
            .tasklet({ _, _ ->
                val yesterday = LocalDate.now().minusDays(1)
                val startOfDay = yesterday.atStartOfDay()
                val endOfDay = yesterday.atTime(23, 59, 59)

                // 1. Calcul des métriques de la veille
                val newUsers = userRepository.findAll().count { 
                    it.createdAt.isAfter(startOfDay) && it.createdAt.isBefore(endOfDay) 
                }.toLong()

                val matches = matchingHistoryRepository.findAll().count {
                    it.createdAt.isAfter(startOfDay) && it.createdAt.isBefore(endOfDay)
                }.toLong()

                val messages = messageRepository.findAll().count {
                    it.createdAt.isAfter(startOfDay) && it.createdAt.isBefore(endOfDay)
                }.toLong()

                val revenue = subscriptionRepository.findAll().filter {
                    it.createdAt.isAfter(startOfDay) && it.createdAt.isBefore(endOfDay)
                }.sumOf { it.price }

                // 2. Persistance du rapport
                val stats = DailyStat(
                    date = yesterday,
                    newUsers = newUsers,
                    matchesCreated = matches,
                    messagesSent = messages,
                    activeUsers = 0, // Idéalement via logs d'accès
                    revenue = revenue
                )
                
                dailyStatRepository.save(stats)
                
                RepeatStatus.FINISHED
            }, transactionManager)
            .build()
    }
}
