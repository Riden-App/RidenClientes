part of 'map_bloc.dart';

class MapState extends Equatable {
  const MapState({
    this.isMapInitialized = false,
    this.isFollowingUser = true,
    this.showMyRoute = false,
    waypoints,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
    this.originPoint,
    this.destinationPoint,
    this.status = TripStatus.none,
  })  : polylines = polylines ?? const {},
        markers = markers ?? const {},
        waypoints = waypoints ?? const [];

  final bool isMapInitialized;
  final bool isFollowingUser;
  final bool showMyRoute;

  final List<Waypoint> waypoints;

  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  final Waypoint? originPoint;
  final Waypoint? destinationPoint;

  final TripStatus status;

  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowingUser,
    bool? showMyRoute,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
    List<Waypoint>? waypoints,
    Waypoint? originPoint,
    Waypoint? destinationPoint,
    TripStatus? status,
  }) =>
      MapState(
        isMapInitialized: isMapInitialized ?? this.isMapInitialized,
        isFollowingUser: isFollowingUser ?? this.isFollowingUser,
        showMyRoute: showMyRoute ?? this.showMyRoute,
        polylines: polylines ?? this.polylines,
        markers: markers ?? this.markers,
        waypoints: waypoints ?? this.waypoints,
        originPoint: originPoint ?? this.originPoint,
        destinationPoint: destinationPoint ?? this.destinationPoint,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props => [
        isMapInitialized,
        isFollowingUser,
        showMyRoute,
        polylines,
        markers,
        waypoints,
        originPoint,
        destinationPoint,
        status,
      ];
}
