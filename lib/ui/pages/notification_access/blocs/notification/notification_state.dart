part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  const NotificationState({
    required this.isNotificationPermissionGranted,
  });
  final bool isNotificationPermissionGranted;

  bool get isAllNotificationGranted => isNotificationPermissionGranted;
  NotificationState copyWith({
    bool? isNotificationPermissionGranted,
  }) {
    return NotificationState(
      isNotificationPermissionGranted: isNotificationPermissionGranted ??
          this.isNotificationPermissionGranted,
    );
  }

  @override
  List<Object> get props => [isNotificationPermissionGranted];

  @override
  String toString() =>
      '{isNotificationPermissionGranted: $isNotificationPermissionGranted}';
}
