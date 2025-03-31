class Trip {
  Trip({
    required this.methodPayment,
    required this.price,
    required this.timeToUser,
    required this.imageUser,
    required this.calification,
    required this.typeTrip,
    required this.timeToDestination,
    required this.origin,
    required this.destination,
    required this.details,
  });
  factory Trip.fromMap(Map<String, String> map) {
    return Trip(
      methodPayment: map['methodPayment'] ?? '',
      price: map['price'] ?? '',
      timeToUser: map['timeToUser'] ?? '',
      imageUser: map['imageUser'] ?? '',
      calification: map['calification'] ?? '',
      typeTrip: map['typeTrip'] ?? '',
      timeToDestination: map['timeToDestination'] ?? '',
      origin: map['Origin'] ?? '',
      destination: map['Destination'] ?? '',
      details: map['details'] ?? '',
    );
  }
  final String methodPayment;
  final String price;
  final String timeToUser;
  final String imageUser;
  final String calification;
  final String typeTrip;
  final String timeToDestination;
  final String origin;
  final String destination;
  final String details;

  Map<String, String> toMap() {
    return {
      'methodPayment': methodPayment,
      'price': price,
      'timeToUser': timeToUser,
      'imageUser': imageUser,
      'calification': calification,
      'typeTrip': typeTrip,
      'timeToDestination': timeToDestination,
      'Origin': origin,
      'Destination': destination,
      'details': details,
    };
  }
}
