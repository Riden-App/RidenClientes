import 'package:url_launcher/url_launcher.dart';

void openMap({required double latitude, required double longitude}) async {
  final String googleMapsUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

  if (await canLaunch(googleMapsUrl)) {
    await launch(googleMapsUrl);
  } else {
    throw 'Could not open the map.';
  }
}

void makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  if (await canLaunch(launchUri.toString())) {
    await launch(launchUri.toString());
  } else {
    throw 'Could not launch $phoneNumber';
  }
}

String generateGoogleMapsLink(
    double startLat, double startLng, double endLat, double endLng) {
  return 'https://www.google.com/maps/dir/?api=1&origin=$startLat,$startLng&destination=$endLat,$endLng&travelmode=driving';
}

void shareTrip(
    {required double startLat,
    required double startLng,
    required double endLat,
    required double endLng}) async {
  final String googleMapsUrl =
      'https://www.google.com/maps/dir/?api=1&origin=$startLat,$startLng&destination=$endLat,$endLng&travelmode=driving';

  if (await canLaunch(googleMapsUrl)) {
    await launch(googleMapsUrl);
  } else {
    throw 'Could not open the map.';
  }
}
