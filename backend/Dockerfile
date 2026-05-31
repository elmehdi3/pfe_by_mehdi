# Stage 1: Build
FROM gradle:8.7-jdk17 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
# On ignore les tests pour accélérer le build de l'image (les tests sont gérés par le pipeline CI)
RUN gradle build --no-daemon -x test

# Stage 2: Run - Empreinte minimale avec Alpine
FROM eclipse-temurin:17-jre-alpine

# Création d'un groupe et d'un utilisateur système pour ne pas tourner en root
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

ARG JAR_FILE=/home/gradle/src/build/libs/*.jar
COPY --from=build ${JAR_FILE} app.jar

EXPOSE 8080

# Optimisations JVM pour container (CGroup awareness)
# -XX:+UseContainerSupport : Respecte les limites CPU/RAM de Kubernetes
# -XX:MaxRAMPercentage : Alloue 75% de la RAM du container à la Heap
ENTRYPOINT ["java", \
            "-XX:+UseContainerSupport", \
            "-XX:MaxRAMPercentage=75.0", \
            "-Djava.security.egd=file:/dev/./urandom", \
            "-jar", \
            "/app.jar"]
