// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:elaman_hati/api/petownership.dart';
import 'package:elaman_hati/models/pet.dart';
import 'package:elaman_hati/widgets/animal_list_card.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DaftarHewanPeliharaan extends StatefulWidget {
  const DaftarHewanPeliharaan({super.key});
  @override
  State<DaftarHewanPeliharaan> createState() => _DaftarHewanPeliharaanState();
}

class _DaftarHewanPeliharaanState extends State<DaftarHewanPeliharaan> {
  Future<List<Pet>>? _listFuture;

  Future<void> _loadDaftar() async {
    var report = PetOwnership().getList();

    setState(() {
      _listFuture = report;
    });
    try {
      await report;
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
                  child: FutureBuilder<List<Pet>>(
                    future: _listFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          return const Center(child: Text('Daftar Kosong'));
                        }
                        return RefreshIndicator(
                          onRefresh: () async {
                            await _loadDaftar();
                          },
                          child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 96),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () => showModalBottomSheet<void>(
                                        isScrollControlled: true,
                                        context: context,
                                        showDragHandle: true,
                                        builder: (context) {
                                          return DaftarModalContents(
                                            daftarItem: snapshot.data![index],
                                          );
                                        },
                                      ),
                                      child: AnimalListCard(
                                        type_of_animal_id: snapshot
                                            .data![index].type_of_animal_id,
                                        animal_name:
                                            snapshot.data![index].animal_name,
                                        onRefresh: _loadDaftar,
                                        id: snapshot.data![index].id,
                                        age: snapshot.data![index].getAge(),
                                      ),
                                    ),
                                  )),
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
  const DaftarModalContents({required this.daftarItem, super.key});
  final Pet daftarItem;

  Widget buildItem(IconData icon, String name, String content) {
    return DefaultTextStyle.merge(
      style: const TextStyle(color: Color(0xff172b4d)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 32,
            color: const Color(0xff172b4d),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name),
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
                  child: Image.network(
                    "${dotenv.env['STORAGE_HOST']}/${daftarItem.image}",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(
                      height: 200,
                      child: Center(child: Icon(Icons.error)),
                    ),
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
              buildItem(Icons.pets, 'Jenis', "jenis dummy"),
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
                      ? "Belum Vaksin"
                      : DateFormat('dd-MM-yyyy')
                          .format(daftarItem.lastSterile!)),
              const SizedBox(
                height: 8,
              ),
              buildItem(Icons.cake, 'Usia', daftarItem.getAge()),
              const SizedBox(
                height: 8,
              ),
              // buildItem(Icons.wc, 'Sex', daftarItem.gender.name),
              // const SizedBox(
              //   height: 32,
              // ),
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
