import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Update user profile
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  // Get user profile
  Future<UserModel?> getUserProfile(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(uid, doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Squad operations
  Stream<List<Map<String, dynamic>>> getSquads() {
    return _firestore.collection('squads').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    });
  }

  Future<void> createSquad(Map<String, dynamic> squadData) async {
    await _firestore.collection('squads').add({
      ...squadData,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Real-time user stream
  Stream<UserModel?> userStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromMap(uid, doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }
}
