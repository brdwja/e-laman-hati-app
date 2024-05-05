import 'dart:io';

import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../api/authentication.dart';
import '../models/animalreport.dart';

class ReportAnimal {
  static final ReportAnimal _instance = ReportAnimal._constructor();
  static final Dio _dio = Dio();
  factory ReportAnimal() {
    return _instance;
  }

  ReportAnimal._constructor() {
    _dio.interceptors.add(RetryInterceptor(
      dio: _dio,
      logPrint: debugPrint,
      retryableExtraStatuses: {status403Forbidden},
      retries: 3,
      retryDelays: const [
        Duration(seconds:1)
      ]
    ));
  }
  Future<void> create(String address, int kecamatanId, int kelurahanId, String gejala, XFile image, int animalTypeId) async {
    try {
      String token = await Authentication().getToken();
      debugPrint(token);
      FormData formData = FormData.fromMap({
        'address': address,
        'district_id': kecamatanId,
        'neighborhood_id': kelurahanId,
        'symptom': gejala,
        'photo': await MultipartFile.fromFile(image.path),
        'report_animal_type_id': animalTypeId,
      });
      Response response = await _dio.post(
        '${dotenv.env['API_HOST']}/report',
        data: formData,
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );
      var data = response.data as Map<String, dynamic>;
      if (response.statusCode != 200 || data['status'] == false) throw DioException(requestOptions: response.requestOptions, response: response);
    } 
    // on DioException catch (error) {
    //   debugPrint(error.response?.data);
    //   return Future.error('DE Terjadi kesalahan, coba lagi dalam beberapa saat');
    // } 
    catch (error) {
      return Future.error('Terjadi kesalahan, coba lagi dalam beberapa saat');
    }
  }

  Future<void> delete(int id) async {
    try {
      String token = await Authentication().getToken();
      Response response = await _dio.delete(
        '${dotenv.env['API_HOST']}/report?id=$id',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );
      var data = response.data as Map<String, dynamic>;
      if (response.statusCode != 200 || data['status'] == false) throw DioException(requestOptions: response.requestOptions, response: response);
    } catch (error) {
      return Future.error('Terjadi kesalahan, coba lagi dalam beberapa saat');
    }
  }

  Future<List<AnimalReport>> getList() async {
    try {
      String token = await Authentication().getToken();
      Response response = await _dio.get(
        '${dotenv.env['API_HOST']}/report/user',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );
      var data = response.data as Map<String, dynamic>;
      if (response.statusCode != 200 || data['status'] == false) throw DioException(requestOptions: response.requestOptions, response: response);
      var list = (data['data'] as List<dynamic>).map((e) => AnimalReport.fromJson(e)).toList();
      return list;
    } catch (error) {
      return Future.error('Terjadi kesalahan, coba lagi dalam beberapa saat');
    }
  }
}