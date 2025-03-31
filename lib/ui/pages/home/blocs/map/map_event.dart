part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitializedEvent extends MapEvent {
  const OnMapInitializedEvent(this.controller);

  final GoogleMapController controller;
}

class OnStopFollowingUserEvent extends MapEvent {}

class OnStartFollowingUserEvent extends MapEvent {}

class UpdateUserPolylineEvent extends MapEvent {
  const UpdateUserPolylineEvent(this.userLocations);

  final List<LatLng> userLocations;
}

class OnToggleUserRouteEvent extends MapEvent {}

class DisplayPolylineEvent extends MapEvent {
  const DisplayPolylineEvent(this.polylines, this.markers);
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;
}

class UpdateOriginPointEvent extends MapEvent {
  const UpdateOriginPointEvent(this.originPoint);

  final Waypoint originPoint;
}

class UpdateDestinationPointEvent extends MapEvent {
  const UpdateDestinationPointEvent(this.destinationPoint);

  final Waypoint destinationPoint;
}

class AddWaypointEvent extends MapEvent {
  const AddWaypointEvent(this.waypoint);
  final Waypoint waypoint;
}

class RemoveWaypointEvent extends MapEvent {
  const RemoveWaypointEvent(this.waypoint);
  final Waypoint waypoint;
}

class ChangeStatusEvent extends MapEvent {
  const ChangeStatusEvent(this.status);
  final TripStatus status;
}
