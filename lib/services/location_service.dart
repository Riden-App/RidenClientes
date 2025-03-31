import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_usuario/models/response/detail_trip_response.dart';
import 'package:ride_usuario/models/waypoints.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/services/trip_service.dart';
import 'package:ride_usuario/ui/pages/home/blocs/map/map_bloc.dart';
import 'package:ride_usuario/ui/pages/home/blocs/search/search_bloc.dart';

class LocationService {
  final ValueNotifier<bool> _isSendingLocation = ValueNotifier(false);
  Timer? _locationTimer;
  final TripService tripService = TripService();
  PreferenciasUsuario prefs = PreferenciasUsuario();

  void startSendingLocation(BuildContext context) {
    _isSendingLocation.value = true;
    _locationTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      sendLocation(context);
    });
  }

  void stopSendingLocation() {
    _isSendingLocation.value = false;
    _locationTimer?.cancel();
  }

  void sendLocation(BuildContext context) async {
    final result = await tripService.updateLocation();
    final detailTrip = prefs.detailTripResponse;
    if (result.isSuccess) {
      if (context.mounted) {
        await _drawRoute(
          Waypoint(
            name: '',
            lat: result.data!.data.latitude,
            lng: result.data!.data.longitude,
          ),
          detailTrip,
          [],
          context,
        );
      }
    }
  }

  Future<void> _drawRoute(Waypoint origin, DetailTripResponse detailTrip,
      List<Waypoint> waypoints, BuildContext context) async {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final statusTrip = detailTrip.data.tripState;
    final Waypoint destination;
    statusTrip == 'accepted'
        ? destination = Waypoint(
            name: detailTrip.data.pickupLocation!.name,
            lat: detailTrip.data.pickupLocation!.lat,
            lng: detailTrip.data.pickupLocation!.lng,
          )
        : statusTrip == 'arrived_at_pickup'
            ? destination = Waypoint(
                name: detailTrip.data.pickupLocation!.name,
                lat: detailTrip.data.pickupLocation!.lat,
                lng: detailTrip.data.pickupLocation!.lng,
              )
            : statusTrip == 'in_progress'
                ? destination = Waypoint(
                    name: detailTrip.data.dropoffLocations.last.name,
                    lat: detailTrip.data.dropoffLocations.last.lat,
                    lng: detailTrip.data.dropoffLocations.last.lng,
                  )
                : statusTrip == 'arrived_at_destination'
                    ? destination = Waypoint(
                        name: detailTrip.data.dropoffLocations.last.name,
                        lat: detailTrip.data.dropoffLocations.last.lat,
                        lng: detailTrip.data.dropoffLocations.last.lng,
                      )
                    : destination = Waypoint(
                        name: detailTrip.data.dropoffLocations.last.name,
                        lat: detailTrip.data.dropoffLocations.last.lat,
                        lng: detailTrip.data.dropoffLocations.last.lng,
                      );
    print(
        'DEstination: ${destination.name} ${destination.lat} ${destination.lng}');
    final searchPolylines =
        await searchBloc.getCoorsStartToEnd(origin, destination, waypoints);
    await mapBloc.drawRoutePolyline(searchPolylines, waypoints);
  }
}

final locationService = LocationService();
