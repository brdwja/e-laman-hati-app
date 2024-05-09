import 'package:elaman_hati/models/addressarea.dart';

class User {
  final String name;
  final String email;
  final String phoneNumber;
  final String idCardNumber;
  final Kecamatan? kecamatan;
  final Kelurahan? kelurahan;

  const User({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.idCardNumber,
    required this.kecamatan,
    required this.kelurahan,
  });

  @override
  String toString() {
    return 'User(name: $name, email: $email, phoneNumber: $phoneNumber, idCardNumber: $idCardNumber, kecamatan: ${kecamatan?.name}, kelurahan: ${kelurahan?.name})';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['users_name'],
      email: json['users_email'],
      phoneNumber: json['users_phone_number'],
      idCardNumber: json['users_id_card_number'],
      kecamatan: json['district_id'] == null ? null : Kecamatan(id: json['district_id'], name: json['district_name']),
      kelurahan: json['neighborhood_id'] == null ? null : Kelurahan(id: json['neighborhood_id'], name: json['neighborhood_name']),
    );
  }
}