import 'dart:convert';
import 'package:elaman_hati/api/news.dart';
import 'package:elaman_hati/models/news.dart';
import 'package:flutter/material.dart';

class NewsDetailPage extends StatefulWidget {
  final int newsId;

  const NewsDetailPage({super.key, required this.newsId});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  Future<News>? _futureNews;

  @override
  void initState() {
    super.initState();
    _futureNews = NewsApi().getNewsById(widget.newsId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xffff6392)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Berita',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Color(0xff525f7f),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
      ),
      body: FutureBuilder<News>(
        future: _futureNews,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final news = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: _buildThumbnail(news.thumbnail, context),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      news.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      '${news.createdAt.day} ${getMonthName(news.createdAt.month)} ${news.createdAt.year}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        news.content,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Gagal memuat berita',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _futureNews = NewsApi().getNewsById(widget.newsId);
                      });
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildThumbnail(String thumbnail, BuildContext context) {
    if (thumbnail.startsWith('data:image')) {
      try {
        final base64String = thumbnail.split(',')[1];
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          width: MediaQuery.of(context).size.width,
          height: 240,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.broken_image,
            size: 120,
            color: Colors.grey,
          ),
        );
      } catch (e) {
        debugPrint('Error decoding base64 image: $e');
        return const Icon(
          Icons.broken_image,
          size: 120,
          color: Colors.grey,
        );
      }
    }
    return Image.network(
      thumbnail,
      width: MediaQuery.of(context).size.width,
      height: 120,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const Icon(
        Icons.broken_image,
        size: 120,
        color: Colors.grey,
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const CircularProgressIndicator();
      },
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
