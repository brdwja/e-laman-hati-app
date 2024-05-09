import 'dart:io';

import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:elaman_hati/api/authentication.dart';
import 'package:elaman_hati/models/statisticsdata.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';

class AnimalStatisticsAPI {
  static final AnimalStatisticsAPI _instance = AnimalStatisticsAPI._constructor();
  static final Dio _dio = Dio();
  factory AnimalStatisticsAPI() {
    return _instance;
  }

  AnimalStatisticsAPI._constructor() {
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

  Future<AnimalStatisticsModel> get() async {
    try {
      String token = await Authentication().getToken();
      Response response = await _dio.get("${dotenv.env['API_HOST']}/statistic/data",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );
      var data = response.data as Map<String, dynamic>;
      debugPrint(data.toString());
      if (response.statusCode != 200 || data['status'] == false) throw DioException(requestOptions: response.requestOptions, response: response);

      return AnimalStatisticsModel.fromJson(data['data']);

    } catch (error) {
      debugPrint(error.toString());
      throw const HttpException('Terjadi Kesalahan, Mohon coba lagi.');
    }
  }

}