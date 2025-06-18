import 'dart:io';

import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/news.dart';
import '../api/authentication.dart';

class NewsApi {
  static final NewsApi _instance = NewsApi._constructor();
  static final Dio _dio = Dio();

  factory NewsApi() {
    return _instance;
  }

  NewsApi._constructor() {
    _dio.interceptors.add(RetryInterceptor(
      dio: _dio,
      logPrint: debugPrint,
      retryableExtraStatuses: {HttpStatus.forbidden},
      retryDelays: const [
        Duration(seconds: 1),
      ],
    ));
  }

  Future<List<News>> getNews() async {
    try {
      Response response = await _dio.get(
        "${dotenv.env['API_HOST']}/news",
      );
      if (response.statusCode != 200) {
        throw Exception("HTTP ${response.statusCode}");
      }
      if (response.data is! List) {
        throw Exception(
            "Unexpected response format: Expected List, got ${response.data.runtimeType}");
      }

      var data = (response.data as List).cast<Map<String, dynamic>>();
      var listNews = data.map((e) {
        try {
          return News(
            id: e['id'] as int,
            title: e['title'] as String,
            content: e['content'] as String,
            thumbnail: e['thumbnail'] as String,
            createdAt: DateTime.parse(e['created_at'] as String),
          );
        } catch (e) {
          debugPrint("Parsing error for news item: $e");
          rethrow;
        }
      }).toList();
      return listNews;
    } catch (error, stackTrace) {
      debugPrint("NewsError: $error");
      debugPrint("StackTrace: $stackTrace");
      throw const HttpException('Terjadi Kesalahan, Mohon coba lagi.');
    }
  }

  Future<News> getNewsById(int id) async {
    try {
      String token = await Authentication().getToken();
      Response response = await _dio.get(
        "${dotenv.env['API_HOST']}/news/$id",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          throw Exception('Berita dengan ID $id tidak ditemukan');
        }
        throw Exception('Gagal memuat berita: HTTP ${response.statusCode}');
      }

      var data = response.data as Map<String, dynamic>;
      if (!data.containsKey('id') ||
          !data.containsKey('title') ||
          !data.containsKey('content') ||
          !data.containsKey('thumbnail') ||
          !data.containsKey('created_at')) {
        throw Exception('Struktur respons server tidak valid');
      }

      return News(
        id: data['id'] as int,
        title: data['title'] as String,
        content: data['content'] as String,
        thumbnail: data['thumbnail'] as String,
        createdAt: DateTime.parse(data['created_at'] as String),
      );
    } catch (error, stackTrace) {
      debugPrint("NewsByIdError: $error");
      debugPrint("StackTrace: $stackTrace");
      throw Exception('Terjadi kesalahan saat memuat berita: $error');
    }
  }
}
