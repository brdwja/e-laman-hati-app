// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:elaman_hati/api/authentication.dart';
import 'package:elaman_hati/api/petownership.dart';
import 'package:elaman_hati/models/pet.dart';
import 'package:elaman_hati/widgets/animal_list_card.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../../models/user.dart';

class DaftarHewanPeliharaan extends StatefulWidget {
  const DaftarHewanPeliharaan({super.key});
  @override
  State<DaftarHewanPeliharaan> createState() => _DaftarHewanPeliharaanState();
}

class _DaftarHewanPeliharaanState extends State<DaftarHewanPeliharaan> {
  Future<List<dynamic>>? _listFuture;
  User? _user;

  Future<void> _loadDaftar() async {
    var petFuture = PetOwnership().getList();
    var user = await Authentication().getCurrentUser();
    final String? role = GetStorage().read('USER_ROLE');
    var typeFuture = PetOwnership().getAnimalsType(role!);

    setState(() {
      _listFuture = Future.wait([petFuture, typeFuture]);
      _user = user;
    });

    try {
      await _listFuture;
    } catch (error) {
      //
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDaftar();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Stack(
        children: [
          _listFuture == null
              ? const SizedBox(
                  height: 0,
                )
              : Center(
                  child: FutureBuilder<List<dynamic>>(
                    future: _listFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data!;
                        if (data.isEmpty || data.length < 2) {
                          return const Center(child: Text('Daftar Kosong'));
                        }
                        final List<Pet> pets = data[0] as List<Pet>;
                        final Map<int, String> types =
                            data[1] as Map<int, String>;
                        final String? role = _user?.role!.toLowerCase();
                        if (pets.isEmpty) {
                          return Center(
                            child: Text(
                              role == 'peternak'
                                  ? 'Belum ada hewan ternak yang terdaftar.'
                                  : 'Belum ada hewan peliharaan yang terdaftar.',
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () async {
                            await _loadDaftar();
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 96),
                            itemCount: pets.length,
                            itemBuilder: (context, index) {
                              final pet = pets[index];
                              final typeName =
                                  types[pet.type_of_animal_id] ?? 'Unknown';

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () => showModalBottomSheet<void>(
                                    isScrollControlled: true,
                                    context: context,
                                    showDragHandle: true,
                                    builder: (context) {
                                      return DaftarModalContents(
                                        daftarItem: pet,
                                        type: typeName,
                                      );
                                    },
                                  ),
                                  child: AnimalListCard(
                                    type_of_animal: typeName,
                                    animal_name: pet.animal_name,
                                    onRefresh: _loadDaftar,
                                    id: pet.id,
                                    age: pet.getAge(),
                                    imagePath: pet.image,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return TextButton(
                          onPressed: () => _loadDaftar(),
                          child: const Text(
                              'Terjadi Kesalahan, tekan untuk coba lagi.'),
                        );
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

class DaftarModalContents extends StatelessWidget {
  const DaftarModalContents(
      {required this.daftarItem, super.key, required this.type});
  final Pet daftarItem;
  final String type;

  Widget buildItem(IconData icon, String name, String content) {
    return DefaultTextStyle.merge(
      style: const TextStyle(color: Color(0xff172b4d)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: const Color(0xff172b4d),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    content,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.clip,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: daftarItem.image.isEmpty
                      ? Image.asset(
                          "assets/images/random.png",
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          '${dotenv.env['MEDIA_HOST']}/${daftarItem.image}',
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
              ),
              const SizedBox(
                height: 16,
              ),
              buildItem(Icons.star, 'Nama Peliharaan', daftarItem.animal_name),
              const SizedBox(
                height: 8,
              ),
              buildItem(Icons.pets, 'Jenis', type),
              const SizedBox(
                height: 8,
              ),
              buildItem(
                  Icons.vaccines,
                  'Vaksin Terakhir',
                  daftarItem.lastVaccine == null
                      ? "Belum Vaksin"
                      : DateFormat('dd-MM-yyyy')
                          .format(daftarItem.lastVaccine!)),
              const SizedBox(
                height: 8,
              ),
              buildItem(
                  Icons.health_and_safety,
                  'Steril',
                  daftarItem.lastSterile == null
                      ? "Belum Steril"
                      : DateFormat('dd-MM-yyyy')
                          .format(daftarItem.lastSterile!)),
              const SizedBox(
                height: 8,
              ),
              buildItem(Icons.cake, 'Usia', daftarItem.getAge()),
              const SizedBox(
                height: 8,
              ),
              buildItem(Icons.wc, 'Sex', daftarItem.gender),
              const SizedBox(
                height: 8,
              ),
              buildItem(Icons.line_weight, 'Berat',
                  '${daftarItem.weight.toString()} Kg'),
              const SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Positioned(
//   bottom: 20,
//   right: 20,
//   child: FloatingActionButton(
//     onPressed: () => launchUrlString("https://wa.me/66621649270?text=Halo%20DKPP%2C%20saya%20masyarakat%20bandung%20ingin%20meminta%20bantuan%20berikut.%0ANama%3A%0AAlamat%3A"),
//     child: const Icon(Icons.chat),
//   ),
// ),
