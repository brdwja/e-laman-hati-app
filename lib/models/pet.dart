// ignore_for_file: non_constant_identifier_names

class Pet {
  final int id;
  final String animal_name;
  final int type_of_animal_id;
  final String gender;
  final DateTime date_of_birth;
  final DateTime age;
  final DateTime? lastVaccine;
  final DateTime? lastSterile;
  final String image;
  final bool is_dead;
  final String id_chip;
  final int owner_id;
  final double weight;
  final DateTime? dead_date;

  Pet({
    required this.id,
    required this.animal_name,
    required this.type_of_animal_id,
    required this.gender,
    required this.date_of_birth,
    required this.age,
    required this.lastVaccine,
    required this.lastSterile,
    required this.image,
    required this.is_dead,
    required this.id_chip,
    required this.owner_id,
    required this.weight,
    required this.dead_date,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      animal_name: json['animal_name'] ?? '',
      type_of_animal_id: json['type_of_animal_id'] ?? 0,
      gender: json['gender'] ?? '-',
      date_of_birth: DateTime.tryParse(json['date_of_birth']) ?? DateTime.now(),
      age: DateTime.now(),
      lastSterile:
          json['sterile'] != null ? DateTime.parse(json['sterile']) : null,
      lastVaccine:
          json['vaccine'] != null ? DateTime.parse(json['vaccine']) : null,
      image: json['image'] ?? '',
      is_dead: json['is_dead'] ?? false,
      id_chip: json['id_chip'] ?? '',
      owner_id: json['owner_id'] ?? 0,
      weight: double.tryParse(json['weight'].toString()) ?? 0,
      dead_date: json['dead_date'] != null
          ? DateTime.tryParse(json['dead_date'])
          : null,
    );
  }

  String getAge() {
    final now = DateTime.now();
    final duration = now.difference(date_of_birth);
    final years = (duration.inDays / 365).floor();
    final months = ((duration.inDays % 365) / 30).floor();
    return "$years tahun ${months > 0 ? '$months bulan' : ''}".trim();
  }
}
