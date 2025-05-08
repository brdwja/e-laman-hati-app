import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:elaman_hati/models/rfidanimal.dart';
import 'package:flutter/foundation.dart';

class DinaHateRFIDAnimalAPI {
  static final DinaHateRFIDAnimalAPI _instance = DinaHateRFIDAnimalAPI._constructor();
  static final Dio _dio = Dio();
  factory DinaHateRFIDAnimalAPI() {
    return _instance;
  }
  DinaHateRFIDAnimalAPI._constructor() {
    _dio.interceptors.add(RetryInterceptor(
      dio: _dio,
      logPrint: debugPrint,
      retries: 3,
      retryableExtraStatuses: {status403Forbidden},
      retryDelays: const [
        Duration(seconds:1)
      ]
    ));
  }

  Future<RFIDAnimal> get(String rfid) async {
    try {
      Response response = await _dio.get(
        '${dotenv.env['LAMANHATI_API']}/hewan/$rfid',
      );
      var data = response.data as Map<String, dynamic>;
      if (response.statusCode != 200 || data['status'] == false) throw DioException(requestOptions: response.requestOptions, response: response);
      return RFIDAnimal.fromJson(data['data']);
    } on DioException catch (err) {
      if (err.response != null && err.response!.statusCode == 404) {
      return Future.error("ID Chip Tidak Ditemukan!");
      }
      if (err.response != null && err.response!.data is Map<String, dynamic> && (err.response!.data as Map<String, dynamic>)['error'] != null) {
      return Future.error((err.response!.data as Map<String, dynamic>)['error']);
      }
      debugPrint(err.toString());
      return Future.error("Terjadi Kesalahan");
    } catch (err) {
      debugPrint(err.toString());
      return Future.error("Terjadi Kesalahan");
    }
  }

}