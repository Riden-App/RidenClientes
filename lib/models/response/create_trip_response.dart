import 'dart:convert';

class TripCreateResponse {
  final String status;
  final DataCreateTrip data;

  TripCreateResponse({
    required this.status,
    required this.data,
  });

  factory TripCreateResponse.fromRawJson(String str) =>
      TripCreateResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TripCreateResponse.fromJson(Map<String, dynamic> json) =>
      TripCreateResponse(
        status: json['status'],
        data: DataCreateTrip.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
      };
}

class DataCreateTrip {
  final String id;
  final int userId;
  final dynamic driverUserId;
  final LocationCreate pickupLocation;
  final List<LocationCreate> dropoffLocations;
  final String paymentMethod;
  final String requestType;
  final int offer;
  final String tripDetail;
  final String tripType;
  final String tripClass;
  final String tripState;
  final dynamic senderMobile;
  final dynamic receiverMobile;

  DataCreateTrip({
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
    required this.tripState,
    required this.senderMobile,
    required this.receiverMobile,
  });

  factory DataCreateTrip.fromRawJson(String str) => DataCreateTrip.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataCreateTrip.fromJson(Map<String, dynamic> json) => DataCreateTrip(
        id: json['id'],
        userId: json['userId'],
        driverUserId: json['driverUserId'],
        pickupLocation: LocationCreate.fromJson(json['pickupLocation']),
        dropoffLocations: List<LocationCreate>.from(
            json['dropoffLocations'].map((x) => LocationCreate.fromJson(x))),
        paymentMethod: json['paymentMethod'],
        requestType: json['requestType'],
        offer: json['offer'],
        tripDetail: json['tripDetail'],
        tripType: json['tripType'],
        tripClass: json['tripClass'],
        tripState: json['tripState'],
        senderMobile: json['senderMobile'],
        receiverMobile: json['receiverMobile'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'driverUserId': driverUserId,
        'pickupLocation': pickupLocation.toJson(),
        'dropoffLocations':
            List<dynamic>.from(dropoffLocations.map((x) => x.toJson())),
        'paymentMethod': paymentMethod,
        'requestType': requestType,
        'offer': offer,
        'tripDetail': tripDetail,
        'tripType': tripType,
        'tripClass': tripClass,
        'tripState': tripState,
        'senderMobile': senderMobile,
        'receiverMobile': receiverMobile,
      };
}

class LocationCreate {
  final double lat;
  final double lng;
  final String name;
  final int sequence;

  LocationCreate({
    required this.lat,
    required this.lng,
    required this.name,
    required this.sequence,
  });

  factory LocationCreate.fromRawJson(String str) =>
      LocationCreate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LocationCreate.fromJson(Map<String, dynamic> json) => LocationCreate(
        lat: json['lat']?.toDouble(),
        lng: json['lng']?.toDouble(),
        name: json['name'],
        sequence: json['sequence'],
      );

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
        'name': name,
        'sequence': sequence,
      };
}
