package com.matchmakergaming.security.services

import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.core.userdetails.UsernameNotFoundException
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class UserDetailsServiceImpl(private val userRepository: UserRepository) : UserDetailsService {

    @Transactional
    override fun loadUserByUsername(username: String): UserDetails {
        val user = userRepository.findByPseudo(username)
            .orElseThrow { UsernameNotFoundException("User Not Found with username: $username") }

        return UserDetailsImpl.build(user)
    }
}
