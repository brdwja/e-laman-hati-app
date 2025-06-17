import 'package:elaman_hati/models/addressarea.dart';

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? idCardNumber;
  final String? address;
  final Kecamatan? kecamatan;
  final Kelurahan? kelurahan;
  final String? role;
  final String? createdAt;
  final String? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.idCardNumber,
    this.address,
    this.kecamatan,
    this.kelurahan,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  @override
  // String toString() {
  //   return '(name: $name, email: $email, phoneNumber: $phoneNumber, idCardNumber: $idCardNumber, id_district: $kecamatan, id_sub_district: $kelurahan, role: $role)';
  // }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      idCardNumber: json['id_card_number'],
      address: json['address'],
      kecamatan: json['kecamatan'] != null
          ? Kecamatan.fromJson(json['kecamatan'])
          : null,
      kelurahan: json['kelurahan'] != null
          ? Kelurahan.fromJson(json['kelurahan'])
          : null,
      role: json['role'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'], // Pastikan key sesuai JSON
    );
  }
}
