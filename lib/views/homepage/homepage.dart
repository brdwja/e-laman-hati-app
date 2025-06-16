// ignore_for_file: prefer_const_constructors

import 'package:elaman_hati/api/animalstatistics.dart';
import 'package:elaman_hati/api/authentication.dart';
import 'package:elaman_hati/api/doctors_api.dart';
import 'package:elaman_hati/models/doctor.dart';
import 'package:elaman_hati/models/pagination.dart';
import 'package:elaman_hati/models/statisticsdata.dart';
import 'package:elaman_hati/models/user.dart';
import 'package:flutter/material.dart';

import '../../widgets/nav_drawer.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<User>? _futureUser;
  User? _user;
  Future<AnimalStatisticsModel>? _futureStatistics;

  Future<void> loadUser() async {
    debugPrint('loadUser DIPANGGIL');
    try {
      final user = await Authentication().getCurrentUser();
      debugPrint('HASIL getCurrentUser: $user');
      setState(() {
        _user = user;
      });
    } catch (e) {
      debugPrint('ERROR loadUser: $e');
    }
  }

  Future<void> loadAnimalStatistics() async {
    var future = AnimalStatisticsAPI().get();
    setState(() {
      _futureStatistics = future;
    });
    try {
      await future;
    } catch (error) {
      //
    }
  }

  Future<void> _refresh() async {
    await loadUser();
    await loadAnimalStatistics();
  }

  @override
  void initState() {
    super.initState();
    Authentication().addLoginListeners(_refresh);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    // Tambahkan debug print di sini
    debugPrint('ROLE USER: ${_user?.role}');

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xffff6392)),
        backgroundColor: Colors.white,
        title: const Text('Utama'),
        titleTextStyle: const TextStyle(
            color: Color(0xff525f7f),
            fontSize: 16,
            fontWeight: FontWeight.w600),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          children: [
            WelcomeCard(
              user: _user,
            ),
            _user != null &&
                    (_user!.kecamatan != null && _user!.kecamatan != null)
                ? const SizedBox(
                    height: 20,
                  )
                : const SizedBox(),
            (_user?.role != "admin")
                ? SizedBox.shrink()
                : AnimalStatistics(
                    statistics: _futureStatistics,
                  ),
          ],
        ),
      ),
      endDrawer: NavDrawer(role: _user?.role),
    );
  }
}

class AnimalStatistics extends StatelessWidget {
  const AnimalStatistics({
    super.key,
    required this.statistics,
  });

