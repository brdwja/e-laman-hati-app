import 'package:elaman_hati/api/animalstatistics.dart';
import 'package:elaman_hati/api/authentication.dart';
import 'package:elaman_hati/api/news.dart';
import 'package:elaman_hati/models/news.dart';
import 'package:elaman_hati/models/statisticsdata.dart';
import 'package:elaman_hati/models/user.dart';
import 'package:flutter/foundation.dart';
import '../news/news_detail.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

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
  Future<List<News>>? _futureNews;

  Future<void> loadUser() async {
    try {
      final user = await Authentication().getCurrentUser();
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

  Future<void> loadNews() async {
    var future = NewsApi().getNews();
    setState(() {
      _futureNews = future;
    });
    try {
      await future;
    } catch (error) {
      _showSnackBar(
        'Terjadi kesalahan saat memuat berita: $error. Mohon coba lagi.',
      );
    }
  }

  Future<void> _refresh() async {
    await loadUser();
    await loadAnimalStatistics();
    await loadNews();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Authentication().addLoginListeners(_refresh);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final String? role = GetStorage().read('USER_ROLE');
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
            WelcomeCard(user: _user),
            _user != null &&
                    (_user!.kecamatan != null && _user!.kecamatan != null)
                ? const SizedBox(height: 20)
                : const SizedBox(),
            (role != "admin")
                ? SizedBox.shrink()
                : AnimalStatistics(statistics: _futureStatistics),
            const SizedBox(height: 20),
            const Text(
              'BERITA',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _futureNews == null
                ? const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : FutureBuilder<List<News>>(
                    future: _futureNews,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final news = snapshot.data![index];
                            String truncatedContent = news.content.length > 90
                                ? '${news.content.substring(0, 90)}...'
                                : news.content;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NewsDetailPage(newsId: news.id),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Image.network(
                                        news.thumbnail,
                                        width: 60,
                                        height: 60,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                          Icons.broken_image,
                                          size: 60,
                                          color: Colors.grey,
                                        ),
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return const CircularProgressIndicator();
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              news.title,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              truncatedContent,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                            Text(
                                              '${news.createdAt.day} ${getMonthName(news.createdAt.month)} ${news.createdAt.year}',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return SizedBox(
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Gagal memuat berita'),
                                Text(
                                  'Error: ${snapshot.error}',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                                ElevatedButton(
                                  onPressed: _refresh,
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox(
                          height: 200,
                          child: Center(child: Text('Tidak ada berita')),
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
      endDrawer: NavDrawer(),
    );
  }

  String getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return months[month - 1];
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
      ],
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
            ],
          );
        }
        return const SizedBox(
            height: 320, child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
