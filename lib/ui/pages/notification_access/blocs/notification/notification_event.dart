part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class NotificationandPermissionsEvent extends NotificationEvent {
  const NotificationandPermissionsEvent({
    required this.isNotificationPermissionGranted,
  });
  final bool isNotificationPermissionGranted;
}
