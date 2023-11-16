import 'package:firebase_auth/firebase_auth.dart';

class CustomUser {
  final User? user; // O objeto User do Firebase Authentication
  final String? username;
  final List<String>? allergies;
  final String? skinType;
  final bool? vegan;

  CustomUser({
    this.user,
    this.username,
    this.allergies,
    this.skinType,
    this.vegan,
  });

  factory CustomUser.fromFirebase(User? user, Map<String, dynamic> data) {
    return CustomUser(
      user: user,
      username: data['username'],
      allergies: List<String>.from(data['allergies'] ?? []),
      skinType: data['skinType'],
      vegan: data['vegan'],
    );
  }
}
