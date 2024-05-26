import 'package:time_machine/time_machine.dart';

class RFIDAnimal {
  final String rfidToken;
  final DateTime age;
  final String weight;
  final String photo;
  final DateTime timestamp;
  final String animalType;
  final String gender;
  final String owner;

  const RFIDAnimal({
    required this.rfidToken,
    required this.age,
    required this.weight,
    required this.photo,
    required this.timestamp,
    required this.animalType,
    required this.gender,
    required this.owner,
  });

  @override
  String toString() {
    return 'RFIDAnimal(rfidToken: $rfidToken, age: $age, weight: $weight, photo: $photo, timestamp: $timestamp, animalType: $animalType, gender: $gender, owner: $owner)';
  }

  String getAge() {
    Period age = LocalDate.today().periodSince(LocalDate.dateTime(this.age));
    return "${age.years > 0 ? "${age.years} Tahun " : ''}${age.months} Bulan";
  }

  factory RFIDAnimal.fromJson(Map<String, dynamic> json) {
    return RFIDAnimal(
      rfidToken: json['rfid_token'],
      age: DateTime.parse(json['age']),
      weight: json['weight'],
      photo: json['animal_picture_url'],
      timestamp: DateTime.parse(json['created_at']),
      animalType: json['animal_type'],
      gender: json['gender'],
      owner: json['owner'],
    );
  }
}