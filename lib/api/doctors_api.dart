import 'dart:io';

import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:elaman_hati/api/authentication.dart';
import 'package:elaman_hati/models/doctor.dart';
import 'package:elaman_hati/models/pagination.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';

class DoctorsAPI {
  static final DoctorsAPI _instance = DoctorsAPI._constructor();
  static final Dio _dio = Dio();
  factory DoctorsAPI() {
    return _instance;
  }

  DoctorsAPI._constructor() {
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


  Future<Paginated<List<Doctor>>> getPaginatedDoctors(int page, int? kecamatanId) async {
    try {
      final apiPath = kecamatanId != null ? "/doctor/district/paginate?district_id=$kecamatanId&page=$page" : "/doctor/paginate?page=$page";
      debugPrint(apiPath);
      String token = await Authentication().getToken();
      Response response = await _dio.get("${dotenv.env['API_HOST']}$apiPath",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );
      var data = response.data as Map<String, dynamic>;
      if (response.statusCode != 200 || data['status'] == false) throw DioException(requestOptions: response.requestOptions, response: response);
      var paginationData = data['data'] as Map<String, dynamic>;
      var listData = (paginationData['data'] as List<dynamic>).map((e) => Doctor.fromJson(e)).toList();
      return Paginated.fromJson(paginationData, listData);
    } catch (error) {
      debugPrint(error.toString());
      throw const HttpException('Terjadi Kesalahan, Mohon coba lagi.');
    }
  }
}