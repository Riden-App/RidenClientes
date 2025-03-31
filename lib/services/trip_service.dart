import 'package:dio/dio.dart';
import 'package:ride_usuario/config/constants.dart';
import 'package:ride_usuario/enums/categori.dart';
import 'package:ride_usuario/models/response/create_trip_response.dart';
import 'package:ride_usuario/models/response/detail_trip_bid_response.dart';
import 'package:ride_usuario/models/response/detail_trip_response.dart';
import 'package:ride_usuario/models/response/history_trip_response.dart';
import 'package:ride_usuario/models/response/location_response.dart';
import 'package:ride_usuario/models/response/price_trip_response.dart';
import 'package:ride_usuario/models/response/rating_response.dart';
import 'package:ride_usuario/models/response/update_status_trip_response.dart';
import 'package:ride_usuario/models/result.dart';
import 'package:ride_usuario/models/waypoints.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';

class TripService {
  TripService()
      : _dio = Dio(),
        _dioTrip = Dio();

  final Dio _dio;
  final Dio _dioTrip;
  PreferenciasUsuario prefs = PreferenciasUsuario();

  Future<Result<TripCreateResponse>> createTrip({
    required requestType,
    required pickupLocation,
    required dropoffLocations,
  }) async {
    try {
      final response = await _dio.post('${Constants.baseUrl}/trip/request',
          data: {
            'pickupLocation': pickupLocation,
            'dropoffLocations': dropoffLocations,
            'paymentMethod': 'YAPE',
            'requestType': requestType ? 'fast' : 'bid',
            'offer': num.parse(prefs.oferta),
            'tripDetail': prefs.detailTrip,
            'tripType': prefs.tripType /*'passenger' 'delivery'*/,
            'tripClass': prefs.categoryTrip == RideCategory.comfort.value
                ? 'comfort'
                : prefs.categoryTrip == RideCategory.standard.value
                    ? 'standard'
                    : 'spacious',
            if (prefs.contactEmisor == '') 'senderMobile': prefs.contactEmisor,
            if (prefs.contacReceptor == '')
              'receiverMobile': prefs.contacReceptor,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer ${prefs.accessToken}',
            },
          ));
      if (response.statusCode == 201) {
        return Result(data: TripCreateResponse.fromJson(response.data));
      } else {
        return Result(error: 'Error en la solicitud ${response.statusMessage}');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud: $e');
    }
  }

