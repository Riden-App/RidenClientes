import 'dart:convert';

class UpdateStatusResponse {

    UpdateStatusResponse({
        required this.status,
        required this.data,
    });

    factory UpdateStatusResponse.fromRawJson(String str) => UpdateStatusResponse.fromJson(json.decode(str));

    factory UpdateStatusResponse.fromJson(Map<String, dynamic> json) => UpdateStatusResponse(
        status: json['status'],
        data: Data.fromJson(json['data']),
    );
    final String status;
    final Data data;

    String toRawJson() => json.encode(toJson());

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
    };
}

class Data {

    Data({
        required this.id,
        required this.tripId,
        required this.eventType,
        required this.stopNumber,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'],
        tripId: json['tripId'],
        eventType: json['eventType'],
        stopNumber: json['stopNumber'],
    );
    final String id;
    final String tripId;
    final String eventType;
    final dynamic stopNumber;

    String toRawJson() => json.encode(toJson());

    Map<String, dynamic> toJson() => {
        'id': id,
        'tripId': tripId,
        'eventType': eventType,
        'stopNumber': stopNumber,
    };
}
