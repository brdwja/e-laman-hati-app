// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names

import 'package:elaman_hati/api/petownership.dart';
import 'package:elaman_hati/widgets/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AnimalListCard extends StatelessWidget {
  final int id;
  final String type_of_animal;
  final String animal_name;
  final VoidCallback onRefresh;
  final String age;
  final String imagePath;
  const AnimalListCard({
    super.key,
    required this.id,
    required this.type_of_animal,
    required this.animal_name,
    required this.onRefresh,
    required this.age,
    required this.imagePath,
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
            color: Colors.black.withValues(alpha: 0.1),
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
                child: imagePath.isEmpty
                    ? Image.asset(
                        "assets/images/random.png",
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        "${dotenv.env['MEDIA_HOST']}/storage/$imagePath",
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/cat1.png",
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type_of_animal,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.pets_rounded,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          animal_name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 8,
            right: 8,
            child: TextButton.icon(
              onPressed: () async {
                await deleteDialog(
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
              label: Text(
                "Hapus",
                style: TextStyle(color: Colors.red[700]),
              ),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size(0, 0),
                backgroundColor: Colors.red[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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
