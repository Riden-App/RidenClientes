import 'dart:convert';

class PriceTripResponse {
    final String status;
    final Data data;

    PriceTripResponse({
        required this.status,
        required this.data,
    });

    factory PriceTripResponse.fromRawJson(String str) => PriceTripResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PriceTripResponse.fromJson(Map<String, dynamic> json) => PriceTripResponse(
        status: json['status'],
        data: Data.fromJson(json['data']),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
    };
}

class Data {
    final num totalDistance;
    final num estimatedTime;
    final num totalFare;
    final String currency;
    final String tripClass;
    final String pickupLocationName;
    final String dropoffLocationName;

    Data({
        required this.totalDistance,
        required this.estimatedTime,
        required this.totalFare,
        required this.currency,
        required this.tripClass,
        required this.pickupLocationName,
        required this.dropoffLocationName,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalDistance: json['totalDistance'],
        estimatedTime: json['estimatedTime'],
        totalFare: json['totalFare'],
        currency: json['currency'],
        tripClass: json['tripClass'],
        pickupLocationName: json['pickupLocationName'],
        dropoffLocationName: json['dropoffLocationName'],
    );

    Map<String, dynamic> toJson() => {
        'totalDistance': totalDistance,
        'estimatedTime': estimatedTime,
        'totalFare': totalFare,
        'currency': currency,
        'tripClass': tripClass,
        'pickupLocationName': pickupLocationName,
        'dropoffLocationName': dropoffLocationName,
    };


}
