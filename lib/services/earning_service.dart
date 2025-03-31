import 'package:dio/dio.dart';
import 'package:ride_usuario/config/constants.dart';
import 'package:ride_usuario/models/result.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';



class EarningService {
  EarningService() : _dio = Dio();

  final Dio _dio;
  PreferenciasUsuario prefs = PreferenciasUsuario();

  Future<Result> sendEarning() async {
    try {
      final response = await _dio.post('${Constants.baseUrl}/earning',
          options: Options(
            headers: {
              'Authorization': 'Bearer ${prefs.accessToken}',
            },
          ));
      if (response.statusCode == 200) {
        return Result(data: response.data);
      } else {
        return Result(error: 'Error en la solicitud ${response.statusCode}');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud $e');
    }
  }

  Future<Result> getEarning() async {
    try {
      final response = await _dio.get('${Constants.baseUrl}/earning',
          options: Options(
            headers: {
              'Authorization': 'Bearer ${prefs.accessToken}',
            },
          ));
      if (response.statusCode == 200) {
        return Result(data: response.data);
      } else {
        return Result(error: 'Error en la solicitud ${response.statusCode}');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud $e');
    }
  }

  Future<Result> updateEaning(

  ) async {
    try {
      final response =
          await _dio.patch('${Constants.baseUrl}/earning',
              options: Options(
                headers: {
                  'Authorization': 'Bearer ${prefs.accessToken}',
                },
              ));
      if (response.statusCode == 200) {
        return Result(data: response.data);
      } else {
        return Result(error: 'Error en la solicitud ${response.statusCode}');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud $e');
    }
  }

  Future<Result> getEarningbyId(
    String idEarning,
  ) async {
    try {
      final response = await _dio.get('${Constants.baseUrl}/earning/$idEarning',
          options: Options(
            headers: {
              'Authorization': 'Bearer ${prefs.accessToken}',
            },
          ));
      if (response.statusCode == 200) {
        return Result(data: response.data);
      } else {
        return Result(error: 'Error en la solicitud ${response.statusCode}');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud $e');
    }
  }

  Future<Result> deleteEarningByPayment(
    String idEarning,
  ) async {
    try {
      final response =
          await _dio.delete('${Constants.baseUrl}/earning/$idEarning',
              options: Options(
                headers: {
                  'Authorization': 'Bearer ${prefs.accessToken}',
                },
              ));
      if (response.statusCode == 200) {
        return Result(data: response.data);
      } else {
        return Result(error: 'Error en la solicitud ${response.statusCode}');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud $e');
    }
  }
}
