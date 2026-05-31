package com.matchmakergaming.security.rate

import org.springframework.data.redis.core.RedisTemplate
import org.springframework.http.HttpStatus
import org.springframework.stereotype.Component
import org.springframework.web.servlet.HandlerInterceptor
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import java.util.concurrent.TimeUnit

@Component
class RateLimitInterceptor(private val redisTemplate: RedisTemplate<String, Any>) : HandlerInterceptor {

    private val RATE_LIMIT_PREFIX = "rate_limit:ip:"
    private val MAX_REQUESTS = 100 // par minute
    private val TIME_WINDOW = 1L

    override fun preHandle(request: HttpServletRequest, response: HttpServletResponse, handler: Any): Boolean {
        val ip = request.remoteAddr
        val key = "$RATE_LIMIT_PREFIX$ip"

        val count = redisTemplate.opsForValue().increment(key) ?: 1

        if (count == 1L) {
            redisTemplate.expire(key, TIME_WINDOW, TimeUnit.MINUTES)
        }

        if (count > MAX_REQUESTS) {
            response.status = HttpStatus.TOO_MANY_REQUESTS.value()
            response.writer.write("Too many requests. Please try again in a minute.")
            return false
        }

        return true
    }
}
