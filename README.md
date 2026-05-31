# Stitch TeamUp - Plateforme de Matchmaking eSports

Stitch TeamUp est une application mobile moderne développée avec **Flutter**, conçue pour connecter les joueurs compétitifs et faciliter la création d'équipes eSports de haut niveau.

## 🚀 Caractéristiques Principales

### 1. Authentification & Onboarding
*   **Connexion & Inscription** : Interface épurée avec intégration sociale (Google, Discord).
*   **Onboarding Immersif** : Présentation en 3 étapes des fonctionnalités clés (Matchmaking, Communication, Réputation).

### 2. Création de Profil Avancée
*   **Setup en 5 Étapes** : Collecte d'identité, sélection de serveurs, statistiques de jeu, et disponibilités hebdomadaires.
*   **Validation des Données** : Résumé complet avant la finalisation du profil.

### 3. Dashboard Core
*   **Accueil Dynamique** : Vue d'ensemble du rang, du taux de victoire et des activités récentes.
*   **Recherche Matchmaking** : Filtres avancés pour trouver des partenaires selon le niveau et le style de jeu.
*   **Gestion de Squad** : Contrôle total sur l'équipe, statut des membres en temps réel et lancement de session.
*   **Chat en Temps Réel** : Messagerie fluide avec bulles de chat stylisées et barre latérale de contacts.

### 4. Fonctionnalités Additionnelles
*   **Statistiques Détaillées** : Analyse approfondie des performances (K/D ratio, évolution du rang).
*   **Centre de Notifications** : Flux d'activité pour les invitations et les alertes système.
*   **Paramètres (Settings)** : Gestion du compte, sécurité (mot de passe), et préférences de confidentialité.
*   **Création d'Équipe** : Flux dédié pour fonder et personnaliser son propre club eSports.

## 🛠️ Stack Technique
*   **Framework** : Flutter (Material 3)
*   **Design** : Mode Sombre Premium, Glassmorphism, Animations fluides.
*   **Typographie** : Sora & Inter (Google Fonts).
*   **Architecture** : Clean Architecture avec widgets réutilisables.

## 📦 Installation

1.  Assurez-vous d'avoir [Flutter SDK](https://docs.flutter.dev/get-started/install) installé.
2.  Clonez le dépôt.
3.  Exécutez la commande suivante pour récupérer les dépendances :
    ```bash
    flutter pub get
    ```
4.  Lancez l'application :
    ```bash
    flutter run
    ```

## 🔧 Backend Firebase Functions
Un backend Firebase Functions est déjà préparé dans le dossier `functions/` pour exposer des API sécurisées de type matchmaking, recherche d'utilisateurs, gestion des amis, création de squads et consultation du leaderboard.

### Initialisation
```bash
cd functions
npm install
```

### Exécution locale
```bash
npm run serve
```

### Déploiement
```bash
npm run deploy
```

## 🎨 Design & Esthétique
L'application utilise un système de design personnalisé basé sur des tons sombres profonds avec des accents néons (Violet Primaire et Vert Tertiaire) pour une expérience utilisateur premium et immersive.

---
*Réalisé dans le cadre d'un Projet de Fin d'Études (PFE).*
