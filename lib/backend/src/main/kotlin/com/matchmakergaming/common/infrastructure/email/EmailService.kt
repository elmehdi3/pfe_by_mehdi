package com.matchmakergaming.common.infrastructure.email

import org.springframework.mail.javamail.JavaMailSender
import org.springframework.mail.javamail.MimeMessageHelper
import org.springframework.scheduling.annotation.Async
import org.springframework.stereotype.Service
import org.slf4j.LoggerFactory

@Service
class EmailService(private val mailSender: JavaMailSender) {
    private val logger = LoggerFactory.getLogger(EmailService::class.java)

    @Async
    fun sendHtmlEmail(to: String, subject: String, htmlBody: String) {
        try {
            val message = mailSender.createMimeMessage()
            val helper = MimeMessageHelper(message, true, "UTF-8")
            helper.setTo(to)
            helper.setSubject(subject)
            helper.setText(htmlBody, true)
            helper.setFrom("no-reply@matchmakergaming.com")
            
            mailSender.send(message)
            logger.info("Email sent successfully to $to")
        } catch (e: Exception) {
            logger.error("Failed to send email to $to", e)
        }
    }

    fun sendVerificationEmail(to: String, token: String) {
        val body = """
            <h1>Vérifiez votre compte MatchMaker</h1>
            <p>Utilisez le code suivant pour valider votre inscription :</p>
            <h2 style="color: #6200EE;">$token</h2>
        """.trimIndent()
        sendHtmlEmail(to, "Code de vérification - MatchMaker Gaming", body)
    }
}
