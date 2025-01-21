import 'package:bloc_crud/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<User>> fetchUsers() async {
    final snapshot = await _firestore.collection('users').orderBy('name').get();
    return snapshot.docs
        .map(
          (doc) => User(
            id: doc.id,
            name: doc.data()['name'] as String,
            contactNumber: doc.data()['contactNumber'] as int,
            email: doc.data()['email'] as String,
          ),
        )
        .toList();
  }

  Future<void> addUser(User user) async {
    await _firestore.collection('users').add({
      'name': user.name,
      'contactNumber': user.contactNumber,
      'email': user.email,
    });
  }

  Future<void> updateUser(User user) async {
    final docRef = _firestore.collection('users').doc(user.id.toString());

    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      throw Exception('Document Not Found: ${user.id}');
    }

    await docRef.update({
      'name': user.name,
      'contactNumber': user.contactNumber,
      'email': user.email,
    });
  }

  Future<void> deleteUser(String userId) async {
    final docRef = _firestore.collection('users').doc(userId);

    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      throw Exception('Document not found: $userId');
    }

    await docRef.delete();
  }
}
