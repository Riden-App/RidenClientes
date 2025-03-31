import 'dart:convert';

class DetailTripResponse {
  final String status;
  final Data data;

  DetailTripResponse({
    required this.status,
    required this.data,
  });

  factory DetailTripResponse.fromRawJson(String str) =>
      DetailTripResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DetailTripResponse.fromJson(Map<String, dynamic> json) =>
      DetailTripResponse(
        status: json['status'],
        data: Data.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
      };
}

class Data {
  final String id;
  final int userId;
  final UserResponse? user;
  final dynamic driverUserId;
  final UserResponse? driverUser;
  final VehicleData? vehicle;
  final Location? pickupLocation;
  final List<Location> dropoffLocations;
  final String paymentMethod;
  final String requestType;
  final num offer;
  final num amount;
  final String tripDetail;
  final dynamic roomId;
  final String tripType;
  final String tripClass;
  final String tripState;
  final String? senderMobile;
  final String? receiverMobile;

  Data({
    required this.id,
    required this.userId,
    this.user,
    required this.driverUserId,
    this.driverUser,
    this.vehicle,
    this.pickupLocation,
    required this.dropoffLocations,
    required this.paymentMethod,
    required this.requestType,
    required this.offer,
    required this.amount,
    required this.tripDetail,
    this.roomId,
    required this.tripType,
    required this.tripClass,
    required this.tripState,
    this.senderMobile,
    this.receiverMobile,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'] ?? '',
        userId: json['userId'] ?? 0,
        user: json['user'] != null ? UserResponse.fromJson(json['user']) : null,
        driverUserId: json['driverUserId'] ?? 0,
        driverUser: json['driverUser'] != null
            ? UserResponse.fromJson(json['driverUser'])
            : null,
        vehicle: json['vehicle'] != null
            ? VehicleData.fromJson(json['vehicle'])
            : null,
        pickupLocation: json['pickupLocation'] != null
            ? Location.fromJson(json['pickupLocation'])
            : null,
        dropoffLocations: json['dropoffLocations'] != null
            ? List<Location>.from(
                json['dropoffLocations'].map((x) => Location.fromJson(x)))
            : [],
        paymentMethod: json['paymentMethod'] ?? '',
        requestType: json['requestType'] ?? '',
        offer: json['offer'] ?? 0,
        amount: json['amount'] ?? 0,
        tripDetail: json['tripDetail'] ?? '',
        roomId: json['roomId'],
        tripType: json['tripType'] ?? '',
        tripClass: json['tripClass'] ?? '',
        tripState: json['tripState'] ?? '',
        senderMobile: json['senderMobile'],
        receiverMobile: json['receiverMobile'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'user': user?.toJson(),
        'driverUserId': driverUserId,
        'driverUser': driverUser?.toJson(),
        'vehicle': vehicle?.toJson(),
        'pickupLocation': pickupLocation?.toJson(),
        'dropoffLocations': dropoffLocations.map((x) => x.toJson()).toList(),
        'paymentMethod': paymentMethod,
        'requestType': requestType,
        'offer': offer,
        'amount': amount,
        'tripDetail': tripDetail,
        'roomId': roomId,
        'tripType': tripType,
        'tripClass': tripClass,
        'tripState': tripState,
        'senderMobile': senderMobile,
        'receiverMobile': receiverMobile,
      };
}

class UserResponse {
  final int id;
  final String mobile;
  final String email;
  final String firstName;
  final String lastName;
  final dynamic latitude;
  final dynamic longitude;
  final List<String> userRoles;
  final double ratingAveragePassenger;
  final double ratingAverageDriver;
  final String? profilePictureUrl;

  UserResponse({
    required this.id,
    required this.mobile,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.latitude,
    required this.longitude,
    required this.userRoles,
    required this.ratingAveragePassenger,
    required this.ratingAverageDriver,
    this.profilePictureUrl,
  });

  factory UserResponse.fromRawJson(String str) => UserResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        id: json['id'],
        mobile: json['mobile'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        userRoles: List<String>.from(json['userRoles'].map((x) => x)),
        ratingAveragePassenger:
            double.parse(json['ratingAveragePassenger'].toString()) ?? 0,
        ratingAverageDriver:
            double.parse(json['ratingAverageDriver'].toString()) ?? 0,
        profilePictureUrl: json['profilePictureUrl'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'mobile': mobile,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'latitude': latitude,
        'longitude': longitude,
        'userRoles': List<dynamic>.from(userRoles.map((x) => x)),
        'ratingAveragePassenger': ratingAveragePassenger,
        'ratingAverageDriver': ratingAverageDriver,
        'profilePictureUrl': profilePictureUrl,
      };
}

class Location {
  final double lat;
  final double lng;
  final String name;
  final int sequence;

  Location({
    required this.lat,
    required this.lng,
    required this.name,
    required this.sequence,
  });

  factory Location.fromRawJson(String str) =>
      Location.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json['lat']?.toDouble() ?? 0.0,
        lng: json['lng']?.toDouble() ?? 0.0,
        name: json['name'] ?? '',
        sequence: json['sequence'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
        'name': name,
        'sequence': sequence,
      };
}

class VehicleData {
  final int id;
  final int userId;
  final String vehicleColor;
  final String vehicleType;
  final int vehicleModelId;
  final int vehicleMakeId;
  final int year;
  final String vehiclePhotoUrl;
  final String insuranceTrafficAccidentsUrl;
  final String plateNumber;
  final List<String> tripClasses;
  final String state;
  final int createUid;
  final int writeUid;
  final dynamic createdAt;
  final dynamic updatedAt;

  VehicleData({
    required this.id,
    required this.userId,
    required this.vehicleColor,
    required this.vehicleType,
    required this.vehicleModelId,
    required this.vehicleMakeId,
    required this.year,
    required this.vehiclePhotoUrl,
    required this.insuranceTrafficAccidentsUrl,
    required this.plateNumber,
    required this.tripClasses,
    required this.state,
    required this.createUid,
    required this.writeUid,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VehicleData.fromRawJson(String str) =>
      VehicleData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VehicleData.fromJson(Map<String, dynamic> json) => VehicleData(
        id: json['id'],
        userId: json['userId'],
        vehicleColor: json['vehicleColor'],
        vehicleType: json['vehicleType'],
        vehicleModelId: json['vehicleModelId'],
        vehicleMakeId: json['vehicleMakeId'],
        year: json['year'],
        vehiclePhotoUrl: json['vehiclePhotoUrl'],
        insuranceTrafficAccidentsUrl: json['insuranceTrafficAccidentsUrl'],
        plateNumber: json['plateNumber'],
        tripClasses: List<String>.from(json['tripClasses'].map((x) => x)),
        state: json['state'],
        createUid: json['createUid'],
        writeUid: json['writeUid'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'vehicleColor': vehicleColor,
        'vehicleType': vehicleType,
        'vehicleModelId': vehicleModelId,
        'vehicleMakeId': vehicleMakeId,
        'year': year,
        'vehiclePhotoUrl': vehiclePhotoUrl,
        'insuranceTrafficAccidentsUrl': insuranceTrafficAccidentsUrl,
        'plateNumber': plateNumber,
        'tripClasses': List<dynamic>.from(tripClasses.map((x) => x)),
        'state': state,
        'createUid': createUid,
        'writeUid': writeUid,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
