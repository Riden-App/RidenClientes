class TripBid {
  TripBid({
    required this.price,
    required this.timeToUser,
    required this.imageUser,
    required this.calification,
    required this.model,
    required this.mark,
  });
  factory TripBid.fromMap(Map<String, String> map) {
    return TripBid(
      price: map['price'] ?? '',
      timeToUser: map['timeToUser'] ?? '',
      imageUser: map['imageUser'] ?? '',
      calification: map['calification'] ?? '',
      model: map['model'] ?? '',
      mark: map['mark'] ?? '',
    );
  }
  final String price;
  final String timeToUser;
  final String imageUser;
  final String calification;
  final String model;
  final String mark;

  Map<String, String> toMap() {
    return {
      'price': price,
      'timeToUser': timeToUser,
      'imageUser': imageUser,
      'calification': calification,
      'model': model,
      'mark': mark,
    };
  }
}
