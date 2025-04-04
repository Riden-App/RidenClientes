import 'dart:convert';

class PlacesDetailResponse {
  PlacesDetailResponse({
    required this.htmlAttributions,
    required this.result,
    required this.status,
  });
  factory PlacesDetailResponse.fromRawJson(String str) =>
      PlacesDetailResponse.fromJson(json.decode(str));

  factory PlacesDetailResponse.fromJson(Map<String, dynamic> json) =>
      PlacesDetailResponse(
        htmlAttributions:
            List<dynamic>.from(json['html_attributions'].map((x) => x)),
        result: Result.fromJson(json['result']),
        status: json['status'],
      );
  final List<dynamic> htmlAttributions;
  final Result result;
  final String status;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'html_attributions': List<dynamic>.from(htmlAttributions.map((x) => x)),
        'result': result.toJson(),
        'status': status,
      };
}

class Result {
  Result({
    required this.addressComponents,
    required this.adrAddress,
    this.businessStatus,
    required this.formattedAddress,
    required this.geometry,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconMaskBaseUri,
    required this.name,
    required this.placeId,
    required this.reference,
    required this.types,
    required this.url,
    required this.utcOffset,
    required this.vicinity,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        addressComponents: List<AddressComponent>.from(
            json['address_components']
                .map((x) => AddressComponent.fromJson(x))),
        adrAddress: json['adr_address'],
        businessStatus: json['business_status'],
        formattedAddress: json['formatted_address'],
        geometry: Geometry.fromJson(json['geometry']),
        icon: json['icon'],
        iconBackgroundColor: json['icon_background_color'],
        iconMaskBaseUri: json['icon_mask_base_uri'],
        name: json['name'],
        placeId: json['place_id'],
        reference: json['reference'],
        types: List<String>.from(json['types'].map((x) => x)),
        url: json['url'],
        utcOffset: json['utc_offset'],
        vicinity: json['vicinity'],
      );
  final List<AddressComponent> addressComponents;
  final String adrAddress;
  final String? businessStatus;
  final String formattedAddress;
  final Geometry geometry;
  final String icon;
  final String iconBackgroundColor;
  final String iconMaskBaseUri;
  final String name;
  final String placeId;
  final String reference;
  final List<String> types;
  final String url;
  final int utcOffset;
  final String vicinity;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'address_components':
            List<dynamic>.from(addressComponents.map((x) => x.toJson())),
        'adr_address': adrAddress,
        'business_status': businessStatus,
        'formatted_address': formattedAddress,
        'geometry': geometry.toJson(),
        'icon': icon,
        'icon_background_color': iconBackgroundColor,
        'icon_mask_base_uri': iconMaskBaseUri,
        'name': name,
        'place_id': placeId,
        'reference': reference,
        'types': List<dynamic>.from(types.map((x) => x)),
        'url': url,
        'utc_offset': utcOffset,
        'vicinity': vicinity,
      };

  @override
  String toString() =>
      'Result: ${geometry.location.lat}, ${geometry.location.lng}';
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

class Geometry {
  Geometry({
    required this.location,
    required this.viewport,
  });

  factory Geometry.fromRawJson(String str) =>
      Geometry.fromJson(json.decode(str));

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: Location.fromJson(json['location']),
        viewport: Viewport.fromJson(json['viewport']),
      );
  final Location location;
  final Viewport viewport;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'location': location.toJson(),
        'viewport': viewport.toJson(),
      };
}

class Location {
  Location({
    required this.lat,
    required this.lng,
  });

  factory Location.fromRawJson(String str) =>
      Location.fromJson(json.decode(str));

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json['lat'].toDouble(),
        lng: json['lng'].toDouble(),
      );
  final double lat;
  final double lng;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };
}

class Viewport {
  Viewport({
    required this.northeast,
    required this.southwest,
  });

  factory Viewport.fromRawJson(String str) =>
      Viewport.fromJson(json.decode(str));

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: Location.fromJson(json['northeast']),
        southwest: Location.fromJson(json['southwest']),
      );
  final Location northeast;
  final Location southwest;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'northeast': northeast.toJson(),
        'southwest': southwest.toJson(),
      };
}
