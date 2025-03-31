import 'dart:convert';

class DetailTripBidResponse {
  final String status;
  final DataTripBid data;

  DetailTripBidResponse({
    required this.status,
    required this.data,
  });

  factory DetailTripBidResponse.fromRawJson(String str) =>
      DetailTripBidResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DetailTripBidResponse.fromJson(Map<String, dynamic> json) =>
      DetailTripBidResponse(
        status: json['status'],
        data: DataTripBid.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
      };
}

class DataTripBid {
  final String id;
  final String tripId;
  final int driverId;
  final int vehicleId;
  final num offer;
  final String state;
  final dynamic createdAt;

  DataTripBid({
    required this.id,
    required this.tripId,
    required this.driverId,
    required this.vehicleId,
    required this.offer,
    required this.state,
    required this.createdAt,
  });

  factory DataTripBid.fromRawJson(String str) =>
      DataTripBid.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataTripBid.fromJson(Map<String, dynamic> json) => DataTripBid(
        id: json['id'] ?? '',
        tripId: json['tripId'] ?? '',
        driverId: json['driverId'] ?? 0,
        vehicleId: json['vehicleId'] ?? 0,
        offer: json['offer'] ?? 0,
        state: json['state'] ?? '',
        createdAt: json['createdAt'] ?? {},
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'tripId': tripId,
        'driverId': driverId,
        'vehicleId': vehicleId,
        'offer': offer,
        'state': state,
        'createdAt': createdAt,
      };
}
