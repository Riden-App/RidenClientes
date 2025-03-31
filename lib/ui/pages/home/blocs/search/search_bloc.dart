import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:ride_usuario/enums/enums.dart';
import 'package:ride_usuario/models/places_models.dart';
import 'package:ride_usuario/models/route_destination.dart';
import 'package:ride_usuario/models/waypoints.dart';
import 'package:ride_usuario/services/services.dart';
import 'package:ride_usuario/services/traffic_service.dart';
import 'package:ride_usuario/ui/pages/home/view/finish_trip.dart';

part 'search_event.dart';
part 'search_state.dart';

PreferenciasUsuario prefs = PreferenciasUsuario();

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required this.trafficService,
  }) : super(const SearchState()) {
    on<OnActivateManualMarketEvent>(
        (event, emit) => emit(state.copyWith(displayManualMarket: true)));
    on<OffActivateManualMarketEvent>(
        (event, emit) => emit(state.copyWith(displayManualMarket: false)));

    on<OnNewPlacesFounEvent>(
        (event, emit) => emit(state.copyWith(places: event.places)));

    on<AddToHistoryEvent>(
      (event, emit) =>
          emit(state.copyWith(history: [event.place, ...state.history])),
    );

    on<UpdateTypeMarketEvent>((event, emit) {
      emit(state.copyWith(typeMarket: event.typeMarket));
    });
  }

  TrafficService trafficService;

  Future<RouteDestination> getCoorsStartToEnd(
      Waypoint start, Waypoint end, List<Waypoint>? waypoints) async {
    final resp = await trafficService.getCoorsStartToEnd(start, end, waypoints);
    await getPriceRoute(start, end, waypoints);

    final distance = resp.routes[0].legs[0].distance.value.toDouble();
    final duration = resp.routes[0].legs[0].duration.value.toDouble();
    final geometry = resp.routes[0].overviewPolyline.points;

    final points = decodePolyline(geometry);

    final latLngList =
        points.map((e) => LatLng(e[0].toDouble(), e[1].toDouble())).toList();

    return RouteDestination(
      points: latLngList,
      duration: duration,
      distance: distance,
    );
  }

  Future<void> getPriceRoute(
      Waypoint origin, Waypoint destination, List<Waypoint>? waypoints) async {
    final response =
        await tripService.getPriceTrip(origin, destination, waypoints);
    if (response.isSuccess) {
      final priceResponse = response.data!.data.totalFare;
      final kmResponse = response.data!.data.totalFare;
      int roundedPrice =
          (double.parse(priceResponse.toStringAsFixed(2))).toInt();
      prefs.priceTrip = roundedPrice.toString();
      prefs.oferta = roundedPrice.toString();
      prefs.kmTrip = kmResponse.toStringAsFixed(2);
    } else {
      print('Error getPriceTrip: ${response.error}');
    }
  }

  Future getPLacesByquery(LatLng proximity, String query) async {
    final newPlaces = await trafficService.getResultsByQuery(proximity, query);

    add(OnNewPlacesFounEvent(newPlaces));
  }
}
