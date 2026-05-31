const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express');
const cors = require('cors');

admin.initializeApp();
const db = admin.firestore();
const app = express();
app.use(cors({ origin: true }));
app.use(express.json());

const rankWeights = {
  bronze: 1,
  silver: 2,
  gold: 3,
  platinum: 4,
  diamond: 5,
  master: 6,
  grandmaster: 7,
  challenger: 8,
};

function parseRank(rank) {
  if (!rank) return '';
  return String(rank).trim().split(' ')[0].toLowerCase();
}

function getRankScore(rank) {
  return rankWeights[parseRank(rank)] || 0;
}

function getAvailabilityOverlap(userAvailability, candidateAvailability) {
  if (!userAvailability || !candidateAvailability) return 0;

  let overlap = 0;
  Object.keys(userAvailability).forEach((day) => {
    const userSlots = userAvailability[day];
    const candidateSlots = candidateAvailability[day];
    if (Array.isArray(userSlots) && Array.isArray(candidateSlots)) {
      overlap += userSlots.filter((slot) => candidateSlots.includes(slot)).length;
    }
  });

  return overlap;
}

async function verifyAuth(req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Missing Authorization header.' });
  }

  const idToken = authHeader.split('Bearer ')[1];
  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    req.user = decodedToken;
    next();
  } catch (error) {
    console.error('Auth verification failed:', error);
    return res.status(401).json({ error: 'Invalid auth token.' });
  }
}

app.get('/user/:uid', verifyAuth, async (req, res) => {
  try {
    const uid = req.params.uid;
    const doc = await db.collection('users').doc(uid).get();
    if (!doc.exists) {
      return res.status(404).json({ error: 'User profile not found.' });
    }
    return res.json({ id: doc.id, ...doc.data() });
  } catch (error) {
    console.error('Error fetching user profile:', error);
    return res.status(500).json({ error: 'Unable to fetch user profile.' });
  }
});

app.get('/leaderboard', verifyAuth, async (req, res) => {
  try {
    const sortField = req.query.sortField || 'reputationScore';
    const limit = Number(req.query.limit || 50);
    const snapshot = await db
      .collection('users')
      .orderBy(sortField, 'desc')
      .limit(limit)
      .get();

    const players = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    return res.json({ players });
  } catch (error) {
    console.error('Error fetching leaderboard:', error);
    return res.status(500).json({ error: 'Unable to load leaderboard.' });
  }
});

app.get('/squads', verifyAuth, async (req, res) => {
  try {
    const snapshot = await db.collection('squads').get();
    const squads = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    return res.json({ squads });
  } catch (error) {
    console.error('Error fetching squads:', error);
    return res.status(500).json({ error: 'Unable to load squads.' });
  }
});

app.post('/squads', verifyAuth, async (req, res) => {
  try {
    const squadData = req.body;
    if (!squadData || typeof squadData !== 'object') {
      return res.status(400).json({ error: 'Invalid squad payload.' });
    }

    const result = await db.collection('squads').add({
      ...squadData,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return res.json({ squadId: result.id });
  } catch (error) {
    console.error('Error creating squad:', error);
    return res.status(500).json({ error: 'Unable to create squad.' });
  }
});

app.post('/friend-request', verifyAuth, async (req, res) => {
  try {
    const fromUid = req.user.uid;
    const { toUid } = req.body;
    if (!toUid) {
      return res.status(400).json({ error: 'Missing toUid parameter.' });
    }

    const requestId = `${fromUid}_${toUid}`;
    await db.collection('friendRequests').doc(requestId).set({
      from: fromUid,
      to: toUid,
      status: 'pending',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return res.json({ requestId });
  } catch (error) {
    console.error('Error sending friend request:', error);
    return res.status(500).json({ error: 'Unable to send friend request.' });
  }
});

app.post('/friend-request/:requestId/accept', verifyAuth, async (req, res) => {
  try {
    const requestId = req.params.requestId;
    const requestDoc = await db.collection('friendRequests').doc(requestId).get();
    if (!requestDoc.exists) {
      return res.status(404).json({ error: 'Friend request not found.' });
    }

    const requestData = requestDoc.data();
    if (!requestData) {
      return res.status(404).json({ error: 'Friend request data missing.' });
    }

    const batch = db.batch();
    const fromUid = requestData.from;
    const toUid = requestData.to;

    batch.set(db.collection('users').doc(toUid).collection('friends').doc(fromUid), {
      status: 'accepted',
      since: admin.firestore.FieldValue.serverTimestamp(),
    });
    batch.set(db.collection('users').doc(fromUid).collection('friends').doc(toUid), {
      status: 'accepted',
      since: admin.firestore.FieldValue.serverTimestamp(),
    });
    batch.update(db.collection('friendRequests').doc(requestId), { status: 'accepted' });
    await batch.commit();

    return res.json({ success: true });
  } catch (error) {
    console.error('Error accepting friend request:', error);
    return res.status(500).json({ error: 'Unable to accept friend request.' });
  }
});

app.post('/friend-request/:requestId/decline', verifyAuth, async (req, res) => {
  try {
    const requestId = req.params.requestId;
    await db.collection('friendRequests').doc(requestId).update({ status: 'declined' });
    return res.json({ success: true });
  } catch (error) {
    console.error('Error declining friend request:', error);
    return res.status(500).json({ error: 'Unable to decline friend request.' });
  }
});

app.get('/search-users', verifyAuth, async (req, res) => {
  try {
    const query = String(req.query.q || '').trim().toLowerCase();
    if (!query) {
      return res.status(400).json({ error: 'Query parameter q is required.' });
    }

    const upperBound = query.substring(0, query.length - 1) +
      String.fromCharCode(query.charCodeAt(query.length - 1) + 1);

    const snapshot = await db.collection('users')
      .where('gamertagLower', '>=', query)
      .where('gamertagLower', '<', upperBound)
      .limit(30)
      .get();

    const users = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    return res.json({ users });
  } catch (error) {
    console.error('Error searching users:', error);
    return res.status(500).json({ error: 'Unable to search users.' });
  }
});

app.post('/matchmaking', verifyAuth, async (req, res) => {
  try {
    const userId = req.user.uid;
    const { favoriteGame, server, availability, maxResults = 20 } = req.body;

    let query = db.collection('users');
    if (favoriteGame) {
      query = query.where('favoriteGame', '==', favoriteGame);
    }
    if (server) {
      query = query.where('servers', 'array-contains', server);
    }

    const snapshot = await query.limit(200).get();
    const candidates = snapshot.docs
      .filter((doc) => doc.id !== userId)
      .map((doc) => ({ id: doc.id, ...doc.data() }));

    const currentRankScore = getRankScore(req.body.gameRank || '');
    const scoredCandidates = candidates.map((candidate) => {
      const candidateRankScore = getRankScore(candidate.gameRank);
      const rankDifference = Math.abs(currentRankScore - candidateRankScore);
      const availabilityScore = getAvailabilityOverlap(availability, candidate.availability);
      const serverMatch = candidate.servers && Array.isArray(candidate.servers) && server && candidate.servers.includes(server) ? 1 : 0;

      const score = 100 - rankDifference * 10 + availabilityScore * 25 + serverMatch * 15;
      return { candidate, score };
    });

    scoredCandidates.sort((a, b) => b.score - a.score);
    const matches = scoredCandidates.slice(0, maxResults).map((entry) => entry.candidate);

    return res.json({ matches });
  } catch (error) {
    console.error('Error running matchmaking:', error);
    return res.status(500).json({ error: 'Unable to run matchmaking.' });
  }
});

exports.api = functions.https.onRequest(app);
