import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserService {
  final _db = FirebaseFirestore.instance;

  Future<User?> getUserById(String id) async {
    final doc = await _db.collection('users').doc(id).get();
    if (!doc.exists) return null;
    return User.fromJson({...doc.data()!, 'id': doc.id});
  }

  Stream<List<User>> getAllUsers() {
    return _db
        .collection('users')
        .orderBy('lastName')
        .orderBy('firstName')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => User.fromJson({...doc.data(), 'id': doc.id}))
                  .toList(),
        );
  }
}
