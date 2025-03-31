import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_usuario/config/constants.dart';
import 'package:ride_usuario/models/name_latlng.dart';
import 'package:ride_usuario/models/place_detail_models.dart';
import 'package:ride_usuario/models/places_models.dart';
import 'package:ride_usuario/models/traffic_response.dart';
import 'package:ride_usuario/models/waypoints.dart';

class TrafficService {
  TrafficService()
      : _dioTraffic = Dio(),
        _dioPlaces = Dio(),
        _dioDeatilPlaces = Dio(),
        _dioNameByLatLng = Dio();

  final Dio _dioTraffic;
  final Dio _dioPlaces;
  final Dio _dioDeatilPlaces;
  final Dio _dioNameByLatLng;

  Future<TrafficResponse> getCoorsStartToEnd(
      Waypoint origin, Waypoint destination, List<Waypoint>? waypoints) async {
    const url = '${Constants.baseUrlMaps}/directions/json';

    String waypointsParam = '';
    if (waypoints != null && waypoints.isNotEmpty) {
      waypointsParam = waypoints.map((w) => '${w.lat},${w.lng}').join('|');
    }
    try {
      final response = await _dioTraffic.get(
        url,
        queryParameters: {
          'origin': '${origin.lat},${origin.lng}',
          'destination': '${destination.lat},${destination.lng}',
          'key': Constants.apiKeyMaps,
          if (waypointsParam.isNotEmpty) 'waypoints': waypointsParam,
        },
      );

      final data = TrafficResponse.fromJson(response.data);
      return data;
    } catch (e) {
      print('Error fetching traffic data: $e');
      rethrow;
    }
  }

  Future<List<Prediction>> getResultsByQuery(
      LatLng proximity, String query) async {
    if (query.length <= 2) return [];

    String urlLugaresCercanos1 =
        '${Constants.baseUrlMaps}/place/autocomplete/json?input=';
    String urlLugaresCercanos2 =
        '&radius=90000&strictbounds&key=${Constants.apiKeyMaps}&components=country:pe';

    final resp = await _dioPlaces.get(
        '$urlLugaresCercanos1$query&location=${proximity.latitude.toStringAsFixed(5)},${proximity.longitude.toStringAsFixed(5)}$urlLugaresCercanos2');

    final placesResponse = PlacesResponse.fromJson(resp.data);

    return placesResponse.predictions;
  }

  Future<Result> getDetailsByPlaceId(String placeId) async {
    final resp = await _dioDeatilPlaces.get(
        '${Constants.baseUrlMaps}/place/details/json?place_id=$placeId&key=${Constants.apiKeyMaps}');

    final placesResponse = PlacesDetailResponse.fromJson(resp.data);

    return placesResponse.result;
  }

  Future<String> getNameByLatLng(LatLng point) async {
    final resp = await _dioNameByLatLng.get(
        '${Constants.baseUrlMaps}/geocode/json?latlng=${point.latitude},${point.longitude}&key=${Constants.apiKeyMaps}');

    final placesResponse = NameLatLngResponse.fromJson(resp.data);

    return placesResponse.results[0].formattedAddress.split(',')[0];
  }
}
