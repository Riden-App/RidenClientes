import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapContainer extends StatefulWidget {
  const MapContainer({
    super.key,
    required this.point1,
    required this.point2,
    required this.height,
    required this.width,
  });
  final LatLng point1;
  final LatLng point2;
  final double height;
  final double width;

  @override
  _MapContainerState createState() => _MapContainerState();
}

class _MapContainerState extends State<MapContainer> {
  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
            child: GoogleMap(
              compassEnabled: false,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0), // Placeholder
                zoom: 0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                _setMapBounds();
              },
              markers: {
                Marker(markerId: MarkerId('point1'), position: widget.point1),
                Marker(markerId: MarkerId('point2'), position: widget.point2),
              },
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: () {
              _showFullScreenMap(context);
            },
          ),
        ),
      ],
    );
  }

  void _setMapBounds() {
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        widget.point1.latitude < widget.point2.latitude
            ? widget.point1.latitude
            : widget.point2.latitude,
        widget.point1.longitude < widget.point2.longitude
            ? widget.point1.longitude
            : widget.point2.longitude,
      ),
      northeast: LatLng(
        widget.point1.latitude > widget.point2.latitude
            ? widget.point1.latitude
            : widget.point2.latitude,
        widget.point1.longitude > widget.point2.longitude
            ? widget.point1.longitude
            : widget.point2.longitude,
      ),
    );

    _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  void _showFullScreenMap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 1.0,
          minChildSize: 0.5,
          maxChildSize: 1.0,
          builder: (_, controller) {
            return ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Container(
                color: Colors.white,
                child: GoogleMap(
                  compassEnabled: false,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(0, 0), // Placeholder
                    zoom: 0,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                    _setMapBounds();
                  },
                  markers: {
                    Marker(
                        markerId: MarkerId('point1'), position: widget.point1),
                    Marker(
                        markerId: MarkerId('point2'), position: widget.point2),
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
