import 'package:firebase_auth/firebase_auth.dart';

class Company {
  final User? user;
  final String? name;
  final String? url;
  final int? cnpj;
  final int? phone;

  Company(
      {this.user,
      this.name,
      this.url,
      this.cnpj,
      this.phone});

  factory Company.fromFirebase(User? user, Map<String, dynamic> data) {
    return Company(
      name: data['name'],
      url: data['username'],
      cnpj: data['cnpj'],
      phone: data['phone']
    );
  }
}
