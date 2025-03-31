import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:ride_usuario/blocs/blocs.dart';
import 'package:ride_usuario/enums/enums.dart';
import 'package:ride_usuario/models/waypoints.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/services/traffic_service.dart';

import '/utils/button.dart' as btn;

class ManualMarket extends StatelessWidget {
  const ManualMarket({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMarket
            ? _ManualMarketBody()
            : const SizedBox();
      },
    );
  }
}

class _ManualMarketBody extends StatelessWidget {
  const _ManualMarketBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final PreferenciasUsuario prefs = PreferenciasUsuario();

    Future<void> drawRoute(
        Waypoint origin, Waypoint destination, List<Waypoint> waypoints) async {
      final searchPolylines =
          await searchBloc.getCoorsStartToEnd(origin, destination, waypoints);
      await mapBloc.drawRoutePolyline(searchPolylines, waypoints);
    }

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Positioned(top: 70, left: 20, child: _BtnBack()),
          Center(
            child: Transform.translate(
              offset: const Offset(0, -22),
              child: BounceInDown(
                from: 100,
                child: Icon(
                  Icons.location_on_rounded,
                  size: 60,
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 70,
              child: FadeInUp(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: size.width,
                  child: btn.button(
                      label: 'Confirmar ubicación',
                      onPressed: () async {
                        final placesService = TrafficService();

                        final center = mapBloc.mapCenter;
                        final waypointsBefore = mapBloc.state.waypoints;

                        if (center == null) {
                          return;
                        }
                        final resp =
                            await placesService.getNameByLatLng(center);

                        if (searchBloc.state.typeMarket == TypeMarket.origin) {
                          final originWaypoint = Waypoint(
                            name: resp,
                            lat: center.latitude,
                            lng: center.longitude,
                          );

                          if (mapBloc.state.destinationPoint != null) {
                            final destination = mapBloc.state.destinationPoint!;

                            mapBloc.add(UpdateOriginPointEvent(originWaypoint));
                            await drawRoute(originWaypoint, destination,
                                [...waypointsBefore]);
                          } else {
                            mapBloc.add(UpdateOriginPointEvent(originWaypoint));
                          }
                          prefs.lugarInicio = resp;
                          prefs.ltLnInicio =
                              '${center.latitude} , ${center.longitude}';
                        } else if (searchBloc.state.typeMarket ==
                            TypeMarket.destination) {
                          final destinationWaypoint = Waypoint(
                            name: resp,
                            lat: center.latitude,
                            lng: center.longitude,
                          );
                          if (mapBloc.state.originPoint != null) {
                            final origin = mapBloc.state.originPoint!;
                            mapBloc.add(UpdateDestinationPointEvent(
                                destinationWaypoint));
                            await drawRoute(origin, destinationWaypoint,
                                [...waypointsBefore]);
                          } else {
                            mapBloc.add(UpdateDestinationPointEvent(
                                destinationWaypoint));
                          }
                          prefs.lugarFin = resp;
                          prefs.ltLnFin =
                              '${center.latitude} , ${center.longitude}';
                        } else if (searchBloc.state.typeMarket ==
                                TypeMarket.waypoints &&
                            mapBloc.state.originPoint != null &&
                            mapBloc.state.destinationPoint != null) {
                          final origin = mapBloc.state.originPoint!;
                          final destination = mapBloc.state.destinationPoint!;

                          final newWaypoint = Waypoint(
                            name: resp,
                            lat: center.latitude,
                            lng: center.longitude,
                          );

                          mapBloc.add(AddWaypointEvent(newWaypoint));
                          await drawRoute(origin, destination,
                              [...waypointsBefore, newWaypoint]);
                        }

                        searchBloc.add(OffActivateManualMarketEvent());
                      },
                      type: 'black'),
                ),
              ))
        ],
      ),
    );
  }
}

class _BtnBack extends StatelessWidget {
  const _BtnBack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 300),
      child: CircleAvatar(
        maxRadius: 25,
        backgroundColor: Colors.white,
        child: IconButton(
            onPressed: () {
              BlocProvider.of<SearchBloc>(context)
                  .add(OffActivateManualMarketEvent());
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
      ),
    );
  }
}
