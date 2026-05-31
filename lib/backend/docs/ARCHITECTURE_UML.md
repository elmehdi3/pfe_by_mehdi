# Diagrammes UML - MatchMaker Gaming

## 1. Diagramme de Classes Global (Extrait)
```plantuml
@startuml
package "User Module" {
    class User {
        +Long id
        +String uuid
        +String email
        +UserRole role
        +Boolean isPremium
    }
}

package "Profile Module" {
    class PlayerProfile {
        +Long id
        +PlayerLevel level
        +Double reputationScore
        +PlayerStatistics statistics
    }
}

User "1" -- "1" PlayerProfile
@enduml
```

## 2. Diagramme de Séquence : Flux de Matchmaking Intelligent
```plantuml
@startuml
actor Player
participant "MatchingController" as MC
participant "MatchingService" as MS
participant "PremiumValidator" as PV
participant "NotificationService" as NS
database "MySQL" as DB

Player -> MC : GET /matching/smart/{gameId}
MC -> MS : findCompatiblePlayers(userId, gameId)
MS -> PV : canPerformMatching(userId)
PV -> DB : Count recent matches
PV --> MS : Boolean
MS -> DB : findPotentialMatches(filters)
DB --> MS : List<PlayerProfile>
MS -> MS : calculateScores()
MS -> DB : saveMatchingHistory()
MS -> NS : publish MatchFoundEvent
NS -> Player : WebSocket: /queue/notifications
MC -> Player : 200 OK (List<MatchResponseDTO>)
@enduml
```

## 3. Diagramme de Composants (Architecture Modulaire)
```plantuml
@startuml
package "MatchMaker Backend" {
    [Auth Module]
    [Social Module]
    [Matching Engine]
    [Chat Module]
    [Notification Service]
}

cloud "External Services" {
    [AWS S3]
    [Firebase FCM]
    [Google/Apple OAuth]
}

database "MySQL" {
    [Persistent Data]
}

database "Redis" {
    [Presence & Cache]
}

queue "RabbitMQ" {
    [Async Tasks]
}

[Auth Module] --> [Google/Apple OAuth]
[Social Module] --> [MySQL]
[Chat Module] --> [Redis]
[Notification Service] --> [Firebase FCM]
[Matching Engine] --> [Redis]
@enduml
```

## 4. Architecture Cible (Microservices Ready)
```plantuml
@startuml
node "Gateway / Nginx" as GW
node "Auth Service" as AS
node "User/Profile Service" as US
node "Matching Service" as MS
node "Chat/Presence Service" as CS

GW --> AS
GW --> US
GW --> MS
GW --> CS

AS ..> US : Sync (gRPC/REST)
MS ..> US : Sync (gRPC/REST)
CS ..> AS : Sync (JWT Validation)

MS -> [RabbitMQ] : Match Found
[RabbitMQ] -> CS : Notify Users
@enduml
```
