import 'dart:convert';

class ChatResponse {

    ChatResponse({
        required this.status,
        required this.data,
    });

    factory ChatResponse.fromRawJson(String str) => ChatResponse.fromJson(json.decode(str));

    factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
        status: json['status'],
        data: List<DataChats>.from(json['data'].map((x) => DataChats.fromJson(x))),
    );
    final String status;
    final List<DataChats> data;

    String toRawJson() => json.encode(toJson());

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DataChats {

    DataChats({
        required this.id,
        required this.content,
        required this.senderId,
        required this.roomId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory DataChats.fromRawJson(String str) => DataChats.fromJson(json.decode(str));

    factory DataChats.fromJson(Map<String, dynamic> json) => DataChats(
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
    final dynamic createdAt;
    final dynamic updatedAt;

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
