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

  Future<RFIDAnimal> fetchByChip(String chipId) async {
    try {
      final response = await _dio.get(
        '${dotenv.env['API_HOST']}/dina-ht/show-by-chip/$chipId',
      );

      print(chipId);
      final data = response.data as Map<String, dynamic>;

      if (response.statusCode != 200 || data['status'] == false) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      return RFIDAnimal.fromJson(data['data']);
    } on DioException catch (err) {
      return Future.error("ID Chip tidak ditemukan.");
    } catch (err) {
      return Future.error("Terjadi kesalahan.");
    }
  }
}
