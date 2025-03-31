import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show BitmapDescriptor;

Future<BitmapDescriptor> getImageMarker(String path) async {
  return BitmapDescriptor.asset(
    const ImageConfiguration(
      devicePixelRatio: 1,
    ),
    'assets/img/$path.png',
  );
}
