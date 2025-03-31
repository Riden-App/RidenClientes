import 'package:dio/dio.dart';
import 'package:ride_usuario/config/constants.dart';
import 'package:ride_usuario/models/response/chat_response.dart';
import 'package:ride_usuario/models/response/room_response.dart';
import 'package:ride_usuario/models/result.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  SocketService() : _dio = Dio();
  final Dio _dio;

  late IO.Socket _socket;
  PreferenciasUsuario prefs = PreferenciasUsuario();
  Function(Map<String, dynamic>)? onNewMessage;

  void connectToSocket() {
    _socket = IO.io('http://34.172.134.50:3051/chats', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'extraHeaders': {
        'Authorization': 'Bearer ${prefs.accessToken}',
      },
    });

    _socket.connect();

    _socket.on('connect', (_) {
      print('Conectado al servidor de chats');
    });

    _socket.on('connect_error', (error) {
      print('Error Conectado al servidor  : $error');
    });

    _socket.on('new_chat', (data) {
      print('Nuevo mensaje recibido: $data');
      if (onNewMessage != null) {
        onNewMessage!(data);
      }
    });
    _socket.on('new-chat', (data) {
      print('Nuevo mensaje recibido: $data');
      if (onNewMessage != null) {
        onNewMessage!(data);
      }
    });

    _socket.on('NEW_CHAT', (data) {
      print('Nuevo mensaje recibido: $data');
      if (onNewMessage != null) {
        onNewMessage!(data);
      }
    });

    _socket.on('dataDriver', (data) {});

    _socket.on('disconnect', (_) {});
  }

  void sendChatMessage(String roomId, String content) {
    if (_socket.connected) {
      _socket.emit(
        'create',
        {
          'room_id': roomId,
          'content': content,
        },
      );
      print('Mensaje enviado');
    } else {
      print('No conectado al servidor');
    }
  }

  bool joinRoom(String roomId) {
    if (_socket.connected) {
      _socket.emit(
        'join_room',
        {
          'roomId': roomId
        },
      );
      return true;
    } else {
      print('No conectado al servidor');
      return false;
    }
  }

  void disconnect() {
    _socket.disconnect();
  }

  Future<Result<RoomResponse>> createRoom(int idMember) async {
    try {
      final response = await _dio.post('${Constants.baseUrl}/room',
          data: {
            'name': 'Trip_${prefs.lastName}',
            'type': 'personal',
            'members': [idMember],
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer ${prefs.accessToken}',
            },
          ));

      if (response.statusCode == 201) {
        return Result(data: RoomResponse.fromJson(response.data));
      } else {
        return Result(error: 'Error creacion de sala');
      }
    } catch (e) {
      return Result(error: 'Error creacion de sala');
    }
  }

  Future<Result<ChatResponse>> getChatsRoom(String idRoom) async {
    try {
      final response = await _dio.get('${Constants.baseUrl}/room/$idRoom/chats',
          options: Options(
            headers: {
              'Authorization': 'Bearer ${prefs.accessToken}',
            },
          ));

      if (response.statusCode == 200) {
        return Result(data: ChatResponse.fromJson(response.data));
      } else {
        print('no ingreesando a la sala');

        return Result(error: 'Error obteniendo mensajes');
      }
    } catch (e) {
      return Result(error: 'Error obteniendo mensajes');
    }
  }

  IO.Socket get socket => _socket;
}
