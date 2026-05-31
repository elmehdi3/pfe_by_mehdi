package com.matchmakergaming.config

import org.springframework.amqp.core.*
import org.springframework.amqp.rabbit.connection.ConnectionFactory
import org.springframework.amqp.rabbit.core.RabbitTemplate
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

@Configuration
class RabbitMQConfig {

    companion object {
        const val NOTIFICATION_QUEUE = "notification.queue"
        const val MATCHING_EXCHANGE = "matching.exchange"
        const val NOTIFICATION_ROUTING_KEY = "notification.key"
    }

    @Bean
    fun notificationQueue(): Queue = Queue(NOTIFICATION_QUEUE)

    @Bean
    fun matchingExchange(): TopicExchange = TopicExchange(MATCHING_EXCHANGE)

    @Bean
    fun binding(notificationQueue: Queue, matchingExchange: TopicExchange): Binding {
        return BindingBuilder.bind(notificationQueue).to(matchingExchange).with(NOTIFICATION_ROUTING_KEY)
    }

    @Bean
    fun messageConverter(): Jackson2JsonMessageConverter = Jackson2JsonMessageConverter()

    @Bean
    fun rabbitTemplate(connectionFactory: ConnectionFactory): RabbitTemplate {
        val rabbitTemplate = RabbitTemplate(connectionFactory)
        rabbitTemplate.messageConverter = messageConverter()
        return rabbitTemplate
    }
}
