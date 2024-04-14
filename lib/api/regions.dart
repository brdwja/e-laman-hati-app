import 'dart:io';

import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';

import '../models/addressarea.dart';

class Regions {
  static final Regions _instance = Regions._constructor();
  static final Dio _dio = Dio();
  factory Regions() {
    return _instance;
  }

  Regions._constructor() {
    _dio.interceptors.add(RetryInterceptor(
      dio: _dio,
      logPrint: debugPrint,
      retryableExtraStatuses: {status401Unauthorized},
      retryDelays: const [
        Duration(seconds:1)
      ]
    ));
  }
  Future<List<Kelurahan>> getActiveKelurahan() async {
    try {
      Response response = await _dio.get("${dotenv.env['API_HOST']}/neighborhood/active");
      if (response.statusCode != 200) throw Exception();
      var data = response.data as Map<String, dynamic>;
      if (data['status'] == false) throw Exception();

      var listKelurahan = (data['data'] as List<dynamic>).map((e) => Kelurahan(id: e['id'], name: e['name']),).toList();
      return listKelurahan;

    } catch (error) {
      throw const HttpException('Terjadi Kesalahan, Mohon coba lagi.');
    }
  }
  Future<List<Kelurahan>> getKelurahanByKecamatanId(int id) async {
    debugPrint("getKelurahanByKecamatanId");
    try {
      Response response = await _dio.get("${dotenv.env['API_HOST']}/neighborhood/indistrict?district_id=$id");
      if (response.statusCode != 200) throw Exception();
      var data = response.data as Map<String, dynamic>;
      if (data['status'] == false) throw Exception();

      var listKelurahan = (data['data'] as List<dynamic>).map((e) => Kelurahan(id: e['id'], name: e['name']),).toList();
      return listKelurahan;

    } catch (error) {
      throw const HttpException('Terjadi Kesalahan, Mohon coba lagi.');
    }
  }
  Future<List<Kecamatan>> getActiveKecamatan() async {
    debugPrint("getActiveKecamatan");
    try {
      Response response = await _dio.get("${dotenv.env['API_HOST']}/district/active", options: Options(validateStatus: (status) => true,));
      debugPrint("STATUS CODE: ${response.statusCode}");
      if (response.statusCode != 200) throw Exception();
      var data = response.data as Map<String, dynamic>;
      if (data['status'] == false) throw Exception();

      var listKecamatan = (data['data'] as List<dynamic>).map((e) => Kecamatan(id: e['id'], name: e['name']),).toList();
      return listKecamatan;

    } catch (error) {
      debugPrint("AccError: ${error.toString()}");
      throw const HttpException('Terjadi Kesalahan, Mohon coba lagi.');
    }
  }
} 


