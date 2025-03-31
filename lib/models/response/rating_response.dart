import 'dart:convert';

class RatingResponse {
  final String status;
  final DataRatingReponse data;

  RatingResponse({
    required this.status,
    required this.data,
  });

  factory RatingResponse.fromRawJson(String str) =>
      RatingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RatingResponse.fromJson(Map<String, dynamic> json) => RatingResponse(
        status: json['status'],
        data: DataRatingReponse.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
      };
}

class DataRatingReponse {
  final String message;

  DataRatingReponse({
    required this.message,
  });

  factory DataRatingReponse.fromRawJson(String str) =>
      DataRatingReponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataRatingReponse.fromJson(Map<String, dynamic> json) =>
      DataRatingReponse(
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
