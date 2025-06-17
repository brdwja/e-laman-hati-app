// ignore_for_file: unnecessary_brace_in_string_interps, curly_braces_in_flow_control_structures, avoid_print

import 'dart:io';

import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:elaman_hati/models/pet.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../api/authentication.dart';
import '../models/idvalue.dart';

class PetOwnership {
  static final PetOwnership _instance = PetOwnership._constructor();
  static final Dio _dio = Dio();
  factory PetOwnership() {
    return _instance;
  }

  PetOwnership._constructor() {
    _dio.interceptors.add(RetryInterceptor(
        dio: _dio,
        logPrint: debugPrint,
        retries: 3,
        retryableExtraStatuses: {status403Forbidden},
        retryDelays: const [Duration(seconds: 1)]));
  }

  Future<List<IDValue>> getGenders() async {
    try {
      String token = await Authentication().getToken();
      Response response = await _dio.get(
        "${dotenv.env['API_HOST']}/gender",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );
      if (response.statusCode != 200) throw Exception();
      var data = response.data as Map<String, dynamic>;
      if (data['status'] == false) throw Exception();

      var listKelurahan = (data['data'] as List<dynamic>)
          .map(
            (e) => IDValue(id: e['id'], name: e['name']),
          )
          .toList();
      return listKelurahan;
    } catch (error) {
      throw const HttpException('Terjadi Kesalahan, Mohon coba lagi.');
    }
  }

  Future<List<IDValue>> getSterileStatus() async {
    try {
      String token = await Authentication().getToken();
      Response response = await _dio.get(
        "${dotenv.env['API_HOST']}/sterile/active",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );
      if (response.statusCode != 200) throw Exception();
      var data = response.data as Map<String, dynamic>;
      if (data['status'] == false) throw Exception();

      var listKelurahan = (data['data'] as List<dynamic>)
          .map(
            (e) => IDValue(id: e['id'], name: e['name']),
          )
          .toList();
      return listKelurahan;
    } catch (error) {
      throw const HttpException('Terjadi Kesalahan, Mohon coba lagi.');
    }
  }

  Future<List<IDValue>> getPetTypes() async {
    try {
      String token = await Authentication().getToken();
      Response response = await _dio.get(
        "${dotenv.env['API_HOST']}/pet/type",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );
      debugPrint(response.statusCode.toString());
      if (response.statusCode != 200) throw Exception();
      var data = response.data as Map<String, dynamic>;
      debugPrint(response.data.toString());
      if (data['status'] == false) throw Exception();

      var listKelurahan = (data['data'] as List<dynamic>)
          .map(
            (e) => IDValue(id: e['id'], name: e['name']),
          )
          .toList();
      return listKelurahan;
    } catch (error) {
      throw const HttpException('Terjadi Kesalahan, Mohon coba lagi.');
    }
  }

  Future<void> create(
      XFile photo,
      int genderId,
      int petTypeId,
      DateTime? lastSterile,
      DateTime? lastVaccine,
      DateTime age,
      String name) async {
    try {
      String token = await Authentication().getToken();
      debugPrint(token);
      FormData formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(photo.path),
        'gender_id': genderId,
        'pet_type_id': petTypeId,
        'name': name,
        'last_sterile': lastSterile?.toIso8601String(),
        'last_vaccine': lastVaccine?.toIso8601String(),
        'age': age.toIso8601String(),
      });
      debugPrint("posting");
      Response response = await _dio.post(
        '${dotenv.env['API_HOST']}/petownership',
        data: formData,
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );
      debugPrint("posting done");
      var data = response.data as Map<String, dynamic>;
      if (response.statusCode != 200 || data['status'] == false)
        throw DioException(
            requestOptions: response.requestOptions, response: response);
    }
    // on DioException catch (error) {
    //   debugPrint(error.response?.data);
    //   return Future.error('DE Terjadi kesalahan, coba lagi dalam beberapa saat');
    // }
    catch (error) {
      return Future.error('Terjadi kesalahan, coba lagi dalam beberapa saat');
    }
  }

  Future<Map<int, String>> getAnimalsType() async {
    try {
      String token = await Authentication().getToken();
      Response response = await _dio.get(
        '${dotenv.env['API_HOST']}/type_of_animal',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      final List<dynamic> data = response.data;
      return {
        for (var item in data)
          item['id'] as int: item['type_of_animal'] as String,
      };
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<List<Pet>> getList() async {
    try {
      String token = await Authentication().getToken();
      Response response = await _dio.get(
        '${dotenv.env['API_HOST']}/animals/show',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );
      var data = response.data as Map<String, dynamic>;
      if (response.statusCode != 200 || data['status'] == false)
        throw DioException(
            requestOptions: response.requestOptions, response: response);
      var list =
          (data['data'] as List<dynamic>).map((e) => Pet.fromJson(e)).toList();
      return list;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<void> delete(int id) async {
    try {
      String token = await Authentication().getToken();
      Response response = await _dio.delete(
        '${dotenv.env['API_HOST']}/animals/$id',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );
      var data = response.data as Map<String, dynamic>;
      if (response.statusCode != 200 || data['status'] == false)
        throw DioException(
            requestOptions: response.requestOptions, response: response);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<void> deathEdit(int id) async {
    try {
      String token = await Authentication().getToken();
      Response response = await _dio.put(
        '${dotenv.env['API_HOST']}/animals/$id/mark-dead',
        // "http://127.0.0.1:8000/api/animals/$id",
        data: {
          'is_dead': true,
          'dead_date': DateTime.now().toIso8601String(),
        },
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
            'Content-Type': 'application/json',
          },
        ),
      );

      var data = response.data as Map<String, dynamic>;
      if (response.statusCode != 200 || data['status'] == false)
        throw DioException(
            requestOptions: response.requestOptions, response: response);
    } catch (error) {
      return Future.error('Terjadi kesalahan, coba lagi dalam beberapa saat');
    }
  }
}
