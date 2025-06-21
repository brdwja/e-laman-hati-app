class RFIDAnimal {
  final String rfidToken;
  final String owner;
  final String animalType;
  final String gender;
  final double weight;
  final int age;
  final DateTime reportedAt;

  const RFIDAnimal({
    required this.rfidToken,
    required this.owner,
    required this.animalType,
    required this.gender,
    required this.weight,
    required this.age,
    required this.reportedAt,
  });

  factory RFIDAnimal.fromJson(Map<String, dynamic> json) {
    return RFIDAnimal(
      rfidToken: json['id_chip'],
      owner: json['pemilik'],
      animalType: json['jenis'],
      gender: json['gender'],
      weight: (json['weight'] as num).toDouble(),
      age: json['usia'],
      reportedAt: DateTime.parse(json['waktu_aduan']),
    );
  }

  @override
  String toString() {
    return 'RFIDAnimal(rfidToken: $rfidToken, owner: $owner, animalType: $animalType, gender: $gender, weight: $weight, age: $age, reportedAt: $reportedAt)';
  }

  String getAgeText() {
    return "$age Tahun";
  }
}