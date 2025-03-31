import 'dart:convert';

class HistoryTripResponse {

    HistoryTripResponse({
        required this.status,
        required this.data,
    });

    factory HistoryTripResponse.fromRawJson(String str) => HistoryTripResponse.fromJson(json.decode(str));

    factory HistoryTripResponse.fromJson(Map<String, dynamic> json) => HistoryTripResponse(
        status: json['status'],
        data: DataHistori.fromJson(json['data']),
    );
    final String status;
    final DataHistori data;

    String toRawJson() => json.encode(toJson());

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
    };
}

class DataHistori {

    DataHistori({
        required this.trips,
        required this.total,
        required this.page,
        required this.limit,
        required this.totalPages,
    });

    factory DataHistori.fromRawJson(String str) => DataHistori.fromJson(json.decode(str));

    factory DataHistori.fromJson(Map<String, dynamic> json) => DataHistori(
        trips: List<TripHistory>.from(json['trips'].map((x) => TripHistory.fromJson(x))),
        total: json['total'],
        page: json['page'],
        limit: json['limit'],
        totalPages: json['totalPages'],
    );
    final List<TripHistory> trips;
    final dynamic total;
    final dynamic page;
    final dynamic limit;
    final dynamic totalPages;

    String toRawJson() => json.encode(toJson());

    Map<String, dynamic> toJson() => {
        'trips': List<dynamic>.from(trips.map((x) => x.toJson())),
        'total': total,
        'page': page,
        'limit': limit,
        'totalPages': totalPages,
    };
}

class TripHistory {

    TripHistory({
        required this.id,
        required this.userId,
        required this.driverUserId,
        required this.pickupLocation,
        required this.dropoffLocations,
        required this.paymentMethod,
        required this.requestType,
        required this.offer,
        required this.tripDetail,
        required this.tripType,
        required this.tripClass,
        required this.vehicleId,
        required this.senderMobile,
        required this.receiverMobile,
        required this.tripState,
        required this.currentRoomId,
        required this.createUid,
        required this.writeUid,
        required this.createdAt,
        required this.updatedAt,
        required this.vehicle,
    });

    factory TripHistory.fromRawJson(String str) => TripHistory.fromJson(json.decode(str));

    factory TripHistory.fromJson(Map<String, dynamic> json) => TripHistory(
        id: json['id'],
        userId: json['userId'],
        driverUserId: json['driverUserId'],
        pickupLocation: Location.fromJson(json['pickupLocation']),
        dropoffLocations: List<Location>.from(json['dropoffLocations'].map((x) => Location.fromJson(x))),
        paymentMethod: json['paymentMethod'],
        requestType: json['requestType'],
        offer: json['offer'],
        tripDetail: json['tripDetail'],
        tripType: json['tripType'],
        tripClass: json['tripClass'],
        vehicleId: json['vehicleId'],
        senderMobile: json['senderMobile'],
        receiverMobile: json['receiverMobile'],
        tripState: json['tripState'],
        currentRoomId: json['currentRoomId'],
        createUid: json['createUid'],
        writeUid: json['writeUid'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        vehicle: json['vehicle'],
    );
    final dynamic id;
    final dynamic userId;
    final dynamic driverUserId;
    final Location pickupLocation;
    final List<Location> dropoffLocations;
    final dynamic paymentMethod;
    final dynamic requestType;
    final dynamic offer;
    final dynamic tripDetail;
    final dynamic tripType;
    final dynamic tripClass;
    final dynamic vehicleId;
    final dynamic senderMobile;
    final dynamic receiverMobile;
    final dynamic tripState;
    final dynamic currentRoomId;
    final dynamic createUid;
    final dynamic writeUid;
    final DateTime createdAt;
    final DateTime updatedAt;
    final dynamic vehicle;

    String toRawJson() => json.encode(toJson());

    Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'driverUserId': driverUserId,
        'pickupLocation': pickupLocation.toJson(),
        'dropoffLocations': List<dynamic>.from(dropoffLocations.map((x) => x.toJson())),
        'paymentMethod': paymentMethod,
        'requestType': requestType,
        'offer': offer,
        'tripDetail': tripDetail,
        'tripType': tripType,
        'tripClass': tripClass,
        'vehicleId': vehicleId,
        'senderMobile': senderMobile,
        'receiverMobile': receiverMobile,
        'tripState': tripState,
        'currentRoomId': currentRoomId,
        'createUid': createUid,
        'writeUid': writeUid,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'vehicle': vehicle,
    };
}

class Location {

    Location({
        required this.lat,
        required this.lng,
        required this.name,
        required this.sequence,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json['lat']?.toDouble(),
        lng: json['lng']?.toDouble(),
        name: json['name'],
        sequence: json['sequence'],
    );

    factory Location.fromRawJson(String str) => Location.fromJson(json.decode(str));
    final double lat;
    final double lng;
    final String name;
    final int sequence;

    String toRawJson() => json.encode(toJson());

    Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
        'name': name,
        'sequence': sequence,
    };
}
