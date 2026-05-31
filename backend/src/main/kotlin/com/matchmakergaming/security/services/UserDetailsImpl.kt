package com.matchmakergaming.security.services

import com.fasterxml.jackson.annotation.JsonIgnore
import com.matchmakergaming.users.domain.model.User
import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.userdetails.UserDetails

class UserDetailsImpl(
    val id: Long,
    private val username: String,
    private val email: String,
    @JsonIgnore
    private val password: String,
    private val authorities: Collection<GrantedAuthority>
) : UserDetails {

    companion object {
        fun build(user: User): UserDetailsImpl {
            val authorities = listOf(SimpleGrantedAuthority(user.role.name))
            return UserDetailsImpl(
                user.id!!,
                user.pseudo,
                user.email,
                user.password,
                authorities
            )
        }
    }

    override fun getAuthorities(): Collection<GrantedAuthority> = authorities
    override fun getPassword(): String = password
    override fun getUsername(): String = username
    override fun isAccountNonExpired(): Boolean = true
    override fun isAccountNonLocked(): Boolean = true
    override fun isCredentialsNonExpired(): Boolean = true
    override fun isEnabled(): Boolean = true
}
