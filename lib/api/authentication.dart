import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

class AuthenticationException implements Exception {
  final String msg;
  const AuthenticationException(this.msg);
  @override
  String toString() => msg;
}

class Authentication {
  static final Authentication _instance = Authentication._constructor();
  static final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();
  factory Authentication() {
    return _instance;
  }

  Authentication._constructor();

  Future<void> login(String email, String password) async {
    try {
      Response response = await _dio.post(
        "${dotenv.env['API_HOST']}/auth/user",
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode != 200) {
        return Future.error(AuthenticationException("Error ${response.statusCode}. Coba lagi dalam beberapa saat"));
      }

      var data = response.data as Map<String, dynamic>;
      if (data['status'] == false || data['data'] == null) {
        return Future.error(const AuthenticationException("Login gagal, Periksa Username atau Password anda."));
      }

      await _storage.write(key: "BEARER_TOKEN", value: data['data']['token']);
    } catch (error) {
      throw const AuthenticationException("Terjadi kesalahan. Periksa Username atau Password anda dan coba lagi dalam beberapa saat");
    }
  }

  Future<void> register(String email, String password, String name, String idCardNumber, String phoneNumber, String address, int kecamatanId, int kelurahanId) async {
    try {
      Response response = await _dio.post(
        "${dotenv.env['API_HOST']}/auth/create/user",
        data: {
          'email': email,
          'password': password,
          'name': name,
          'id_card_number': idCardNumber,
          'phone_number': phoneNumber,
          'address': address,
          'district_id': kecamatanId,
          'neighborhood_id': kelurahanId,
        },
      );
      var data = response.data as Map<String, dynamic>;
      if (response.statusCode != 200 || data['status'] == 'false') {
        return Future.error(AuthenticationException("Error ${response.statusCode}. Cek data anda dan coba lagi dalam beberapa saat"));
      }
    } catch (error) {
      throw const AuthenticationException("Terjadi kesalahan. Cek data anda dan coba lagi dalam beberapa saat");
    }
  }
  
  Future<void> logout() async {
    
    if (await isLoggedIn()) {
      try {
        await _storage.delete(key: 'BEARER_TOKEN');
      } catch (error) {
        print(error.toString());
        return Future.error(const AuthenticationException("Terjadi kesalahan saat logout. Coba lagi dalam beberapa saat"));
      }
      try {
        var response = await _dio.post(
          "${dotenv.env['API_HOST']}/auth/user/revoke",
          options: Options(
            headers: {
              'Authorization': 'Bearer ${await _storage.read(key: "BEARER_TOKEN")}',
            },
          ),
        );
        var data = response.data as Map<String, dynamic>;
        if (response.statusCode != 200 || data['status'] == 'false') {
          throw AuthenticationException("Error ${response.statusCode}. Cek data anda dan coba lagi dalam beberapa saat");
        }
      } catch (error) {
        print('Api Failure');
        print(error.toString());
      }
    } else {
      throw const AuthenticationException('Not Logged in');
    }
  }

  Future<String> getToken() async {
    if (await _storage.containsKey(key: "BEARER_TOKEN")) {
      String? bearerToken = await _storage.read(key: "BEARER_TOKEN");
      if (bearerToken == null) throw const AuthenticationException('Not Logged in');
      return bearerToken;
    } else {
      throw const AuthenticationException('Not Logged in');
    }
  }

  Future<bool> isLoggedIn() async {
    if (await _storage.containsKey(key: "BEARER_TOKEN")) {
      String? bearerToken = await _storage.read(key: "BEARER_TOKEN");
      if (bearerToken == null) return false;
      return true;
    } else {
      return false;
    }
  }

}