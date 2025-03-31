part of 'location_bloc.dart';

class LocationState extends Equatable {
  const LocationState({
    this.followingUser = false,
    this.lastKnowLocation,
    myLocationHistory,
  }) : myLocationHistory = myLocationHistory ?? const [];

  final bool followingUser;
  final List<LatLng> myLocationHistory;
  final LatLng? lastKnowLocation;

  LocationState copyWith({
    bool? followingUser,
    LatLng? lastKnowLocation,
    List<LatLng>? myLocationHistory,
  }) =>
      LocationState(
        followingUser: followingUser ?? this.followingUser,
        lastKnowLocation: lastKnowLocation ?? this.lastKnowLocation,
        myLocationHistory: myLocationHistory ?? this.myLocationHistory,
      );

  @override
  List<Object?> get props => [
        followingUser,
        lastKnowLocation,
        myLocationHistory,
      ];
}
