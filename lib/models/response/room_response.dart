import 'dart:convert';

class RoomResponse {
  RoomResponse({
    required this.status,
    required this.data,
  });

  factory RoomResponse.fromRawJson(String str) =>
      RoomResponse.fromJson(json.decode(str));

  factory RoomResponse.fromJson(Map<String, dynamic> json) => RoomResponse(
        status: json['status'],
        data: DataRoom.fromJson(json['data']),
      );
  final String status;
  final DataRoom data;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
      };
}

class DataRoom {
  DataRoom({
    required this.id,
    required this.members,
    required this.name,
    required this.type,
    required this.hostUid,
  });

  factory DataRoom.fromRawJson(String str) => DataRoom.fromJson(json.decode(str));

  factory DataRoom.fromJson(Map<String, dynamic> json) => DataRoom(
        id: json['_id'],
        members: List<int>.from(json['members'].map((x) => x)),
        name: json['name'],
        type: json['type'],
        hostUid: json['hostUid'],
      );
  final String id;
  final List<int> members;
  final String name;
  final String type;
  final int hostUid;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        '_id': id,
        'members': List<dynamic>.from(members.map((x) => x)),
        'name': name,
        'type': type,
        'hostUid': hostUid,
      };
}
