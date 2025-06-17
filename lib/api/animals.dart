import 'dart:io';

import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';

import '../models/animaltype.dart';
import '../api/authentication.dart';

class Animals {
  static final Animals _instance = Animals._constructor();
  static final Dio _dio = Dio();
  factory Animals() {
    return _instance;
  }

  Animals._constructor() {
    _dio.interceptors.add(RetryInterceptor(
        dio: _dio,
        logPrint: debugPrint,
        retryableExtraStatuses: {status403Forbidden},
        retryDelays: const [Duration(seconds: 1)]));
  }

  Future<List<AnimalType>> getActiveAnimal() async {
    try {
      String token = await Authentication().getToken();
      Response response = await _dio.get(
        "${dotenv.env['API_HOST']}/report/animal/type",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );
      if (response.statusCode != 200) throw Exception();
      var data = response.data as Map<String, dynamic>;
      if (data['status'] == false) throw Exception();

      var listAnimal = (data['data'] as List<dynamic>)
          .map((e) => AnimalType(id: e['id'], name: e['name']))
          .toList();
      return listAnimal;
    } catch (error) {
      debugPrint("AccError: ${error.toString()}");
      throw const HttpException('Terjadi Kesalahan, Mohon coba lagi.');
    }
  }
}
