import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_usuario/blocs/blocs.dart';
import 'package:ride_usuario/enums/enums.dart';
import 'package:ride_usuario/models/waypoints.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/services/traffic_service.dart';
import 'package:ride_usuario/services/trip_service.dart';
import 'package:ride_usuario/services/trip_socket_service.dart';
import 'package:ride_usuario/themes/themes.dart';
import 'package:ride_usuario/ui/pages/home/view/show_waypoints.dart';
import 'package:ride_usuario/ui/pages/home/view/views.dart';
import 'package:ride_usuario/ui/widgets/widgets.dart';

import '/utils/button.dart' as btn;

class SearchTrip extends StatelessWidget {
  const SearchTrip({
    super.key,
    required this.scrollController,
  });
  final DraggableScrollableController scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMarket
            ? const SizedBox()
            : FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: _SearchTrip(scrollController: scrollController));
      },
    );
  }
}

class _SearchTrip extends StatefulWidget {
  const _SearchTrip({
    super.key,
    required this.scrollController,
  });

  final DraggableScrollableController scrollController;

  @override
  State<_SearchTrip> createState() => _SearchTripState();
}

class _SearchTripState extends State<_SearchTrip> {
  double contentHeight = 0;
  bool fastDrive = false;
  bool isViajeActive = true;
  GlobalKey contentKey = GlobalKey();
  final PreferenciasUsuario _prefs = PreferenciasUsuario();
  final TripService tripService = TripService();
  TripSocketService tripSocketService = TripSocketService();
  String tripBidId = '';

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final renderObject = contentKey.currentContext?.findRenderObject();
  //     if (renderObject != null && renderObject is RenderBox) {
  //       setState(() {
  //         contentHeight = renderObject.size.height;
  //       });
  //     }
  //   });
  //   super.initState();
  //   tripSocketService.connectToSocketTrip((data, status) async {
  //
  //     final mapBloc = BlocProvider.of<MapBloc>(context);

  //     final tripId = prefs.createTripResponse.data.id;

  //     final result = await tripService.getDataTrip(tripId);

  //     if (result.isSuccess) {
  //       prefs.detailTripResponse = result.data!;

  //       setState(() {
  //         mapBloc.add(ChangeStatusEvent(status));

  //         if (status == TripStatus.waitingDriversBid) {
  //           tripBidId = data['data']['tripBidId'];
  //
  //         }
  //       });
  //     }
  //   });
  // }

