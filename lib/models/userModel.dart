class User {
  final String id;
  final String name;
  final int contactNumber;
  final String email;

  User(
      {required this.id,
      required this.name,
      required this.contactNumber,
      required this.email});

  factory User.fromFirestore(Map<String, dynamic> firestore) {
    return User(
      id: firestore['id'] ?? '',
      name: firestore['name'] ?? '',
      contactNumber: firestore['contactNumber'] ?? 0,
      email: firestore['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contactNumber': contactNumber,
      'email': email,
    };
  }
}
