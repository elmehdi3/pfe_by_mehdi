package com.matchmakergaming.security.audit

import com.matchmakergaming.security.services.UserDetailsImpl
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.stereotype.Component
import org.springframework.web.servlet.HandlerInterceptor

@Component
class AuditInterceptor(private val auditService: AuditService) : HandlerInterceptor {

    override fun afterCompletion(
        request: HttpServletRequest,
        response: HttpServletResponse,
        handler: Any,
        ex: Exception?
    ) {
        val method = request.method
        // On n'audit que les actions de modification et les erreurs critiques
        if (method == "POST" || method == "PUT" || method == "DELETE" || method == "PATCH") {
            
            val authentication = SecurityContextHolder.getContext().authentication
            val userId = if (authentication != null && authentication.principal is UserDetailsImpl) {
                (authentication.principal as UserDetailsImpl).id
            } else null

            val action = "${method} ${request.requestURI}"
            val status = response.status
            val details = "Status: $status" + (ex?.let { " | Error: ${it.message}" } ?: "")

            auditService.log(
                userId = userId,
                action = action,
                details = details,
                ipAddress = request.remoteAddr
            )
        }
    }
}
