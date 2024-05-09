class AnimalStatisticsModel {
  final int animal;
  final int pet;
  final int doctor;
  final int vaccineAnimal;
  final int vaccinePet;
  final int wildAnimal;
  final int petOwnershipSterile;
  final int petOwnershipVaccine;
  final int petOwnershipTotal;

  AnimalStatisticsModel({
    required this.animal,
    required this.pet,
    required this.doctor,
    required this.vaccineAnimal,
    required this.vaccinePet,
    required this.wildAnimal,
    required this.petOwnershipSterile,
    required this.petOwnershipVaccine,
    required this.petOwnershipTotal,
  });

  factory AnimalStatisticsModel.fromJson(Map<String, dynamic> json) {
    return AnimalStatisticsModel(
      animal: json['animal'],
      pet: json['pet'],
      doctor: json['doctor'],
      vaccineAnimal: json['vaccine_animal'],
      vaccinePet: json['vaccine_pet'],
      wildAnimal: json['wild_animal'],
      petOwnershipSterile: json['pet_ownership_sterile'],
      petOwnershipVaccine: json['pet_ownership_vaccine'],
      petOwnershipTotal: json['pet_ownership_total'],
    );
    }
}