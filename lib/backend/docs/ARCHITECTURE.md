# Architecture Technique - MatchMaker Gaming

Ce projet suit les principes de la **Clean Architecture** et du **Domain-Driven Design (DDD)**.

## 1. Structure des Modules
Chaque module (ex: `auth`, `matching`, `chat`) est découpé en 4 couches :

- **Domain** : Contient les entités JPA, les énumérations et les interfaces de repository. C'est le coeur métier, indépendant des frameworks.
- **Application** : Contient les Services, les DTOs et les Mappers. C'est ici qu'est orchestrée la logique métier.
- **Infrastructure** : Contient les implémentations spécifiques (Persistence, clients API externes comme S3 ou FCM, configurations Redis/RabbitMQ).
- **Presentation** : Contient les Contrôleurs REST et les points d'entrée WebSocket.

## 2. Flux de Données
1. Le client (Flutter) appelle un **Controller**.
2. Le Controller reçoit un Payload (Request) et appelle un **Service**.
3. Le Service interagit avec le **Repository** (Infrastructure) pour récupérer des **Entities**.
4. Le Service traite la logique métier et utilise un **Mapper** pour transformer l'Entity en **DTO**.
5. Le Controller renvoie le DTO encapsulé dans une `ApiResponse`.

## 3. Communication Inter-Modules
- **Appels Synchrones** : Via les Services (ex: `MatchingService` appelle `PlayerProfileRepository`).
- **Appels Asynchrones** : Via **RabbitMQ** pour les tâches lourdes ou non bloquantes (Notifications, Emails, Analytics).
- **Temps Réel** : Via **WebSockets (STOMP)** pour le Chat et les notifications instantanées.

## 4. Stratégie de Cache
Utilisation de **Redis** pour :
- Le cache applicatif Spring (@Cacheable).
- La gestion de la présence (`user:presence`).
- Le Rate Limiting IP.
- Les files d'attente de matching rapide.