  Future<Result<UpdateStatusResponse>> updateStatusTrip(
      String status, String idTrip) async {
    try {
      final response =
          await _dio.post('${Constants.baseUrl}/trip/$idTrip/event',
              data: {'eventType': status},
              options: Options(
                headers: {
                  'Authorization': 'Bearer ${prefs.accessToken}',
                },
              ));

      if (response.statusCode == 201) {
        return Result(data: UpdateStatusResponse.fromJson(response.data));
      } else {
        return Result(error: 'Error en la solicitud ${response.statusCode}');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud: $e');
    }
  }

  Future<void> sendTripRequest(Map<String, dynamic> tripData) async {
    try {
      final response = await _dioTrip.post(
        '${Constants.baseUrl}/trip/request',
        data: tripData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return data;
      } else {
        print('Error al enviar la solicitud');
      }
    } catch (e) {
      print('Error al realizar la petición: $e');
    }
  }

  Future<List<dynamic>> sendEvent(String id, String event) async {
    // Event: CANCEL, ACCEPT, ARRIVE_PICKUP, START, ARRIVE_STOP, RESUME_TRIP, ARRIVE_DESTINATION
    try {
      final response = await _dio.post(
        '${Constants.baseUrl}/trip/$id/event',
        data: event,
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al cargar los datos');
      }
    } catch (e) {
      throw Exception('Error en la solicitud: $e');
    }
  }

  Future<Result<UpdateStatusResponse>> updateStatusTripOffer(
      String status, String idTrip, String tripBidId) async {
    try {
      final response =
          await _dio.post('${Constants.baseUrl}/trip/$idTrip/event',
              data: {'eventType': status, 'tripBidId': tripBidId},
              options: Options(
                headers: {
                  'Authorization': 'Bearer ${prefs.accessToken}',
                },
              ));

      if (response.statusCode == 201) {
        return Result(data: UpdateStatusResponse.fromJson(response.data));
      } else {
        return Result(error: 'Error en la solicitud ${response.statusCode}');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud: $e');
    }
  }

  Future<Result<DetailTripResponse>> getDataTrip(String idTrip) async {
    try {
      final response = await _dio.get('${Constants.baseUrl}/trip/$idTrip',
          options: Options(
            headers: {
              'Authorization': 'Bearer ${prefs.accessToken}',
            },
          ));
      if (response.statusCode == 200) {
        return Result(data: DetailTripResponse.fromJson(response.data));
      } else {
        return Result(error: 'Error en la solicitud');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud: $e');
    }
  }

  Future<Result<LocationResponse>> updateLocation() async {
    try {
      final response = await _dio.get('${Constants.baseUrl}/user/4',
          options: Options(
            headers: {
              'Authorization': 'Bearer ${prefs.accessToken}',
            },
          ));

      if (response.statusCode == 200) {
        return Result(data: LocationResponse.fromJson(response.data));
      } else {
        return Result(error: 'Error en la solicitud');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud');
    }
  }

  Future<Result<RatingResponse>> sendRating(
      String tripId, int star, String comment) async {
    try {
      final response = await _dio.post('${Constants.baseUrl}/driver/42/rate',
          data: {'tripId': tripId, 'rate': star, 'comment': comment},
          options: Options(
            headers: {
              'Authorization': 'Bearer ${prefs.accessToken}',
            },
          ));
      if (response.statusCode == 201) {
        return Result(data: RatingResponse.fromJson(response.data));
      } else {
        return Result(error: 'Error en la solicitud ${response.statusCode}');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud $e');
    }
  }

  Future<Result<DetailTripBidResponse>> getDataBidTrip(String idBidTrip) async {
    try {
      final response = await _dio.get(
        '${Constants.baseUrl}/trip-bid/$idBidTrip',
      );
      if (response.statusCode == 200) {
        return Result(data: DetailTripBidResponse.fromJson(response.data));
      } else {
        return Result(error: 'Error en la solicitud');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud: $e');
    }
  }

  Future<Result<DetailTripBidResponse>> getAllTripBid() async {
    try {
      final response =
          await _dio.get('${Constants.baseUrl}/driver/me/current-trips',
              options: Options(
                headers: {
                  'Authorization': 'Bearer ${prefs.accessToken}',
                },
              ));
      if (response.statusCode == 200) {
        return Result(data: DetailTripBidResponse.fromJson(response.data));
      } else {
        return Result(error: 'Error en la solicitud');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud: $e');
    }
  }

  Future<Result<HistoryTripResponse>> getAllHistoryTrip() async {
    try {
      final response = await _dio.get('${Constants.baseUrl}/trip/history/',
          queryParameters: {
            'role': 'passenger',
            'userId': prefs.idUser,
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

  Future<Result<PriceTripResponse>> getPriceTrip(Waypoint pickupLocation,
      Waypoint pickOffLocation, List<Waypoint>? waypoints) async {
    String categoryTrip = prefs.categoryTrip == RideCategory.comfort.value
        ? 'comfort'
        : prefs.categoryTrip == RideCategory.standard.value
            ? 'standard'
            : 'spacious';

    List<Map<String, dynamic>> waypointArray = [];
    waypointArray.add({
      'lat': pickOffLocation.lat,
      'lng': pickOffLocation.lng,
      'name': pickOffLocation.name,
      'sequence': 1,
    });

    if (waypoints != null && waypoints.isNotEmpty) {
      for (int i = 0; i < waypoints.length; i++) {
        waypointArray.add({
          'lat': waypoints[i].lat,
          'lng': waypoints[i].lng,
          'name': waypoints[i].name,
          'sequence': i + 2,
        });
      }
    }

    try {
      final response = await _dio.post('${Constants.baseUrl}/trip/trip-fare',
          options: Options(
            headers: {
              'Authorization': 'Bearer ${prefs.accessToken}',
            },
          ),
          data: {
            'pickupLocation': {
              'lat': pickupLocation.lat,
              'lng': pickupLocation.lng,
              'name': pickupLocation.name,
              'sequence': 0
            },
            'dropoffLocations': waypointArray,
            'tripClass': categoryTrip
          });
      if (response.statusCode == 201) {
        return Result(data: PriceTripResponse.fromJson(response.data));
      } else {
        return Result(error: 'Error en la solicitud ${response.statusMessage}');
      }
    } catch (e) {
      return Result(error: 'Error en la solicitud $e');
    }
  }
}
