import 'dart:convert';

class PlacesResponse {
  PlacesResponse({
    required this.predictions,
    required this.status,
  });

  factory PlacesResponse.fromRawJson(String str) =>
      PlacesResponse.fromJson(json.decode(str));

  factory PlacesResponse.fromJson(Map<String, dynamic> json) => PlacesResponse(
        predictions: List<Prediction>.from(
            json['predictions'].map((x) => Prediction.fromJson(x))),
        status: json['status'],
      );
  final List<Prediction> predictions;
  final String status;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'predictions': List<dynamic>.from(predictions.map((x) => x.toJson())),
        'status': status,
      };
}

class Prediction {
  Prediction({
    required this.description,
    required this.matchedSubstrings,
    required this.placeId,
    required this.reference,
    required this.structuredFormatting,
  });

  factory Prediction.fromRawJson(String str) =>
      Prediction.fromJson(json.decode(str));

  factory Prediction.fromJson(Map<String, dynamic> json) => Prediction(
        description: json['description'],
        matchedSubstrings: List<MatchedSubstring>.from(
            json['matched_substrings']
                .map((x) => MatchedSubstring.fromJson(x))),
        placeId: json['place_id'],
        reference: json['reference'],
        structuredFormatting:
            StructuredFormatting.fromJson(json['structured_formatting']),
      );
  final String description;
  final List<MatchedSubstring> matchedSubstrings;
  final String placeId;
  final String reference;
  final StructuredFormatting structuredFormatting;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'description': description,
        'matched_substrings':
            List<dynamic>.from(matchedSubstrings.map((x) => x.toJson())),
        'place_id': placeId,
        'reference': reference,
        'structured_formatting': structuredFormatting.toJson(),
      };

  @override
  String toString() {
    return 'Prediction: ${structuredFormatting.mainText}';
  }
}

class MatchedSubstring {
  MatchedSubstring({
    required this.length,
    required this.offset,
  });

  factory MatchedSubstring.fromRawJson(String str) =>
      MatchedSubstring.fromJson(json.decode(str));

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) =>
      MatchedSubstring(
        length: json['length'],
        offset: json['offset'],
      );
  final int length;
  final int offset;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'length': length,
        'offset': offset,
      };
}

class StructuredFormatting {
  StructuredFormatting({
    required this.mainText,
    required this.mainTextMatchedSubstrings,
    required this.secondaryText,
  });

  factory StructuredFormatting.fromRawJson(String str) =>
      StructuredFormatting.fromJson(json.decode(str));

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) =>
      StructuredFormatting(
        mainText: json['main_text'],
        mainTextMatchedSubstrings: List<MatchedSubstring>.from(
            json['main_text_matched_substrings']
                .map((x) => MatchedSubstring.fromJson(x))),
        secondaryText: json['secondary_text'],
      );
  final String mainText;
  final List<MatchedSubstring> mainTextMatchedSubstrings;
  final String secondaryText;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'main_text': mainText,
        'main_text_matched_substrings': List<dynamic>.from(
            mainTextMatchedSubstrings.map((x) => x.toJson())),
        'secondary_text': secondaryText,
      };
}

class Term {
  Term({
    required this.offset,
    required this.value,
  });

  factory Term.fromRawJson(String str) => Term.fromJson(json.decode(str));

  factory Term.fromJson(Map<String, dynamic> json) => Term(
        offset: json['offset'],
        value: json['value'],
      );
  final int offset;
  final String value;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'offset': offset,
        'value': value,
      };
}

enum Type { GEOCODE, POLITICAL, SUBLOCALITY, SUBLOCALITY_LEVEL_1 }

final typeValues = EnumValues({
  'geocode': Type.GEOCODE,
  'political': Type.POLITICAL,
  'sublocality': Type.SUBLOCALITY,
  'sublocality_level_1': Type.SUBLOCALITY_LEVEL_1
});

class EnumValues<T> {
  EnumValues(this.map);
  Map<String, T> map;
  late Map<T, String> reverseMap;

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
