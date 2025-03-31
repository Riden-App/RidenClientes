import 'package:dio/dio.dart';

import '../models/models.dart';

class LoginService {
  LoginService() : _dio = Dio();

  final Dio _dio;

  final url = 'http://34.172.134.50/api/1.0';

  Future<Response> verifyUser(String token) async {
    try {
      final response = await _dio.get('$url/auth/user',
          queryParameters: {
            'tokenProvider': 'firebase',
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ));

      return response;
    } catch (e) {
      return Response(
        requestOptions: RequestOptions(),
        statusCode: 500,
        data: {'error': 'Error al verificar el token'},
      );
    }
  }

  Future<Response> verifyUserFirebase(String token) async {
    const apiKey = 'AIzaSyCSx4ag3Cn04U1pTOmDIjv4qgzXZ8Y6HMI';
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=$apiKey';

    try {
      final response = await Dio().post(
        url,
        data: {
          'idToken': token,
        },
      );
      return response;
    } catch (e) {
      print('Error en la solicitud: $e');
      return Response(
        requestOptions: RequestOptions(),
        statusCode: 500,
        data: {'error': 'Error al verificar el token'},
      );
    }
  }

  Future<Response> authLogin(UserData userData) async {
    try {
      final response = await _dio.post(
        '$url/auth/login',
        data: userData.toJson(),
      );
      return response;
    } catch (e) {
      print('Error en la solicitud Login: $e');
      return Response(
        requestOptions: RequestOptions(),
        statusCode: 401,
        data: {'error': 'Error al verificar el token'},
      );
    }
  }

  Future<List<dynamic>> refreshToken() async {
    try {
      final response = await _dio.post('$url/auth/refresh-token');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al cargar los datos');
      }
    } catch (e) {
      throw Exception('Error en la solicitud: $e');
    }
  }

  Future<Response> logout(String token) async {
    try {
      final response = await _dio.post('$url/auth/logout',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ));
      if (response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Error al cargar los datos');
      }
    } catch (e) {
      throw Exception('Error en la solicitud: $e');
    }
  }

  Future<Response> verifyRegisterUser(String token) async {
    try {
      final response = await _dio.get('$url/driver/me',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ));

      return response;
    } catch (e) {
      return Response(
        requestOptions: RequestOptions(),
        statusCode: 500,
        data: {'error': 'Error al verificar el token'},
      );
    }
  }
}
