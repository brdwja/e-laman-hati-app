// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names

import 'package:elaman_hati/api/petownership.dart';
import 'package:elaman_hati/widgets/delete_dialog.dart';
import 'package:flutter/material.dart';

class AnimalListCard extends StatelessWidget {
  final int id;
  final int type_of_animal_id;
  final String animal_name;
  final VoidCallback onRefresh;
  final String age;
  const AnimalListCard({
    super.key,
    required this.id,
    required this.type_of_animal_id,
    required this.animal_name,
    required this.onRefresh,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/images/random.png",
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type_of_animal_id.toString(),
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      animal_name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 8,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                deleteDialog(
                  onMisData: () async {
                    await PetOwnership().delete(id);
                    onRefresh();
                  },
                  onDead: () async {
                    await PetOwnership().deathEdit(id);
                    onRefresh();
                  },
                  context: context,
                );
              },
            ),
          ),
          Positioned(
            bottom: 8,
            right: 12,
            child: Text(
              age,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
