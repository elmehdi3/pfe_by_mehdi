# Stitch TeamUp Backend

Backend Firebase Functions for Stitch TeamUp. This project exposes HTTP endpoints for user profiles, leaderboards, squads, friend requests, matchmaking, and search.

## Setup

1. Install dependencies:
   ```bash
   cd functions
   npm install
   ```
2. Run the functions emulator:
   ```bash
   npm run serve
   ```
3. Deploy to Firebase:
   ```bash
   npm run deploy
   ```

## Endpoints

- `GET /user/:uid`
- `GET /leaderboard`
- `GET /squads`
- `POST /squads`
- `POST /friend-request`
- `POST /friend-request/:requestId/accept`
- `POST /friend-request/:requestId/decline`
- `GET /search-users?q=...`
- `POST /matchmaking`

All requests require a Firebase ID token in the `Authorization: Bearer <token>` header.
