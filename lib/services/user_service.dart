import 'package:dio/dio.dart';
import 'package:ride_usuario/config/constants.dart';
import 'package:ride_usuario/models/response/info_user_referred_response.dart';
import 'package:ride_usuario/models/response/info_user_response.dart';
import 'package:ride_usuario/models/result.dart';
import 'package:ride_usuario/models/response/update_profile_response.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';

class UserService {
  UserService() : _dio = Dio();

  final Dio _dio;
  PreferenciasUsuario prefs = PreferenciasUsuario();

  Future<Result<UpdateProfileResponse>> updateInfoUser({
    String? name,
    String? lastName,
    String? mobile,
    String? email,
    required String idUser,
  }) async {
    try {
      final response = await _dio.patch('${Constants.baseUrl}/user/$idUser',
          data: {
            if (name != null) 'firstName': name,
            if (lastName != null) 'lastName': lastName,
            if (mobile != null) 'mobile': mobile,
            if (email != null) 'email': email,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer ${prefs.accessToken}',
            },
          ));

      if (response.statusCode == 200) {
        return Result(data: UpdateProfileResponse.fromJson(response.data));
      } else {
        return Result(error: 'Error en la solicitud ${response.statusCode}');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud: $e');
    }
  }

  Future<Response> sendCodeEmail({
    required String email,
  }) async {
    try {
      final response =
          await _dio.post('${Constants.baseUrl}/user/request-email-change',
              data: {
                'newEmail': email,
              },
              options: Options(
                headers: {
                  'Authorization': 'Bearer ${prefs.accessToken}',
                },
              ));

      if (response.statusCode == 201) {
        return response;
      } else {
        return Response(
          requestOptions: RequestOptions(),
          data: response.data,
          statusMessage: response.statusMessage,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return Response(
        requestOptions: RequestOptions(),
        data: e.toString(),
        statusMessage: e.toString(),
        statusCode: 500,
      );
    }
  }

  Future<Response> verifyEmailChange({
    required String email,
    required String code,
  }) async {
    try {
      final response =
          await _dio.post('${Constants.baseUrl}/user/verify-email-change',
              data: {
                'code': code,
                'newEmail': email,
              },
              options: Options(
                headers: {
                  'Authorization': 'Bearer ${prefs.accessToken}',
                },
              ));
      if (response.statusCode == 201) {
        return response;
      } else {
        return Response(
          requestOptions: RequestOptions(),
          data: response.data,
          statusMessage: response.statusMessage,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return Response(
        requestOptions: RequestOptions(),
        data: e.toString(),
        statusMessage: e.toString(),
        statusCode: 500,
      );
    }
  }

  Future<Result<InfoUserReponse>> getInfo(String idUser) async {
    try {
      final response = await _dio.get('${Constants.baseUrl}/user/$idUser',
          options: Options(
            headers: {
              'Authorization': 'Bearer ${prefs.accessToken}',
            },
          ));

      if (response.statusCode == 200) {
        return Result(data: InfoUserReponse.fromJson(response.data));
      } else {
        return Result(error: 'Error en la solicitud');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud $e');
    }
  }
}
