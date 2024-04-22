import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
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

  void _loadReports() {
    setState(() {
      _futureReport = ReportAnimal().getList();
    });
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
                      debugPrint(snapshot.data?[0].toString());
                      return ListView.separated(
                          padding: const EdgeInsets.only(bottom: 96),
                          itemCount: snapshot.data!.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RiwayatView(
                                            report: snapshot.data![index]),
                                      )),
                                  child: Stack(
                                    children: [
                                        Card.outlined(
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
                                                          child:
                                                              Icon(Icons.error))),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    Text(
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(snapshot
                                                              .data![index]
                                                              .timestamp),
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
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
                                                try {
                                                  await ReportAnimal().delete(snapshot.data![index].id);
                                                  _loadReports();
                                                } catch (error) {
                                                  if (!context.mounted) return;
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                                                }
                                              },
                                              icon: const Icon(Icons.delete),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ));
                    } else if (snapshot.hasError) {
                      return TextButton(
                          onPressed: () => _loadReports(),
                          child: const Text('Terjadi Kesalahan, tekan untuk coba lagi.'));
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(onPressed: () => launchUrlString("https://wa.me/66621649270?text=Halo%20DKPP%2C%20saya%20masyarakat%20bandung%20ingin%20meminta%20bantuan%20berikut.%0ANama%3A%0AAlamat%3A"), child: const Icon(Icons.chat),),
              )
      ],
    );
  }
}

class RiwayatView extends StatelessWidget {
  const RiwayatView({required this.report, super.key});
  final AnimalReport report;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.network(
                "${dotenv.env['STORAGE_HOST']}/${report.photo}",
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                    height: 200, child: Center(child: Icon(Icons.error))),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.pin_drop),
                        Flexible(child: Text("${report.kelurahan.name}, ${report.kecamatan.name}"))
                      ],
                    ),
                    Text(
                      report.jenisHewan.name,
                      style: const TextStyle(fontSize: 32),
                    ),
                    Text(
                      DateFormat('dd-MM-yyyy').format(report.timestamp),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Alamat:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(report.address),
                    SizedBox(height: 8,),
                    const Text(
                      'Gejala:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(report.symptom),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
