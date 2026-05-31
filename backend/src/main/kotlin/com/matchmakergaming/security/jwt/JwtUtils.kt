package com.matchmakergaming.security.jwt

import io.jsonwebtoken.Jwts
import io.jsonwebtoken.SignatureAlgorithm
import io.jsonwebtoken.security.Keys
import org.springframework.beans.factory.annotation.Value
import org.springframework.security.core.Authentication
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.stereotype.Component
import java.util.*
import javax.crypto.SecretKey

@Component
class JwtUtils {

    @Value("\${matchmaker.jwt.secret}")
    private lateinit var jwtSecret: String

    @Value("\${matchmaker.jwt.expirationMs}")
    private var jwtExpirationMs: Int = 0

    private fun getSigningKey(): SecretKey {
        return Keys.hmacShaKeyFor(jwtSecret.toByteArray())
    }

    fun generateJwtToken(authentication: Authentication): String {
        val userPrincipal = authentication.principal as UserDetails
        return Jwts.builder()
            .subject(userPrincipal.username)
            .issuedAt(Date())
            .expiration(Date(Date().time + jwtExpirationMs))
            .signWith(getSigningKey())
            .compact()
    }

    fun getUserNameFromJwtToken(token: String): String {
        return Jwts.parser()
            .verifyWith(getSigningKey())
            .build()
            .parseSignedClaims(token)
            .payload
            .subject
    }

    fun validateJwtToken(authToken: String): Boolean {
        return try {
            Jwts.parser().verifyWith(getSigningKey()).build().parseSignedClaims(authToken)
            true
        } catch (e: Exception) {
            false
        }
    }
}