  Future<void> _onSolicitarAuto() async {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    List<Waypoint> waypoints = mapBloc.state.waypoints;

    List<Map<String, dynamic>> waypointsWithSequence = [];

    for (int i = 0; i < waypoints.length; i++) {
      waypointsWithSequence.add({
        'name': waypoints[i].name,
        'lat': waypoints[i].lat,
        'lng': waypoints[i].lng,
        'sequence': i + 1,
      });
    }

    waypointsWithSequence.add({
      'name': mapBloc.state.destinationPoint!.name,
      'lat': mapBloc.state.destinationPoint!.lat,
      'lng': mapBloc.state.destinationPoint!.lng,
      'sequence': waypoints.length + 1,
    });

    final pickupLocation = {
      'name': mapBloc.state.originPoint!.name,
      'lat': mapBloc.state.originPoint!.lat,
      'lng': mapBloc.state.originPoint!.lng,
      'sequence': 0,
    };

    final result = await tripService.createTrip(
      requestType: fastDrive,
      dropoffLocations: waypointsWithSequence,
      pickupLocation: pickupLocation,
    );

    if (result.isSuccess) {
      _prefs.createTripResponse = result.data!;
      mapBloc.add(ChangeStatusEvent(TripStatus.searching));
    } else {
      print('Error al enviar la solicitud');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    const maxSize = 0.6;

    Future<void> drawRoute(
        Waypoint origin, Waypoint destination, List<Waypoint> waypoints) async {
      final searchPolylines =
          await searchBloc.getCoorsStartToEnd(origin, destination, waypoints);
      await mapBloc.drawRoutePolyline(searchPolylines, waypoints);
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: DraggableScrollableSheet(
        controller: widget.scrollController,
        initialChildSize: 0.2,
        minChildSize: 0.1,
        maxChildSize: maxSize,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            key: contentKey,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 6,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          SwitchTypeTrip(
                            isViajeActive: isViajeActive,
                            onChanged: (bool newValue) {
                              setState(() {
                                isViajeActive = newValue;
                              });
                            },
                          ),
                          SizedBox(height: 26),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 19.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Pide un Ride',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDetailTripBottomSheet(context);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: AppColors.black04,
                                    child: SvgPicture.asset(
                                      'assets/img/page_info.svg',
                                      colorFilter: ColorFilter.mode(
                                          AppColors.black, BlendMode.srcIn),
                                      width: 10,
                                      height: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 22),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 19.0),
                            child: btn.buttonWhitIconTrip(
                                label: _prefs.lugarInicio.isEmpty
                                    ? 'Desde'
                                    : _prefs.lugarInicio,
                                onPressed: () {
                                  showSearchBottomSheet(
                                    context,
                                    TypeMarket.origin,
                                  );
                                },
                                icon: CircleAvatar(
                                    backgroundColor: AppColors.blue15,
                                    child: SvgPicture.asset(
                                      'assets/img/arrow_warm_up.svg',
                                      colorFilter: ColorFilter.mode(
                                          AppColors.blue, BlendMode.srcIn),
                                      width: 10,
                                      height: 16,
                                    ))),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 19.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: btn.buttonWhitIconTrip(
                                      label: mapBloc.state.waypoints.isNotEmpty
                                          ? '${mapBloc.state.waypoints.length + 1} destinos'
                                          : _prefs.lugarFin.isEmpty
                                              ? 'Hacia'
                                              : _prefs.lugarFin,
                                      onPressed: () async {
                                        if (mapBloc
                                            .state.waypoints.isNotEmpty) {
                                          TrafficService placesService =
                                              TrafficService();

                                          final mapBloc =
                                              BlocProvider.of<MapBloc>(context);

                                          final destinationLatLng =
                                              mapBloc.state.destinationPoint;
                                          final destinationName =
                                              await placesService
                                                  .getNameByLatLng(LatLng(
                                                      destinationLatLng!.lat,
                                                      destinationLatLng.lng));

                                          showWaypointsBottomSheet(
                                            context,
                                            destinationName,
                                          );
                                        } else {
                                          showSearchBottomSheet(
                                            context,
                                            TypeMarket.destination,
                                          );
                                        }
                                      },
                                      icon: CircleAvatar(
                                          backgroundColor: AppColors.green15,
                                          child: SvgPicture.asset(
                                            'assets/img/arrow_cool_down.svg',
                                            colorFilter: ColorFilter.mode(
                                                AppColors.green,
                                                BlendMode.srcIn),
                                            width: 10,
                                            height: 16,
                                          ))),
                                ),
                                SizedBox(
                                  width:
                                      mapBloc.state.destinationPoint != null &&
                                              mapBloc.state.waypoints.length < 3
                                          ? 15
                                          : 0,
                                ),
                                mapBloc.state.destinationPoint != null &&
                                        mapBloc.state.waypoints.length < 3
                                    ? GestureDetector(
                                        onTap: () {
                                          showSearchBottomSheet(
                                            context,
                                            TypeMarket.waypoints,
                                          );
                                        },
                                        child: CircleAvatar(
                                            backgroundColor: AppColors.black04,
                                            minRadius: 20,
                                            child: SvgPicture.asset(
                                              'assets/img/addLocation.svg',
                                              colorFilter: ColorFilter.mode(
                                                  AppColors.black,
                                                  BlendMode.srcIn),
                                              width: 17,
                                              height: 20,
                                            )),
                                      )
                                    : SizedBox()
                              ],
                            ),
                          ),
                          SizedBox(height: !isViajeActive ? 10 : 0),
                          !isViajeActive
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 19.0),
                                  child: btn.buttonWhitIconTrip(
                                      label: 'Datos de los Usuarios',
                                      onPressed: () {},
                                      icon: Container(
                                        padding: EdgeInsets.all(3),
                                        child: Icon(
                                          Icons.phone_android_sharp,
                                          color: Color(0xff0D0D0D)
                                              .withOpacity(0.25),
                                        ),
                                      )),
                                )
                              : SizedBox(),
                          SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 19.0),
                            child: btn.buttonWhitIconTrip(
                                label:
                                    'S/${_prefs.oferta} · ${_prefs.categoryTrip} · ${_prefs.kmTrip} km',
                                onPressed: () {
                                  showAmountPaymentMethodBottomSheet(
                                    context,
                                    fastDrive,
                                  );
                                },
                                icon: Container(
                                  padding: EdgeInsets.all(3),
                                  child: Icon(
                                    Icons.credit_card_rounded,
                                    color: Color(0xff0D0D0D).withOpacity(0.25),
                                  ),
                                )),
                          ),
                          SizedBox(height: 23),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/img/fast_drive.png'),
                              SizedBox(width: 10),
                              Text(
                                'Fast Drive',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff0D0D0D)),
                              ),
                              SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    fastDrive = !fastDrive;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  width: 52,
                                  height: 30,
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: fastDrive
                                          ? Colors.blue
                                          : AppColors.black10),
                                  child: Stack(
                                    children: [
                                      AnimatedPositioned(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                        left: fastDrive ? 20 : 0,
                                        right: fastDrive ? 0 : 20,
                                        child: Container(
                                          width: 23,
                                          height: 23,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 26),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: btn.button(
                                label: 'Solicitar auto',
                                onPressed: () => _onSolicitarAuto(),
                                type: 'black'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
