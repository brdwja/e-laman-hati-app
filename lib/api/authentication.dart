import 'dart:io';

import 'package:elaman_hati/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';

class AuthenticationException implements Exception {
  final String msg;
  const AuthenticationException(this.msg);
  @override
  String toString() => msg;
}

class Authentication {
  static final Authentication _instance = Authentication._constructor();
  static final Dio _dio = Dio();
  final loginListeners = <Function>[];
  final _storage = const FlutterSecureStorage();
  factory Authentication() {
    return _instance;
  }

  Authentication._constructor();

  void addLoginListeners(Function listener) {
    loginListeners.add(listener);
  }

  void callLoginListeners() {
    for (var listener in loginListeners) {
      listener();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      Response response = await _dio.post(
        // "${dotenv.env['API_HOST']}/auth/user",
        "${dotenv.env['API_HOST']}/login",
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode != 200) {
        return Future.error(AuthenticationException(
            "Error ${response.statusCode}. Coba lagi dalam beberapa saat"));
      }

      var data = response.data as Map<String, dynamic>;
      if (data['status'] == false || data['data'] == null) {
        return Future.error(const AuthenticationException(
            "Login gagal, Periksa Username atau Password anda."));
      }

      await _storage.write(key: "BEARER_TOKEN", value: data['data']['token']);
      callLoginListeners();
    } catch (error) {
      throw const AuthenticationException(
          "Terjadi kesalahan. Periksa Username atau Password anda dan coba lagi dalam beberapa saat");
    }
  }

  Future<void> register(
      String email,
      String password,
      String name,
      String idCardNumber,
      String phoneNumber,
      String address,
      int kecamatanId,
      int kelurahanId,
      String role) async {
    try {
      Response response = await _dio.post(
        "${dotenv.env['API_HOST']}/register",
        data: {
          'email': email,
          'password': password,
          'name': name,
          'id_card_number': idCardNumber,
          'phone_number': phoneNumber,
          'address': address,
          'id_district': kecamatanId,
          'id_sub_district': kelurahanId,
          'role': role,
        },
      );
      var data = response.data as Map<String, dynamic>;
      if (data['status'] == false) {
        throw Exception();
      }
    } on DioException catch (error) {
      try {
        if (error.response == null) throw Exception();
        var data = error.response!.data as Map<String, dynamic>;
        if (error.response!.statusCode == 500 && data['status'] == false) {
          var errors = data['error'] as Map<String, dynamic>;
          // debugPrint(errors.toString());
          String errorString = errors.keys
              .map((String e) {
                Map<String, String> errorMap = {
                  "email": 'Email',
                  "id_card_number": 'No KTP',
                  "phone_number": 'No HP'
                };
                return errorMap[e];
              })
              .toList()
              .where((element) => element != null)
              .join(', ');
          List<String> exceptionsStrings = [];
          if (errorString.isNotEmpty) {
            exceptionsStrings.add("$errorString sudah terdaftar!");
          }
          if (errors.keys.contains('password')) {
            exceptionsStrings.add('Password minimal 8 karakter!');
          }
          String exceptionString = exceptionsStrings.join(" dan ");
          return Future.error(AuthenticationException(exceptionString));
        }
        throw Exception();
      } catch (err) {
        throw const AuthenticationException(
            "Terjadi kesalahan. Cek data anda dan coba lagi dalam beberapa saat");
      }
    } catch (error) {
      throw const AuthenticationException(
          "Terjadi kesalahan. Cek data anda dan coba lagi dalam beberapa saat");
    }
  }

  Future<void> logout() async {
    if (await isLoggedIn()) {
      try {
        await _storage.delete(key: 'BEARER_TOKEN');
      } catch (error) {
        return Future.error(const AuthenticationException(
            "Terjadi kesalahan saat logout. Coba lagi dalam beberapa saat"));
      }
      try {
        var response = await _dio.post(
          "${dotenv.env['API_HOST']}/auth/user/revoke",
          options: Options(
            headers: {
              'Authorization':
                  'Bearer ${await _storage.read(key: "BEARER_TOKEN")}',
            },
          ),
        );
        var data = response.data as Map<String, dynamic>;
        if (response.statusCode != 200 || data['status'] == 'false') {
          throw AuthenticationException(
              "Error ${response.statusCode}. Cek data anda dan coba lagi dalam beberapa saat");
        }
      } catch (error) {
        debugPrint('Api Failure');
        debugPrint(error.toString());
      }
    } else {
      throw const AuthenticationException('Not Logged in');
    }
  }

  Future<String> getToken() async {
    try {
      if (await _storage.containsKey(key: "BEARER_TOKEN")) {
        String? bearerToken = await _storage.read(key: "BEARER_TOKEN");
        if (bearerToken == null)
          throw const AuthenticationException('Not Logged in');
        return bearerToken;
      } else {
        throw const AuthenticationException('Not Logged in');
      }
    } catch (error) {
      throw const AuthenticationException('Not Logged in');
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      if (await _storage.containsKey(key: "BEARER_TOKEN")) {
        String? bearerToken = await _storage.read(key: "BEARER_TOKEN");
        if (bearerToken == null) return false;
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<User> getCurrentUser() async {
    if (await isLoggedIn()) {
      try {
        final token = await getToken();
        var response = await _dio.get(
          "${dotenv.env['API_HOST']}/me",
          options: Options(
            headers: {
              HttpHeaders.authorizationHeader: "Bearer $token",
            },
          ),
        );
        debugPrint('STATUS CODE: ${response.statusCode}');
        debugPrint('RESPONSE DATA: ${response.data}');
        var data = response.data as Map<String, dynamic>;

        debugPrint("API user data: ${data['data']}");
        if (response.statusCode != 200 || data['status'] == false) {
          throw DioException(
              requestOptions: response.requestOptions, response: response);
        }
        return User.fromJson(data['data']);
      } catch (error) {
        debugPrint('ERROR getCurrentUser: $error');
        throw Exception("Terjadi kesalahan. Coba lagi dalam beberapa saat");
      }
    } else {
      throw const AuthenticationException('Not Logged in');
    }
  }
}
