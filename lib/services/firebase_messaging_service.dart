import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_usuario/enums/trip_status.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/services/trip_service.dart';
import 'package:ride_usuario/ui/pages/home/blocs/map/map_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final TripService tripService = TripService();

  void initialize(GlobalKey<NavigatorState> navigatorKey) {
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(navigatorKey, message);
      _saveNotificationData(message.data); // Guardar la data
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(navigatorKey, message);
      _saveNotificationData(message.data); // Guardar la data
    });

    _checkForInitialMessage(navigatorKey);
  }

  void _checkForInitialMessage(GlobalKey<NavigatorState> navigatorKey) async {
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(navigatorKey, initialMessage);
      _saveNotificationData(initialMessage.data); // Guardar la data
    }
  }

  void _saveNotificationData(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('notification_data', data.toString());
  }

  void _handleMessage(
      GlobalKey<NavigatorState> navigatorKey, RemoteMessage message) async {
    PreferenciasUsuario prefs = PreferenciasUsuario();
    TripStatus statusTrip;

    final data = message.data;
    final tripId = prefs.createTripResponse.data.id;

    final result = await tripService.getDataTrip(tripId);

    if (result.isSuccess) {
      prefs.detailTripResponse = result.data!;
      prefs.totalStops = result.data!.data.dropoffLocations.length;
      final tripStatus = result.data!.data.tripState;
      if (tripStatus == 'accepted') {
        statusTrip = TripStatus.accepted;
      } else if (tripStatus == 'arrived_at_pickup') {
        statusTrip = TripStatus.waitingUser;
      } else if (tripStatus == 'in_progress') {
        statusTrip = TripStatus.inProgress;
      } else if (tripStatus == 'arrived_at_destination') {
        statusTrip = TripStatus.completed;
      } else if (tripStatus == 'in_bid') {
        statusTrip = TripStatus.waitingDriversBid;
      } else if (tripStatus == 'arrived_at_stop') {
        statusTrip = TripStatus.arriveStop;
      } else if (tripStatus == 'resumed_after_stop') {
        statusTrip = TripStatus.resumeTrip;
      } else {
        statusTrip = TripStatus.none;
      }
      final context = navigatorKey.currentState!.overlay!.context;
      final mapBloc = BlocProvider.of<MapBloc>(context);
      mapBloc.add(ChangeStatusEvent(statusTrip));
    }
  }

  void changeStatusTrip(
      GlobalKey<NavigatorState> navigatorKey, String title, dynamic body) {
    final context = navigatorKey.currentState!.overlay!.context;
    final mapBloc = BlocProvider.of<MapBloc>(context);
    mapBloc.add(ChangeStatusEvent(TripStatus.searching));
  }
}
