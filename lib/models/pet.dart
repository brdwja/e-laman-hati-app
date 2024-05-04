import 'package:elaman_hati/models/idvalue.dart';
import 'package:time_machine/time_machine.dart';

class Pet {
  const Pet({
    required this.id,
    required this.name,
    required this.age,
    required this.lastVaccine,
    required this.lastSterile,
    required this.photo,
    required this.petType,
    required this.sterileStatus,
    required this.gender
  });

  @override
  String toString() {
    return 'Pet(id: $id, name: $name, age: $age, lastVaccine: $lastVaccine, lastSterile: $lastSterile, photo: $photo, petType: ${petType.name}, sterileStatus: ${sterileStatus.name}, gender: ${gender.name})';
  }

  final int id;
  final String name;
  final DateTime age;
  final DateTime? lastVaccine;
  final DateTime? lastSterile;
  final String photo;
  final IDValue petType;
  final IDValue sterileStatus;
  final IDValue gender;

  String getAge() {
    Period age = LocalDate.today().periodSince(LocalDate.dateTime(this.age));
    return "${age.years > 0 ? "${age.years} Tahun " : ''}${age.months} Bulan";
  }

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['pet_ownership_id'],
      name: json['pet_ownership_name'],
      age: DateTime.parse(json['pet_ownership_age']),
      lastVaccine: json['pet_ownership_last_vaccine'] != null ? DateTime.parse(json['pet_ownership_last_vaccine']) : null,
      lastSterile: json['pet_ownership_last_sterile'] != null ? DateTime.parse(json['pet_ownership_last_sterile']) : null,
      photo: json['document_path'],
      petType: IDValue(id: json['pet_type_id'], name: json['pet_type_name']),
      sterileStatus: IDValue(id: json['sterile_id'], name: json['sterile_status']),
      gender: IDValue(id: json['gender_id'], name: json['gender_name']),
    );
  }
}