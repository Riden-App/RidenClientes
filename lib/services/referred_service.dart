import 'package:dio/dio.dart';
import 'package:ride_usuario/config/constants.dart';
import 'package:ride_usuario/models/response/all_referred_detail_response.dart';
import 'package:ride_usuario/models/response/all_referred_response.dart';
import 'package:ride_usuario/models/response/generate_code_response.dart';
import 'package:ride_usuario/models/response/history_trip_response.dart';
import 'package:ride_usuario/models/response/info_user_referred_response.dart';
import 'package:ride_usuario/models/response/referral_comission_referred.dart';
import 'package:ride_usuario/models/response/referred_user_referred.dart';
import 'package:ride_usuario/models/response/referreds_refer_response.dart';
import 'package:ride_usuario/models/result.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';

class ReferredService {
  ReferredService() : _dio = Dio();

  final Dio _dio;
  PreferenciasUsuario prefs = PreferenciasUsuario();

  Future<Result<GenerateCodeResponse>> generateReferred(
      String idUser, String token) async {
    try {
      final response =
          await _dio.post('${Constants.baseUrl}/referreds/$idUser/generate',
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token',
                },
              ));

      if (response.statusCode == 201) {
        return Result(data: GenerateCodeResponse.fromJson(response.data));
      } else {
        return Result(error: 'Error en la solicitud ${response.statusCode}');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud: $e');
    }
  }

  Future<Result<ReferredsReferResponse>> postRefer(
      String code, int idUser, String token) async {
    try {
      final response = await _dio.post('${Constants.baseUrl}/referreds/refer',
          data: {'idUser': idUser, 'code': code, 'percentage': '5.5'},
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ));

      if (response.statusCode == 201) {
        return Result(data: ReferredsReferResponse.fromJson(response.data));
      } else {
        print('Error en la solicitud ${response.data}');
        return Result(error: 'Error en la solicitud ${response}');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud: $e');
    }
  }

  Future<Result> getReferreds() async {
    try {
      final response = await _dio.get('${Constants.baseUrl}/referreds',
          options: Options(
            headers: {
              'Authorization': 'Bearer ${prefs.accessToken}',
            },
          ));
      if (response.statusCode == 200) {
        return Result(data: response.data);
      } else {
        return Result(error: 'Error en la solicitud');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud: $e');
    }
  }

  Future<Result<ReferredsUserReferredResponse>>
      getReferredsByUserToUserReferred(String idUser) async {
    try {
      final response = await _dio.get(
          '${Constants.baseUrl}/referreds/$idUser/referrals-detail',
          options: Options(
            headers: {
              'Authorization': 'Bearer ${prefs.accessToken}',
            },
          ));

      if (response.statusCode == 200) {
        return Result(
            data: ReferredsUserReferredResponse.fromJson(response.data));
      } else {
        return Result(error: 'Error en la solicitud');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud $e');
    }
  }

  Future<Result<HistoryTripResponse>> getAllHistoryTripReferred(
      String id) async {
    try {
      final response = await _dio.get('${Constants.baseUrl}/trip/history/',
          queryParameters: {
            'role': 'passenger',
            'userId': id,
            'limit': 10,
            'page': 1,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer ${prefs.accessToken}',
            },
          ));
      if (response.statusCode == 200) {
        return Result(data: HistoryTripResponse.fromJson(response.data));
      } else {
        return Result(error: 'Error en la solicitud ${response.statusCode}');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud $e');
    }
  }

  Future<Result> getReferredByUser(
    String userId,
  ) async {
    try {
      final response =
          await _dio.get('${Constants.baseUrl}/referreds/$userId/user',
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

  Future<Result> updateReferredByUser(
    String userId,
  ) async {
    try {
      final response =
          await _dio.patch('${Constants.baseUrl}/referreds/$userId',
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

  Future<Result> deleteReferredByUser(
    String userId,
  ) async {
    try {
      final response =
          await _dio.delete('${Constants.baseUrl}/referreds/$userId',
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

  Future<Result<InfoUserReferredResponse>> getDetailReferredByUser(
    String userId,
  ) async {
    print('ingreso aqui 3');
    try {
      final response = await _dio.get(
          '${Constants.baseUrl}/referreds/$userId/userInfoReferred',
          options: Options(
            headers: {
              'Authorization': 'Bearer ${prefs.accessToken}',
            },
          ));
      if (response.statusCode == 200) {
        return Result(data: InfoUserReferredResponse.fromJson(response.data));
      } else {
        return Result(error: 'Error en la solicitud ${response.statusCode}');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud $e');
    }
  }

  Future<Result<AllReferedResponse>> getAllReferreds(String idUser) async {
    try {
      final response =
          await _dio.get('${Constants.baseUrl}/referreds/$idUser/allReferred',
              options: Options(
                headers: {
                  'Authorization': 'Bearer ${prefs.accessToken}',
                },
              ));

      if (response.statusCode == 200) {
        return Result(data: AllReferedResponse.fromJson(response.data));
      } else {
        return Result(error: 'Error en la solicitud');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud $e');
    }
  }

  Future<Result<AllReferedDetailResponse>> getReferralCommisionGroup(
      String idUser) async {
    try {
      final response = await _dio.get(
        '${Constants.baseUrl}/referral-commission/group-by-referred?idUser=$idUser',
      );

      if (response.statusCode == 200) {
        return Result(data: AllReferedDetailResponse.fromJson(response.data));
      } else {
        return Result(error: 'Error en la solicitud');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud $e');
    }
  }

  Future<Result<ReferralCommissionByReferredResponse>>
      getReferralCommissionByReferred(String idUser) async {
    try {
      final response = await _dio.get(
        '${Constants.baseUrl}/referral-commission/by-referred?userId=$idUser&page=1&limit=10',
      );

      if (response.statusCode == 200) {
        return Result(
            data: ReferralCommissionByReferredResponse.fromJson(response.data));
      } else {
        return Result(error: 'Error en la solicitud');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud $e');
    }
  }
}
