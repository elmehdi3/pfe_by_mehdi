package com.matchmakergaming.config

import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.s3.S3Client
import java.net.URI

@Configuration
class AwsConfig {

    @Value("\${aws.accessKey}")
    private lateinit var accessKey: String

    @Value("\${aws.secretKey}")
    private lateinit var secretKey: String

    @Value("\${aws.region}")
    private lateinit var region: String

    @Value("\${aws.s3.endpoint:#{null}}")
    private var endpoint: String? = null

    @Bean
    fun s3Client(): S3Client {
        val credentials = AwsBasicCredentials.create(accessKey, secretKey)
        val builder = S3Client.builder()
            .credentialsProvider(StaticCredentialsProvider.create(credentials))
            .region(Region.of(region))

        // Permet d'utiliser MinIO en local pour le développement
        endpoint?.let {
            builder.endpointOverride(URI.create(it))
        }

        return builder.build()
    }
}
