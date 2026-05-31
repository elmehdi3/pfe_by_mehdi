# Schéma de la Base de Données - MatchMaker Gaming

Le système utilise **MySQL 8** pour la persistance des données structurées, avec des index optimisés pour le matchmaking.

## 1. Module Utilisateurs & Profils
- **users** : Table centrale. Index unique sur `email`, `pseudo` et `uuid`.
- **player_profiles** : Relation 1:1 avec `users`. Contient les statistiques de jeu et le score de réputation.
- **user_devices** : Suit les terminaux connectés et stocke les tokens FCM pour le Push.

## 2. Module Social & Équipes
- **friends** : Table de liaison. Index composites sur `(user_id, friend_id)` et `(user_id, status)`.
- **teams** : Gère les groupes.
- **team_members** : Table de liaison `M:N` entre Utilisateurs et Équipes avec gestion des rôles (OWNER, MEMBER).
- **invitations** : Gère les demandes de match ou d'équipe avec date d'expiration.

## 3. Module Communication
- **conversations** : Entité de tête pour le chat.
- **conversation_participants** : Gère qui accède à quelle conversation et suit la date de dernière lecture (`last_read_at`).
- **messages** : Stockage des messages. Partitionnement recommandé sur `created_at` pour les gros volumes.

## 4. Module Matching & Analytics
- **matching_history** : Historique complet pour le moteur de recommandation.
- **daily_stats** : Table agrégée par le Job Spring Batch pour les KPIs de performance.

## 5. Sécurité & Audit
- **audit_logs** : Trace toutes les actions sensibles (Ban, Login, Delete).
- **verification_tokens** : Jetons OTP pour email et password reset.
- **refresh_tokens** : Gère les sessions persistantes JWT.

## Diagramme Relationnel (Simplifié)
```text
[User] 1 <--- 1 [Profile]
[User] 1 <--- n [Friends]
[User] 1 <--- n [Devices]
[User] n <--- m [Teams] (via team_members)
[User] n <--- m [Conversations] (via participants)
[Conversation] 1 <--- n [Messages]
```
