import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import '../models/rfidanimal.dart';

class DinaHTService {
  static final DinaHTService _instance = DinaHTService._internal();
  static final Dio _dio = Dio();

  factory DinaHTService() {
    return _instance;
  }

  DinaHTService._internal() {
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logPrint: debugPrint,
        retries: 3,
        retryableExtraStatuses: {403},
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
    );
  }

Future<RFIDAnimal> get(String rfid) async {
  try {
    final response = await _dio.get(
      'http://127.0.0.1:8000/api/dina-ht/show-by-chip/$rfid',
    );

    if (response.statusCode != 200) {
      throw Exception("Id Chip Tidak Ditemukan");
    }

    return RFIDAnimal.fromJson(response.data);
  } catch (e) {
    throw Exception("Gagal mengambil data");
  }
}
}