# Guide d'Installation - MatchMaker Gaming Backend

## Prérequis
- Java 17+
- Docker & Docker Compose
- Gradle 8.x

## Configuration de l'environnement
1. Clonez le dépôt.
2. Créez un fichier `.env` à la racine (ou utilisez `application.yml`).
3. Configurez les accès AWS S3 et FCM si vous souhaitez tester les notifications push réelles.

## Lancement Rapide (Docker)
Pour lancer toute la stack (MySQL, Redis, RabbitMQ, App) :
```bash
docker-compose up --build
```

## Lancement en Développement
1. Lancer les dépendances uniquement :
```bash
docker-compose up db redis rabbitmq -d
```
2. Lancer l'application Spring Boot :
```bash
./gradlew bootRun
```

## Accès aux services
- **API REST** : `http://localhost:8080/api/v1`
- **Swagger UI** : `http://localhost:8080/swagger-ui/index.html`
- **Prometheus** : `http://localhost:8080/actuator/prometheus`
- **Admin RabbitMQ** : `http://localhost:15672` (guest/guest)
