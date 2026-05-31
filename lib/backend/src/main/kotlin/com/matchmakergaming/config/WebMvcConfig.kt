package com.matchmakergaming.config

import com.matchmakergaming.security.rate.RateLimitInterceptor
import com.matchmakergaming.security.audit.AuditInterceptor
import org.springframework.context.annotation.Configuration
import org.springframework.web.servlet.config.annotation.InterceptorRegistry
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer

@Configuration
class WebMvcConfig(
    private val rateLimitInterceptor: RateLimitInterceptor,
    private val auditInterceptor: AuditInterceptor
) : WebMvcConfigurer {

    override fun addInterceptors(registry: InterceptorRegistry) {
        // Limitation du débit pour toutes les API
        registry.addInterceptor(rateLimitInterceptor)
            .addPathPatterns("/api/v1/**")

        // Audit automatique des actions critiques
        registry.addInterceptor(auditInterceptor)
            .addPathPatterns("/api/v1/**")
            .excludePathPatterns("/api/v1/auth/**") // Optionnel : l'auth a son propre audit
    }
}
