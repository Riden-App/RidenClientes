class Location {
  double lat;
  double lng;
  String name;
  int sequence;

  Location({
    required this.lat,
    required this.lng,
    required this.name,
    required this.sequence,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'],
      lng: json['lng'],
      name: json['name'],
      sequence: json['sequence'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'name': name,
      'sequence': sequence,
    };
  }
}

class TripRequest {
  Location pickupLocation;
  List<Location> dropoffLocations;
  String paymentMethod;
  String requestType;
  int offer;
  String tripDetail;
  String tripType;
  String vehicleType;
  String senderMobile;
  String receiverMobile;

  TripRequest({
    required this.pickupLocation,
    required this.dropoffLocations,
    required this.paymentMethod,
    required this.requestType,
    required this.offer,
    required this.tripDetail,
    required this.tripType,
    required this.vehicleType,
    required this.senderMobile,
    required this.receiverMobile,
  });

  factory TripRequest.fromJson(Map<String, dynamic> json) {
    return TripRequest(
      pickupLocation: Location.fromJson(json['pickupLocation']),
      dropoffLocations: (json['dropoffLocations'] as List)
          .map((i) => Location.fromJson(i))
          .toList(),
      paymentMethod: json['paymentMethod'],
      requestType: json['requestType'],
      offer: json['offer'],
      tripDetail: json['tripDetail'],
      tripType: json['tripType'],
      vehicleType: json['vehicleType'],
      senderMobile: json['senderMobile'],
      receiverMobile: json['receiverMobile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pickupLocation': pickupLocation.toJson(),
      'dropoffLocations': dropoffLocations.map((i) => i.toJson()).toList(),
      'paymentMethod': paymentMethod,
      'requestType': requestType,
      'offer': offer,
      'tripDetail': tripDetail,
      'tripType': tripType,
      'vehicleType': vehicleType,
      'senderMobile': senderMobile,
      'receiverMobile': receiverMobile,
    };
  }
}
