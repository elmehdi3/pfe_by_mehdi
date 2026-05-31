package com.matchmakergaming.analytics.infrastructure.batch

import org.springframework.batch.core.Job
import org.springframework.batch.core.JobParametersBuilder
import org.springframework.batch.core.launch.JobLauncher
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component
import org.slf4j.LoggerFactory
import java.util.*

@Component
class AnalyticsScheduler(
    private val jobLauncher: JobLauncher,
    private val dailyStatsJob: Job
) {
    private val logger = LoggerFactory.getLogger(AnalyticsScheduler::class.java)

    /**
     * Exécute le Job d'agrégation des statistiques tous les jours à 01:00 AM
     */
    @Scheduled(cron = "0 0 1 * * *")
    fun runAnalyticsJob() {
        logger.info("Démarrage du Job Batch Analytics...")
        try {
            val params = JobParametersBuilder()
                .addString("jobId", UUID.randomUUID().toString())
                .toJobParameters()
            
            jobLauncher.run(dailyStatsJob, params)
            logger.info("Job Batch Analytics terminé avec succès.")
        } catch (e: Exception) {
            logger.error("Erreur lors de l'exécution du Job Batch Analytics", e)
        }
    }
}
