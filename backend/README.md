# MatchMaker Gaming Backend

## Architecture
- **Clean Architecture** & **DDD**
- **Spring Boot 3.x** & **Kotlin 2.x**
- **JWT Authentication** (Access & Refresh Tokens)
- **Matching Engine**: Intelligent (Scoring) & Random (Redis-based)
- **Chat**: Real-time via WebSockets (STOMP)
- **Messaging**: RabbitMQ for async notifications

## Stack
- MySQL 8
- Redis
- RabbitMQ
- Docker & Docker Compose

## Quick Start
```bash
docker-compose up --build
```

## API Documentation
Swagger UI: `http://localhost:8080/swagger-ui/index.html`
