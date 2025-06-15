import 'package:elaman_hati/widgets/delete_dialog.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../models/animalreport.dart';
import '../../../api/report.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RiwayatBantuan extends StatefulWidget {
  const RiwayatBantuan({super.key});
  @override
  State<RiwayatBantuan> createState() => _RiwayatBantuanState();
}

class _RiwayatBantuanState extends State<RiwayatBantuan> {
  Future<List<AnimalReport>>? _futureReport;

  Future<void> _loadReports() async {
    var report = ReportAnimal().getList();
    setState(() {
      _futureReport = report;
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
    _loadReports();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _futureReport == null
            ? const SizedBox(
                height: 0,
              )
            : Center(
                child: FutureBuilder<List<AnimalReport>>(
                  future: _futureReport,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return const Center(child: Text('Riwayat Kosong'));
                      }
                      return RefreshIndicator(
                        onRefresh: () async {
                          await _loadReports();
                        },
                        child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 96),
                            itemCount: snapshot.data!.length,
                            // separatorBuilder: (context, index) => const Divider(),
                            itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () => showModalBottomSheet<void>(
                                      isScrollControlled: true,
                                      context: context,
                                      showDragHandle: true,
                                      builder: (context) {
                                        return RiwayatModalContents(
                                          report: snapshot.data![index],
                                        );
                                      },
                                    ),
                                    child: Stack(
                                      children: [
                                        Card.filled(
                                          color: Colors.white,
                                          elevation: 2,
                                          clipBehavior: Clip.hardEdge,
                                          child: Row(
                                            children: [
                                              Image.network(
                                                "${dotenv.env['STORAGE_HOST']}/${snapshot.data![index].photo}",
                                                width: 150,
                                                height: 180,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    const SizedBox(
                                                  width: 150,
                                                  height: 180,
                                                  child: Center(
                                                    child: Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                              Icons.pin_drop),
                                                          Expanded(
                                                            child: Text(
                                                              "${snapshot.data![index].kelurahan.name}, ${snapshot.data![index].kecamatan.name}",
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Text(
                                                        snapshot.data![index]
                                                            .jenisHewan.name,
                                                        style: const TextStyle(
                                                            fontSize: 32),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: IconButton(
                                            onPressed: () async {
                                              deleteDialog(
                                                onMisData: () async {
                                                  await ReportAnimal().delete(
                                                      snapshot.data![index].id);
                                                  _loadReports();
                                                },
                                                onDead: () {},
                                                context: context,
                                              );
                                              try {} catch (error) {
                                                if (!context.mounted) return;
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      error.toString(),
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            icon: const Icon(Icons.delete),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 12,
                                          right: 16,
                                          child: Text(
                                            DateFormat('dd-MM-yyyy').format(
                                                snapshot
                                                    .data![index].timestamp),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                      );
                    } else if (snapshot.hasError) {
                      return TextButton(
                        onPressed: () => _loadReports(),
                        child: const Text(
                            'Terjadi Kesalahan, tekan untuk coba lagi.'),
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () => launchUrlString(
                "https://wa.me/66621649270?text=Halo%20DKPP%2C%20saya%20masyarakat%20bandung%20ingin%20meminta%20bantuan%20berikut.%0ANama%3A%0AAlamat%3A"),
            child: const Icon(Icons.chat),
          ),
        ),
      ],
    );
  }
}

class RiwayatModalContents extends StatelessWidget {
  const RiwayatModalContents({required this.report, super.key});
  final AnimalReport report;

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
                    "${dotenv.env['STORAGE_HOST']}/${report.photo}",
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
              buildItem(Icons.pets, 'Jenis', report.jenisHewan.name),
              const SizedBox(
                height: 8,
              ),
              buildItem(Icons.sick, 'Gejala', report.symptom),
              const SizedBox(
                height: 8,
              ),
              buildItem(Icons.place, 'Lokasi',
                  "${report.kelurahan.name}, ${report.kecamatan.name}"),
              const SizedBox(
                height: 8,
              ),
              buildItem(Icons.home, 'Alamat Lengkap', report.address),
              const SizedBox(
                height: 8,
              ),
              buildItem(Icons.calendar_month, 'Waktu Aduan',
                  DateFormat('HH:mm dd-MM-yyyy').format(report.timestamp)),
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
