import 'dart:convert';

class RoomChatsResponse {
  RoomChatsResponse({
    required this.id,
    required this.content,
    required this.senderId,
    required this.roomId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoomChatsResponse.fromRawJson(String str) =>
      RoomChatsResponse.fromJson(json.decode(str));

  factory RoomChatsResponse.fromJson(Map<String, dynamic> json) =>
      RoomChatsResponse(
        id: json['_id'],
        content: json['content'],
        senderId: json['sender_id'],
        roomId: json['room_id'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
  final String id;
  final String content;
  final int senderId;
  final String roomId;
  final DateTime createdAt;
  final DateTime updatedAt;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        '_id': id,
        'content': content,
        'sender_id': senderId,
        'room_id': roomId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
