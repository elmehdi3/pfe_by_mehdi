# Rapport de Sécurité - MatchMaker Gaming

## 1. Authentification & Autorisation
- **JWT (JSON Web Tokens)** : Utilisation de tokens d'accès à courte durée de vie et de tokens de rafraîchissement (Refresh Tokens) stockés en base de données pour gérer les sessions.
- **Spring Security** : Configuration d'une chaîne de filtres sans état (Stateless).
- **Rôles (RBAC)** : 
    - `ROLE_USER` : Accès standard.
    - `ROLE_PREMIUM` : Accès illimité au matching.
    - `ROLE_MODERATOR` : Accès aux signalements.
    - `ROLE_ADMIN` : Accès total et analytics.

## 2. Protection des Données
- **Mots de passe** : Hachage via **BCrypt** avec un facteur de coût de 10.
- **SQL Injection** : Utilisation systématique de **Spring Data JPA** (Prepared Statements) qui immunise contre les injections SQL.
- **XSS (Cross-Site Scripting)** : Filtrage des entrées via `@Valid` et assainissement automatique des messages de chat par le `ChatModerationService`.

## 3. Sécurité Avancée
- **Double Authentification (2FA)** : Optionnelle via code OTP envoyé par email (stocké temporairement dans Redis).
- **Rate Limiting** : Limitation du débit par adresse IP via Redis pour prévenir les attaques par force brute et le déni de service (DoS).
- **Audit Logging** : Traçabilité complète des actions sensibles (Login, Ban, Update Profile) via le `AuditInterceptor`.
- **Gestion des Appareils** : Possibilité pour l'utilisateur de révoquer un jeton FCM ou une session à distance.

## 4. Sécurité des Communications
- **HTTPS** : Recommandé pour toutes les communications API (terminé au niveau Nginx/Load Balancer).
- **WSS** : Sécurisation des WebSockets via un intercepteur JWT (`WebSocketJwtInterceptor`).
