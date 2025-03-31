class Waypoint {
  Waypoint({required this.name, required this.lat, required this.lng});
  final String name;
  final double lat;
  final double lng;

  @override
  String toString() {
    return 'Waypoint(name: $name, lat: $lat, lng: $lng)';
  }
}
