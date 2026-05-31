package com.matchmakergaming.moderation.application

import org.springframework.stereotype.Service

@Service
class ChatModerationService {

    // Liste simplifiée, en production on utiliserait une table MySQL ou un service externe d'IA
    private val forbiddenWords = listOf("insulte1", "toxic2", "spam3") 

    fun filterMessage(content: String): String {
        var filteredContent = content
        forbiddenWords.forEach { word ->
            if (filteredContent.contains(word, ignoreCase = true)) {
                filteredContent = filteredContent.replace(word, "****", ignoreCase = true)
            }
        }
        return filteredContent
    }

    fun containsExtremeToxicity(content: String): Boolean {
        // Logique pour détecter si le message est tellement grave qu'il nécessite un signalement auto
        val toxicCount = forbiddenWords.count { content.contains(it, ignoreCase = true) }
        return toxicCount > 3
    }
}
