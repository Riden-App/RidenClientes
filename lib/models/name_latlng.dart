import 'dart:convert';

class NameLatLngResponse {
  NameLatLngResponse({
    required this.plusCode,
    required this.results,
    required this.status,
  });

  factory NameLatLngResponse.fromRawJson(String str) =>
      NameLatLngResponse.fromJson(json.decode(str));

  factory NameLatLngResponse.fromJson(Map<String, dynamic> json) =>
      NameLatLngResponse(
        plusCode: PlusCode.fromJson(json['plus_code']),
        results: List<ResultNameLatLng>.from(
            json['results'].map((x) => ResultNameLatLng.fromJson(x))),
        status: json['status'],
      );
  final PlusCode plusCode;
  final List<ResultNameLatLng> results;
  final String status;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'plus_code': plusCode.toJson(),
        'results': List<dynamic>.from(results.map((x) => x.toJson())),
        'status': status,
      };
}

class PlusCode {
  PlusCode({
    required this.compoundCode,
    required this.globalCode,
  });

  factory PlusCode.fromRawJson(String str) =>
      PlusCode.fromJson(json.decode(str));

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
        compoundCode: json['compound_code'],
        globalCode: json['global_code'],
      );
  final String compoundCode;
  final String globalCode;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'compound_code': compoundCode,
        'global_code': globalCode,
      };
}

class ResultNameLatLng {
  ResultNameLatLng({
    required this.addressComponents,
    required this.formattedAddress,
    required this.placeId,
    required this.types,
  });

  factory ResultNameLatLng.fromRawJson(String str) =>
      ResultNameLatLng.fromJson(json.decode(str));

  factory ResultNameLatLng.fromJson(Map<String, dynamic> json) =>
      ResultNameLatLng(
        addressComponents: List<AddressComponent>.from(
            json['address_components']
                .map((x) => AddressComponent.fromJson(x))),
        formattedAddress: json['formatted_address'],
        placeId: json['place_id'],
        types: List<String>.from(json['types'].map((x) => x)),
      );
  final List<AddressComponent> addressComponents;
  final String formattedAddress;
  final String placeId;
  final List<String> types;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'address_components':
            List<dynamic>.from(addressComponents.map((x) => x.toJson())),
        'formatted_address': formattedAddress,
        'place_id': placeId,
        'types': List<dynamic>.from(types.map((x) => x)),
      };
}

class AddressComponent {
  AddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  factory AddressComponent.fromRawJson(String str) =>
      AddressComponent.fromJson(json.decode(str));

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json['long_name'],
        shortName: json['short_name'],
        types: List<String>.from(json['types'].map((x) => x)),
      );
  final String longName;
  final String shortName;
  final List<String> types;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'long_name': longName,
        'short_name': shortName,
        'types': List<dynamic>.from(types.map((x) => x)),
      };
}

class EnumValues<T> {
  EnumValues(this.map);
  Map<String, T> map;
  late Map<T, String> reverseMap;

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
