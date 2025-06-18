// ignore_for_file: unnecessary_brace_in_string_interps, curly_braces_in_flow_control_structures, avoid_print, non_constant_identifier_names

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

  Future<void> addAnimal(
    final String animal_name,
    final int type_of_animal_id,
    final String gender,
    final DateTime date_of_birth,
    final DateTime? sterile,
    final DateTime? vaccine,
    final XFile image,
    final double? weight,
  ) async {
    try {
      String token = await Authentication().getToken();
      debugPrint(token);

      MultipartFile imageFile = await MultipartFile.fromFile(
        image.path,
        filename: image.name,
      );

      FormData formData = FormData.fromMap({
        'animal_name': animal_name,
        'type_of_animal_id': type_of_animal_id,
        'gender': gender,
        'date_of_birth': date_of_birth,
        'sterile': sterile.toString().isNotEmpty ? sterile : null,
        'vaccine': vaccine.toString().isNotEmpty ? vaccine : null,
        'image': imageFile,
        'weight': weight.toString().isNotEmpty ? weight : null,
      });

      Response response = await _dio.post(
        '${dotenv.env['API_HOST']}/animals/addPet',
        data: formData,
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      var data = response.data as Map<String, dynamic>;
      if (response.statusCode != 201 || data['status'] != 'success') {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } catch (error) {
      if (error is DioException) {
        final errorMessage =
            error.response?.data['message'] ?? 'Terjadi kesalahan';
        return Future.error(errorMessage);
      }
      return Future.error('Terjadi kesalahan, coba lagi dalam beberapa saat');
    }
  }

  Future<Map<int, String>> getAnimalsType(String role) async {
    try {
      String token = await Authentication().getToken();
      String type = role == 'peternak' ? 'farm' : 'pets';

      Response response = await _dio.get(
        '${dotenv.env['API_HOST']}/type_of_animal/$type',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
          // Tambahkan ini biar Dio tidak auto-cast jadi List
          responseType: ResponseType.json,
        ),
      );

      final responseData = response.data;

      if (responseData is Map && responseData.containsKey('data')) {
        final List<dynamic> data = responseData['data'];

        final result = {
          for (var item in data)
            item['id'] as int: item['type_of_animal'] as String,
        };

        return result;
      } else {
        return {};
      }
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
        '${dotenv.env['API_HOST']}/animals/$id/delete',
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
