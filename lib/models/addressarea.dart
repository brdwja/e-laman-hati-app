class Kelurahan {
  const Kelurahan({required this.id, required this.name});
  final int id;
  final String name;

  factory Kelurahan.fromJson(Map<String, dynamic> json) {
    return Kelurahan(
      id: int.parse(json['id'].toString()),
      name: json['name'],
    );
  }
}

class Kecamatan {
  const Kecamatan({required this.id, required this.name});
  final int id;
  final String name;

  factory Kecamatan.fromJson(Map<String, dynamic> json) {
    return Kecamatan(
      id: int.parse(json['id'].toString()),
      name: json['name'],
    );
  }
}
