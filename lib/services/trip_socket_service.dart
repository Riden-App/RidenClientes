import 'package:dio/dio.dart';
import 'package:ride_usuario/enums/enums.dart';
import 'package:ride_usuario/services/services.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TripSocketService {
  TripSocketService() : _dio = Dio();
  final Dio _dio;

  late IO.Socket _socket;
  PreferenciasUsuario prefs = PreferenciasUsuario();
  SocketService socketService = SocketService();

  void connectToSocketTrip(
      Function(Map<String, dynamic>, TripStatus) onChangeStatusTrip) {
    _socket = IO.io('http://34.172.134.50:3021/trip', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'extraHeaders': {
        'Authorization': 'Bearer ${prefs.accessToken}',
      },
    });

    _socket.connect();

    _socket.on('connect', (_) {
      print('Conectado al servidor de viajes');
    });

    _socket.on('connect_error', (error) {
      print('Error Conectado al servidor  : $error');
    });

    _socket.on('CANCEL', (data) {
      print('TRIP!! CANCEL $data');
      onChangeStatusTrip(data, TripStatus.none);
    });
    _socket.on('ACCEPT', (data) {
      print('TRIP!! ACCEPT $data');
      socketService.connectToSocket();
      onChangeStatusTrip(data, TripStatus.accepted);
      socketService.joinRoom(prefs.detailTripResponse.data.roomId);
    });
    _socket.on('BID', (data) {
      print('TRIP!! BID $data');
      onChangeStatusTrip(data, TripStatus.waitingDriversBid);
    });
    _socket.on('REJECT', (data) {
      print('TRIP!! REJECT $data');
    });
    _socket.on('ARRIVE_PICKUP', (data) {
      print('TRIP!! ARRIVE_PICKUP $data');
      onChangeStatusTrip(data, TripStatus.waitingUser);
    });
    _socket.on('START', (data) {
      print('TRIP!! START $data');
      onChangeStatusTrip(data, TripStatus.inProgress);
    });
    _socket.on('ARRIVE_STOP', (data) {
      print('TRIP!! ARRIVE_STOP $data');
    });
    _socket.on('RESUME_TRIP', (data) {
      print('TRIP!! RESUME_TRIP $data');
    });
    _socket.on('ARRIVE_DESTINATION', (data) {
      print('TRIP!! ARRIVE_DESTINATION $data');
      onChangeStatusTrip(data, TripStatus.completed);
    });

    _socket.on('disconnect', (_) {
      print('Desconectado del servidor');
    });
  }

  void disconnect() {
    _socket.disconnect();
  }

  IO.Socket get socket => _socket;
}
