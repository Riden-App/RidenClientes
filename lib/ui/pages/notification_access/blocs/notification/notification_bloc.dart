import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  StreamSubscription? notificationServiceSubscription;

  NotificationBloc()
      : super(NotificationState(isNotificationPermissionGranted: false)) {
    on<NotificationandPermissionsEvent>((event, emit) => emit(state.copyWith(
          isNotificationPermissionGranted:
              event.isNotificationPermissionGranted,
        )));

    _init();
  }

  Future<void> _init() async {
    final notificationInitStatus = await Future.wait([
      _isPermissionGranted(),
    ]);

    add(NotificationandPermissionsEvent(
        isNotificationPermissionGranted: notificationInitStatus[0]));
  }

  Future<bool> _isPermissionGranted() async {
    final isGranted = await Permission.notification.isGranted;
    return isGranted;
  }

  Future<void> askNotificationAccess() async {
    final status = await Permission.notification.request();

    switch (status) {
      case PermissionStatus.granted:
        add(NotificationandPermissionsEvent(
            isNotificationPermissionGranted: true));
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.provisional:
        add(NotificationandPermissionsEvent(
            isNotificationPermissionGranted: false));
        openAppSettings();
    }
  }

  @override
  Future<void> close() {
    notificationServiceSubscription?.cancel();
    return super.close();
  }
}