  final Future<AnimalStatisticsModel>? statistics;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: statistics,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          debugPrint('FutureBuilder received Data!');
          debugPrint(snapshot.data.toString());
          final data = snapshot.data!;
          return Column(
            children: [
              Card.filled(
                clipBehavior: Clip.hardEdge,
                color: Colors.white,
                elevation: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Total Peliharaan Tercatat",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff32325d))),
                          RichText(
                            text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 16, color: Color(0xff32325d)),
                                children: [
                                  const TextSpan(text: "Steril: "),
                                  TextSpan(
                                      text: "${data.petOwnershipSterile}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: "/${data.petOwnershipTotal}"),
                                ]),
                          ),
                          RichText(
                            text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 16, color: Color(0xff32325d)),
                                children: [
                                  const TextSpan(text: "Vaksin: "),
                                  TextSpan(
                                      text: "${data.petOwnershipVaccine}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: "/${data.petOwnershipTotal}"),
                                ]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: const Color(0xffb3b1b2),
                      width: 100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 32),
                        child: Column(
                          children: [
                            Text("${data.petOwnershipTotal}",
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            const Text('Ekor',
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              StatisticsCard(
                title: "Total Hewan Tercatat",
                vaksin: snapshot.data!.vaccineAnimal,
                total: snapshot.data!.animal,
              ),
            ],
          );
        }
        return const SizedBox(
            height: 320, child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class StatisticsCard extends StatelessWidget {
  const StatisticsCard({
    super.key,
    required this.title,
    // required this.steril,
    required this.vaksin,
    required this.total,
  });

  final String title;
  // final int steril;
  final int vaksin;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      clipBehavior: Clip.hardEdge,
      color: Colors.white,
      elevation: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff32325d))),
                // RichText(
                //   text: TextSpan(
                //     style: TextStyle(fontSize: 16, color: Color(0xff32325d)),
                //     children: [
                //       TextSpan(text: "Steril: "),
                //       TextSpan(text: "$steril", style: TextStyle(fontWeight: FontWeight.bold)),
                //       TextSpan(text: "/$total"),
                //     ]
                //   ),
                // ),
                RichText(
                  text: TextSpan(
                      style: const TextStyle(
                          fontSize: 16, color: Color(0xff32325d)),
                      children: [
                        const TextSpan(text: "Vaksin: "),
                        TextSpan(
                            text: "$vaksin",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: "/$total"),
                      ]),
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xffb3b1b2),
            width: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(
                children: [
                  Text("$total",
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const Text('Ekor', style: TextStyle(color: Colors.white))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key, required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card.filled(
          clipBehavior: Clip.hardEdge,
          color: Colors.white,
          elevation: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(color: Color(0xfff063c8)),
                child: SizedBox(
                  height: 160,
                  child: Stack(
                    children: [
                      Positioned(
                        top: -280,
                        right: -150,
                        child: Container(
                          width: 400,
                          height: 400,
                          decoration: const BoxDecoration(
                            color: Color(0xfff172cd),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Image.asset(
                          'assets/images/dkpp-putih.png',
                          height: 40,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Selamat\nDatang,",
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w600,
                                  height: 1,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Wargi Bandung!",
                              style: TextStyle(
                                  fontSize: 32, height: 1, color: Colors.white),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              user != null &&
                      (user!.kecamatan != null && user!.kelurahan != null)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Rumah Anda',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff32325d))),
                          Text(
                              "${user!.kecamatan!.name}, ${user!.kelurahan!.name}",
                              style: const TextStyle(
                                  fontSize: 16, color: Color(0xff32325d))),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        user != null && (user!.kecamatan != null && user!.kelurahan != null)
            ? Positioned(
                bottom: -20,
                left: 20,
                child: ElevatedButton(
                  onPressed: () => showModalBottomSheet<void>(
                    isScrollControlled: false,
                    context: context,
                    showDragHandle: true,
                    builder: (context) {
                      return DoctorsModalContents(
                        user: user!,
                      );
                    },
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 35),
                    backgroundColor: const Color(0xffff6392),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Dokter Sekitar'),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

class DoctorsModalContents extends StatefulWidget {
  const DoctorsModalContents({required this.user, super.key});
  final User user;

  @override
  State<DoctorsModalContents> createState() => _DoctorsModalContentsState();
}

class _DoctorsModalContentsState extends State<DoctorsModalContents> {
  Future<Paginated<List<Doctor>>>? _futureDoctors;
  List<Doctor> doctors = [];

  void loadDoctors(int page) async {
    debugPrint(widget.user.kecamatan!.id.toString());
    var future =
        DoctorsAPI().getPaginatedDoctors(page, widget.user.kecamatan!.id);
    setState(() {
      _futureDoctors = future;
    });
    try {
      var data = await future;
      setState(() {
        doctors.addAll(data.data);
      });
    } catch (error) {
      //
    }
  }

  void reloadDoctors() {
    setState(() {
      doctors.clear();
    });
    loadDoctors(1);
  }

  @override
  void initState() {
    super.initState();
    loadDoctors(1);
  }

  Widget buildItem(IconData icon, String name, String content) {
    return DefaultTextStyle.merge(
      style: const TextStyle(color: Color(0xff172b4d)),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Daftar Dokter Sekitar',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff172b4d)),
            ),
            Text(
                "${widget.user.kecamatan!.name}, ${widget.user.kelurahan!.name}"),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: FutureBuilder(
                future: _futureDoctors,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (doctors.isEmpty) {
                      return const Center(child: Text("Data tidak ditemukan"));
                    }
                    return ListView.builder(
                      itemCount: doctors.length + 1,
                      itemBuilder: (context, index) {
                        if (index < doctors.length) {
                          return buildItem(Icons.medical_services,
                              doctors[index].name, doctors[index].address);
                        } else {
                          if (snapshot.data!.currentPage <
                              snapshot.data!.lastPage) {
                            loadDoctors(snapshot.data!.currentPage + 1);
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            return const SizedBox();
                          }
                        }
                      },
                    );
                  } else if (snapshot.hasError) {
                    return TextButton(
                      onPressed: () => reloadDoctors(),
                      child: const Text(
                          'Terjadi Kesalahan, tekan untuk coba lagi.'),
                    );
                  }
                  return const SizedBox(
                    height: 240,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}
