part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class OnNewUserLocationEvent extends LocationEvent {
  const OnNewUserLocationEvent(this.newLocation);
  final LatLng? newLocation;
}

class OnStartFollowUserEvent extends LocationEvent {}
class OnStopFollowUserEvent extends LocationEvent {}
