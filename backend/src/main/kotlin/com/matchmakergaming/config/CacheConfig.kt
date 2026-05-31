package com.matchmakergaming.config

import org.springframework.cache.annotation.EnableCaching
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.data.redis.cache.RedisCacheConfiguration
import org.springframework.data.redis.cache.RedisCacheManager
import org.springframework.data.redis.connection.RedisConnectionFactory
import java.time.Duration

@Configuration
@EnableCaching
class CacheConfig {

    @Bean
    fun cacheManager(connectionFactory: RedisConnectionFactory): RedisCacheManager {
        val config = RedisCacheConfiguration.defaultCacheConfig()
            .entryTtl(Duration.ofHours(1)) // TTL par défaut
            .disableCachingNullValues()

        // Configurations spécifiques par nom de cache
        val initialCacheConfigurations = mapOf(
            "games" to RedisCacheConfiguration.defaultCacheConfig().entryTtl(Duration.ofDays(1)),
            "playerProfiles" to RedisCacheConfiguration.defaultCacheConfig().entryTtl(Duration.ofMinutes(30)),
            "globalStats" to RedisCacheConfiguration.defaultCacheConfig().entryTtl(Duration.ofMinutes(10))
        )

        return RedisCacheManager.builder(connectionFactory)
            .cacheDefaults(config)
            .withInitialCacheConfigurations(initialCacheConfigurations)
            .build()
    }
}
