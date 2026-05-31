package com.matchmakergaming.premium.application

import com.matchmakergaming.premium.application.dto.SubscriptionDTO
import com.matchmakergaming.premium.application.mapper.SubscriptionMapper
import com.matchmakergaming.premium.domain.model.Subscription
import com.matchmakergaming.premium.domain.model.SubscriptionPlan
import com.matchmakergaming.premium.infrastructure.persistence.SubscriptionRepository
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDateTime

@Service
class PremiumService(
    private val subscriptionRepository: SubscriptionRepository,
    private val userRepository: UserRepository,
    private val subscriptionMapper: SubscriptionMapper
) {

    @Transactional
    fun subscribe(userId: Long, plan: SubscriptionPlan): SubscriptionDTO {
        val user = userRepository.findById(userId).orElseThrow { RuntimeException("User not found") }
        
        val price = when(plan) {
            SubscriptionPlan.MONTHLY -> 9.99
            SubscriptionPlan.YEARLY -> 89.99
            SubscriptionPlan.LIFETIME -> 199.99
            SubscriptionPlan.FREE -> 0.0
        }

        val endDate = when(plan) {
            SubscriptionPlan.MONTHLY -> LocalDateTime.now().plusMonths(1)
            SubscriptionPlan.YEARLY -> LocalDateTime.now().plusYears(1)
            else -> null
        }

        val subscription = Subscription(
            userId = userId,
            plan = plan,
            price = price,
            endDate = endDate
        )

        user.isPremium = (plan != SubscriptionPlan.FREE)
        userRepository.save(user)
        
        val saved = subscriptionRepository.save(subscription)
        return subscriptionMapper.toDTO(saved)
    }

    fun getUserSubscription(userId: Long): SubscriptionDTO? {
        return subscriptionRepository.findAll()
            .filter { it.userId == userId }
            .lastOrNull()
            ?.let { subscriptionMapper.toDTO(it) }
    }
}
