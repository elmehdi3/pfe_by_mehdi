import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
    stages: [
        { duration: '2m', target: 100 }, // Montée en charge progressive à 100 VU
        { duration: '5m', target: 500 }, // Stress à 500 VU (simule une charge massive)
        { duration: '2m', target: 0 },   // Redescente
    ],
    thresholds: {
        http_req_duration: ['p(95)<500'], // 95% des requêtes doivent être < 500ms
    },
};

const BASE_URL = 'http://localhost:8080/api/v1';

export default function () {
    // 1. Simulation d'un login (On utilise des users de test créés au préalable)
    let loginRes = http.post(`${BASE_URL}/auth/signin`, JSON.stringify({
        pseudo: 'testuser',
        password: 'password123'
    }), { headers: { 'Content-Type': 'application/json' } });

    check(loginRes, { 'logged in successfully': (r) => r.status === 200 });

    if (loginRes.status === 200) {
        const token = loginRes.json().data.token;
        const authHeaders = { headers: { 'Authorization': `Bearer ${token}` } };

        // 2. Recherche de match intelligent
        let matchRes = http.get(`${BASE_URL}/matching/smart/1`, authHeaders);
        check(matchRes, { 'matching results received': (r) => r.status === 200 });

        // 3. Consultation du profil
        let profileRes = http.get(`${BASE_URL}/profiles/1`, authHeaders);
        check(profileRes, { 'profile retrieved': (r) => r.status === 200 });

        // 4. Envoi d'un message (Simulé via REST ou on pourrait utiliser k6/ws pour WebSocket)
        sleep(1);
    }

    sleep(Math.random() * 3);
}
