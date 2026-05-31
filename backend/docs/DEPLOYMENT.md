# Stratégie de Déploiement - MatchMaker Gaming

## 1. Infrastructure Cible (AWS)
Pour supporter 1 million d'utilisateurs, nous recommandons :
- **Compute** : Amazon EKS (Kubernetes) avec Auto-scaling.
- **Base de données** : Amazon RDS MySQL 8 (Multi-AZ pour la haute disponibilité).
- **Cache & Presence** : Amazon ElastiCache for Redis (Cluster mode).
- **Messaging** : Amazon MQ (RabbitMQ) ou Cluster RabbitMQ auto-hébergé sur EC2.
- **Stockage** : Amazon S3 pour les médias.
- **CDN** : Amazon CloudFront pour servir les images avec une faible latence mondiale.

## 2. Déploiement via Kubernetes
Utilisez les fichiers dans `/k8s` pour déployer l'application.
```bash
# Appliquer la configuration
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secrets.yaml
kubectl apply -f k8s/deployment.yaml
```

## 3. Stratégie de Mise à jour
- **Rolling Update** : Déploiement progressif pour éviter toute interruption de service (Zero Downtime).
- **Blue/Green** : Recommandé pour les mises à jour majeures du schéma de base de données.

## 4. Monitoring en Production
- **Logs** : Stack ELK (Elasticsearch, Logstash, Kibana) pour la centralisation des logs.
- **Métriques** : Prometheus pour collecter les données d'Actuator et Grafana pour la visualisation.
- **Alerting** : Configurer des alertes Slack/Email via Prometheus Alertmanager sur les erreurs 5xx et la latence > 500ms.
