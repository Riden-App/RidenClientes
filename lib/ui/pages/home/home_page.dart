import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_usuario/blocs/blocs.dart';
import 'package:ride_usuario/enums/enums.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/services/socket_service.dart';
import 'package:ride_usuario/services/trip_socket_service.dart';
import 'package:ride_usuario/ui/pages/home/view/accept_trip.dart';
import 'package:ride_usuario/ui/pages/home/view/arrive_stop_trip.dart';
import 'package:ride_usuario/ui/pages/home/view/finish_trip.dart';
import 'package:ride_usuario/ui/pages/home/view/inprogress_trip.dart';
import 'package:ride_usuario/ui/pages/home/view/resume_trip.dart';
import 'package:ride_usuario/ui/pages/home/view/searching_driver_trip.dart';
import 'package:ride_usuario/ui/pages/home/view/searching_drivers_bid.dart';
import 'package:ride_usuario/ui/pages/home/view/views.dart';
import 'package:ride_usuario/ui/pages/home/view/waiting_user_trip.dart';
import 'package:ride_usuario/ui/pages/home/widgets/btn_menu.dart';
import 'package:ride_usuario/ui/pages/pages.dart';
import 'package:ride_usuario/ui/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class PermissionPage extends StatelessWidget {
  const PermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingPage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late LocationBloc locationBloc;
  SocketService socketService = SocketService();
  TripSocketService tripSocketService = TripSocketService();
  PreferenciasUsuario prefs = PreferenciasUsuario();
  String tripBidId = '';

  final DraggableScrollableController scrollController =
      DraggableScrollableController();
  final DraggableScrollableController scrollControllerSearching =
      DraggableScrollableController();
  final DraggableScrollableController scrollControllerSearchingDrivers =
      DraggableScrollableController();
  final DraggableScrollableController scrollControllerAccept =
      DraggableScrollableController();
  final DraggableScrollableController scrollControllerWaiting =
      DraggableScrollableController();
  final DraggableScrollableController scrollControllerResume =
      DraggableScrollableController();
  final DraggableScrollableController scrollControllerStop =
      DraggableScrollableController();
  final DraggableScrollableController scrollControllerInProgress =
      DraggableScrollableController();
  final DraggableScrollableController scrollControllerFinish =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();

    tripSocketService.connectToSocketTrip((data, status) async {
      final mapBloc = BlocProvider.of<MapBloc>(context);

      final tripId = prefs.createTripResponse.data.id;

      final result = await tripService.getDataTrip(tripId);

      if (result.isSuccess) {
        prefs.detailTripResponse = result.data!;
        prefs.totalStops = result.data!.data.dropoffLocations.length;

        setState(() {
          mapBloc.add(ChangeStatusEvent(status));

          if (status == TripStatus.waitingDriversBid) {
            tripBidId = data['data']['tripBidId'];
          }
        });
      }
    });

    locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.startFollowingUser();
  }

  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  void _openMap({required double latitude, required double longitude}) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  void _makePhoneCall(String phoneNumber) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, locationState) {
          if (locationState.lastKnowLocation == null) {
            return const Center(
              child: Text('Espere por favor...'),
            );
          }

          return BlocBuilder<MapBloc, MapState>(
            builder: (context, mapState) {
              Map<String, Polyline> polylines = Map.from(mapState.polylines);
              Map<String, Marker> markers = Map.from(mapState.markers);
              if (!mapState.showMyRoute) {
                polylines.removeWhere((key, value) => key == 'myRoute');
              }

              return SingleChildScrollView(
                child: Stack(
                  children: [
                    MapView(
                      initialLocation: locationState.lastKnowLocation!,
                      polylines: polylines.values.toSet(),
                      markers: markers.values.toSet(),
                    ),
                    Positioned(
                      top: 50,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              BtnMenu(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    mapState.status == TripStatus.searching
                        ? SearchingDriverTrip(
                            scrollController: scrollControllerSearching)
                        : mapState.status == TripStatus.waitingDriversBid
                            ? SearchingDriversBid(
                                scrollController:
                                    scrollControllerSearchingDrivers,
                                tripBidId: tripBidId)
                            : mapState.status == TripStatus.accepted
                                ? AcceptTrip(
                                    scrollController: scrollControllerAccept)
                                : mapState.status == TripStatus.waitingUser
                                    ? WaitingUserTrip(
                                        scrollController:
                                            scrollControllerWaiting)
                                    : mapState.status == TripStatus.arriveStop
                                        ? ArriveStopTrip(
                                            scrollController:
                                                scrollControllerStop)
                                        : mapState.status ==
                                                TripStatus.resumeTrip
                                            ? ResumeTrip(
                                                scrollController:
                                                    scrollControllerResume)
                                            : mapState.status ==
                                                    TripStatus.inProgress
                                                ? InProgressTrip(
                                                    scrollController:
                                                        scrollControllerInProgress)
                                                : mapState.status ==
                                                        TripStatus.completed
                                                    ? CompleteTrip(
                                                        scrollController:
                                                            scrollControllerFinish)
                                                    : SearchTrip(
                                                        scrollController:
                                                            scrollController,
                                                      ),
                    ManualMarket(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
