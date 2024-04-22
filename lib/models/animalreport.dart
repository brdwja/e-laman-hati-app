import './addressarea.dart';
import './animaltype.dart';

class AnimalReport {
  final int id;
  final String address;
  final String symptom;
  final Kecamatan kecamatan;
  final Kelurahan kelurahan;
  final AnimalType jenisHewan;
  final String photo;
  final DateTime timestamp;

  @override
  String toString() {
    return 'AnimalReport(id: $id, address: $address, symptom: $symptom, kecamatan: $kecamatan, kelurahan: $kelurahan, jenisHewan: $jenisHewan, photo: $photo, timestamp: $timestamp)';
  }

  const AnimalReport({
    required this.id,
    required this.address,
    required this.symptom,
    required this.kecamatan,
    required this.kelurahan,
    required this.jenisHewan,
    required this.photo,
    required this.timestamp
  });

  factory AnimalReport.fromJson(Map<String, dynamic> json) {
    return AnimalReport(
      id: json['reports_id'],
      address: json['reports_address'],
      symptom: json['reports_symptom'],
      kecamatan: Kecamatan(id: json['district_id'], name: json['district_name']),
      kelurahan: Kelurahan(id: json['neighborhood_id'], name:  json['neighborhood_name']),
      jenisHewan: AnimalType(id: json['animal_type_id'], name: json['animal_type_name']),
      photo: json['document_path'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}