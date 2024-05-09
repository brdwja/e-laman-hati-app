import 'package:elaman_hati/models/addressarea.dart';

class Doctor {
  final Kecamatan kecamatan;
  final Kelurahan kelurahan;
  final int id;
  final String name;
  final String address;

  const Doctor({
    required this.kecamatan,
    required this.kelurahan,
    required this.id,
    required this.name,
    required this.address,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      kecamatan: Kecamatan(id: json['district_id'], name: json['district_name']),
      kelurahan: Kelurahan(id: json['neighborhood_id'], name: json['neighborhood_name']),
      id: json['doctor_id'],
      name: json['doctor_name'],
      address: json['doctor_address'],
    );
  }
}