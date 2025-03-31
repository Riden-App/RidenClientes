import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_usuario/blocs/blocs.dart';
import 'package:ride_usuario/enums/enums.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/services/trip_service.dart';
import 'package:ride_usuario/services/trip_socket_service.dart';
import 'package:ride_usuario/themes/themes.dart';

import '/utils/button.dart' as btn;

class SearchingDriversBid extends StatelessWidget {
  const SearchingDriversBid(
      {super.key, required this.scrollController, required this.tripBidId});
  final DraggableScrollableController scrollController;
  final String tripBidId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMarket
            ? const SizedBox()
            : FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: _SearchingDriversBid(
                    scrollController: scrollController, tripBidId: tripBidId));
      },
    );
  }
}

class _SearchingDriversBid extends StatefulWidget {
  const _SearchingDriversBid(
      {super.key, required this.scrollController, required this.tripBidId});

  final DraggableScrollableController scrollController;
  final String tripBidId;

  @override
  State<_SearchingDriversBid> createState() => _SearchingDriversBidState();
}

class _SearchingDriversBidState extends State<_SearchingDriversBid>
    with SingleTickerProviderStateMixin {
  double contentHeight = 0;
  bool fastDrive = false;
  bool isViajeActive = true;
  TripService tripService = TripService();
  GlobalKey contentKey = GlobalKey();
  PreferenciasUsuario prefs = PreferenciasUsuario();

  late AnimationController _controller;

  final List<Map<String, dynamic>> items = [];
  TripSocketService tripSocketService = TripSocketService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderObject = contentKey.currentContext?.findRenderObject();
      if (renderObject != null && renderObject is RenderBox) {
        setState(() {
          contentHeight = renderObject.size.height;
        });
      }
    });
    drawFirstBid();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 16))
          ..forward();

    TripSocketService tripSocketService = TripSocketService();

    tripSocketService.connectToSocketTrip((data, status) async {
      if (status == TripStatus.waitingDriversBid) {
        final response =
            await tripService.getDataBidTrip(data['data']['tripBidId']);

        if (response.isSuccess) {
          final data = response.data;
          setState(() {
            items.add(data!.data.toJson());
          });
        }
      } else {
        final mapBloc = BlocProvider.of<MapBloc>(context);

        final tripId = prefs.createTripResponse.data.id;

        final result = await tripService.getDataTrip(tripId);

        if (result.isSuccess) {
          prefs.detailTripResponse = result.data!;
          prefs.totalStops = result.data!.data.dropoffLocations.length;

          setState(() {
            mapBloc.add(ChangeStatusEvent(status));
          });
        }
      }
    });
  }

  Future<void> drawFirstBid() async {
    final response = await tripService.getDataBidTrip(widget.tripBidId);

    if (response.isSuccess) {
      final data = response.data;

      setState(() {
        items.add(data!.data.toJson());
      });
    } else {
      print('error en obtener respuesta bid');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void cancelTrip() async {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final result = await tripService.updateStatusTrip(
        'CANCEL', prefs.detailTripResponse.data.id);
    if (result.isSuccess) {
      mapBloc.add(ChangeStatusEvent(TripStatus.none));
    } else {
      print('Error al cambiar el estado del viaje: ${result.error}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: DraggableScrollableSheet(
        controller: widget.scrollController,
        initialChildSize: 0.43,
        minChildSize: 0.15,
        maxChildSize: 0.9,
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 6,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      separatorBuilder: (context, index) => SizedBox(
                        height: 12,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final trip = items[index];
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.black03,
                            ),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: AppColors.black10,
                                        borderRadius: BorderRadius.circular(
                                          50,
                                        ),
                                      ),
                                    ),
                                    AnimatedBuilder(
                                      animation: _controller,
                                      builder: (context, child) {
                                        return Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            height: 5,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                (1 - _controller.value),
                                            decoration: BoxDecoration(
                                              color: AppColors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                50,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text: 'S/${trip['offer']} ',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.black,
                                                ),
                                              ),
                                            ]),
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            '5 min',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.black,
                                            ),
                                          ),
                                          Text(
                                            'Toyota Corolla',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.black60,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          alignment: Alignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.network(
                                                'https://i0.wp.com/lamiradafotografia.es/wp-content/uploads/2014/07/foto-perfil-psicologo-180x180.jpg?resize=180%2C180',
                                                width: 45,
                                                height: 45,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              bottom: -20,
                                              child: Container(
                                                width: 53,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4, vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                      color: Colors.black12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 4,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                      size: 16,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      '4.5', // Aquí puedes cambiar la calificación
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 17,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: btn.button(
                                        label: 'Rechazar',
                                        onPressed: () {},
                                        type: 'gray',
                                        textColorApp: AppColors.black,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: btn.button(
                                          label: 'Aceptar',
                                          onPressed: () async {
                                            final resultUpdateStatus =
                                                await tripService
                                                    .updateStatusTripOffer(
                                                        'ACCEPT',
                                                        trip['tripId'],
                                                        trip['id']);
                                            if (resultUpdateStatus.isSuccess) {
                                              final mapBloc =
                                                  BlocProvider.of<MapBloc>(
                                                      context);

                                              final tripId = prefs
                                                  .createTripResponse.data.id;

                                              final result = await tripService
                                                  .getDataTrip(tripId);

                                              if (result.isSuccess) {
                                                prefs.detailTripResponse =
                                                    result.data!;
                                                prefs.totalStops = result
                                                    .data!
                                                    .data
                                                    .dropoffLocations
                                                    .length;

                                                setState(() {
                                                  mapBloc.add(ChangeStatusEvent(
                                                      TripStatus.accepted));
                                                });
                                              }
                                            } else {
                                              print(
                                                  'Error al cambiar el estado del viaje: ${resultUpdateStatus.error}');
                                            }
                                          },
                                          type: 'black'),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  btn.button(
                      label: 'Cancelar viaje',
                      onPressed: cancelTrip,
                      type: 'gray',
                      textColorApp: AppColors.red),
                  SizedBox(height: 15),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
