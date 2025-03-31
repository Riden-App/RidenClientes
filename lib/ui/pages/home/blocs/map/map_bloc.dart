import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_usuario/blocs/blocs.dart';
import 'package:ride_usuario/enums/enums.dart';
import 'package:ride_usuario/helpers/custom_image_market.dart';
import 'package:ride_usuario/models/route_destination.dart';
import 'package:ride_usuario/models/waypoints.dart';
import 'package:ride_usuario/themes/colors.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc({
    required this.locationBloc,
  }) : super(MapState()) {
    on<OnMapInitializedEvent>(_onInitMap);
    on<OnStartFollowingUserEvent>(_onStartFollowingUser);
    on<OnStopFollowingUserEvent>(
        (event, emit) => emit(state.copyWith(isFollowingUser: false)));
    on<UpdateUserPolylineEvent>(_onPolylineNewPoint);
    on<OnToggleUserRouteEvent>((event, emit) => emit(state.copyWith(
          showMyRoute: !state.showMyRoute,
        )));

    on<DisplayPolylineEvent>((event, emit) => emit(state.copyWith(
          polylines: event.polylines,
          markers: event.markers,
        )));

    on<UpdateOriginPointEvent>((event, emit) {
      emit(state.copyWith(originPoint: event.originPoint));
    });
    on<UpdateDestinationPointEvent>((event, emit) {
      emit(state.copyWith(destinationPoint: event.destinationPoint));
    });

    on<AddWaypointEvent>(_onAddWaypoint);

    on<RemoveWaypointEvent>(_onRemoveWaypoint);

    on<ChangeStatusEvent>((event, emit) {
      emit(state.copyWith(status: event.status));
    });

    locationStateSubscription = locationBloc.stream.listen((locationState) {
      if (locationState.lastKnowLocation != null) {
        add(UpdateUserPolylineEvent(locationState.myLocationHistory));
      }

      if (!state.isFollowingUser) return;
      if (locationState.lastKnowLocation == null) return;

      moveCamera(locationState.lastKnowLocation!);
    });
  }
  final LocationBloc locationBloc;

  GoogleMapController? _mapController;
  LatLng? mapCenter;

  StreamSubscription<LocationState>? locationStateSubscription;

  void _onInitMap(OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;

    emit(state.copyWith(isMapInitialized: true));
  }

  void selectOriginPoint(LatLng point) {}

  Future drawRoutePolyline(
      RouteDestination destination, List<Waypoint> waypoints) async {
    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    final currentMarkers = Map<String, Marker>.from(state.markers);

    currentPolylines.clear();
    currentMarkers.clear();

    final myRoute = Polyline(
      polylineId: const PolylineId('route'),
      color: AppColors.black,
      width: 3,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: destination.points,
    );
    currentPolylines['route'] = myRoute;
    final pickUpMarker = await getImageMarker('pickup_marker');
    final pickoffMarker = await getImageMarker('pickoff_marker');
    final waypint1Marker = await getImageMarker('waypoint1');
    final waypint2Marker = await getImageMarker('waypoint2');
    final waypint3Marker = await getImageMarker('waypoint3');
    final startMarker = Marker(
        markerId: const MarkerId('start'),
        position: destination.points.first,
        icon: pickUpMarker);
    final endMarker = Marker(
        markerId: const MarkerId('end'),
        position: destination.points.last,
        icon: pickoffMarker);
    currentMarkers['start'] = startMarker;
    currentMarkers['end'] = endMarker;

    final List<Marker> waypointMarkers = waypoints
        .asMap()
        .map((index, waypoint) => MapEntry(
              index,
              Marker(
                markerId: MarkerId('waypoint_$index'),
                position: LatLng(waypoint.lat, waypoint.lng),
                icon: index == 0
                    ? waypint1Marker
                    : index == 1
                        ? waypint2Marker
                        : index == 2
                            ? waypint3Marker
                            : waypint3Marker,
                infoWindow: InfoWindow(title: waypoint.name),
              ),
            ))
        .values
        .toList();
    for (var marker in waypointMarkers) {
      currentMarkers[marker.markerId.value] = marker;
    }

    add(DisplayPolylineEvent(currentPolylines, currentMarkers));
  }

  void moveCamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }

  void _onStartFollowingUser(
      OnStartFollowingUserEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(isFollowingUser: true));

    if (locationBloc.state.lastKnowLocation == null) return;

    moveCamera(locationBloc.state.lastKnowLocation!);
  }

  void _onPolylineNewPoint(
      UpdateUserPolylineEvent event, Emitter<MapState> emit) {
    final route = Polyline(
      polylineId: const PolylineId('myRoute'),
      color: Colors.red,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: event.userLocations,
    );

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['myRoute'] = route;

    emit(state.copyWith(polylines: currentPolylines));
  }

  void _onAddWaypoint(AddWaypointEvent event, Emitter<MapState> emit) {
    final updatedWaypoints = List<Waypoint>.from(state.waypoints)
      ..add(event.waypoint);

    emit(state.copyWith(waypoints: updatedWaypoints));
  }

  void _onRemoveWaypoint(RemoveWaypointEvent event, Emitter<MapState> emit) {
    final updatedWaypoints = List<Waypoint>.from(state.waypoints)
      ..remove(event.waypoint);

    emit(state.copyWith(waypoints: updatedWaypoints));
  }

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }
}
