
part of 'gps_bloc.dart';

sealed class GpsEvent extends Equatable {
  const GpsEvent();

  @override
  List<Object> get props => [];
}

class GpsandPermissionsEvent extends GpsEvent {
  const GpsandPermissionsEvent(
      {required this.isGpsEnabled, required this.isGpsPermissionGranted});

  final bool isGpsEnabled;
  final bool isGpsPermissionGranted;
}
