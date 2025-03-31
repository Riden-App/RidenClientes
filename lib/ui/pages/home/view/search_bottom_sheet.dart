import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_usuario/blocs/blocs.dart';
import 'package:ride_usuario/enums/enums.dart';
import 'package:ride_usuario/models/waypoints.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/services/traffic_service.dart';
import 'package:ride_usuario/themes/themes.dart';
import 'package:ride_usuario/ui/widgets/widgets.dart';

import '/utils/button.dart' as btn;

void showSearchBottomSheet(BuildContext context, TypeMarket type) {
  final PreferenciasUsuario prefs = PreferenciasUsuario();

  final searchBloc = BlocProvider.of<SearchBloc>(context);
  final mapBloc = BlocProvider.of<MapBloc>(context);
  final proximity =
      BlocProvider.of<LocationBloc>(context).state.lastKnowLocation!;
  final TextEditingController controller = TextEditingController();

  void onSearchResult() {
    searchBloc.add(OnActivateManualMarketEvent());

    searchBloc.add(UpdateTypeMarketEvent(type));

    Navigator.pop(context);
  }

  Future<void> drawRoute(
      Waypoint origin, Waypoint destination, List<Waypoint> waypoints) async {
    final searchPolylines =
        await searchBloc.getCoorsStartToEnd(origin, destination, waypoints);
    await mapBloc.drawRoutePolyline(searchPolylines, waypoints);
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    builder: (context) {
      return BlocProvider.value(
        value: searchBloc,
        child: Container(
          height: MediaQuery.of(context).size.height - 40,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
              Row(
                children: [
                  Opacity(
                    opacity: 0,
                    child: CircleAvatar(
                      maxRadius: 25,
                      backgroundColor: Color(0xffF5F5F7),
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.blue,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    'Establece tu ruta',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  )),
                  CircleAvatar(
                    maxRadius: 25,
                    backgroundColor: Color(0xffF5F5F7),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.blue,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 27),
              InputFormSearch(
                type: type,
                controller: controller,
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/img/viewOnMap.svg',
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  TextButton(
                      onPressed: onSearchResult,
                      child: Text(
                        'Ver en mapa',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blue),
                        textAlign: TextAlign.start,
                      )),
                ],
              ),
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    searchBloc.getPLacesByquery(
                        proximity, controller.text.trim());
                    final places = state.places;
                    // final history = state.history;
                    final combinedList = [...places];
                    final noRepetition = combinedList.toSet().toList();

                    return ListView.separated(
                      itemCount: noRepetition.length,
                      separatorBuilder: (context, index) => Divider(
                        color: AppColors.black10,
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        final place = combinedList[index];
                        final isHistory = state.history.contains(place);
                        return ListTile(
                          leading: isHistory
                              ? SvgPicture.asset(
                                  'assets/img/clock_refresh.svg',
                                  colorFilter: ColorFilter.mode(
                                      AppColors.black25, BlendMode.srcIn),
                                  width: 20,
                                  height: 20,
                                )
                              : const Icon(
                                  Icons.place_outlined,
                                  color: AppColors.black,
                                ),
                          title: Text(
                              place.structuredFormatting.mainText.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              )),
                          subtitle:
                              Text(place.structuredFormatting.secondaryText,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black50,
                                  )),
                          onTap: () async {
                            final placesService = TrafficService();

                            final waypointsBefore = mapBloc.state.waypoints;

                            final resp = await placesService
                                .getDetailsByPlaceId(place.placeId);

                            if (type == TypeMarket.origin) {
                              final originWaypoint = Waypoint(
                                name: resp.name,
                                lat: resp.geometry.location.lat,
                                lng: resp.geometry.location.lng,
                              );

                              if (mapBloc.state.destinationPoint != null) {
                                final destination =
                                    mapBloc.state.destinationPoint!;

                                mapBloc.add(
                                    UpdateOriginPointEvent(originWaypoint));
                                await drawRoute(originWaypoint, destination,
                                    [...waypointsBefore]);
                              } else {
                                mapBloc.add(
                                    UpdateOriginPointEvent(originWaypoint));
                              }
                              prefs.lugarInicio = resp.name;
                              prefs.ltLnInicio =
                                  '${resp.geometry.location.lat} , ${resp.geometry.location.lng}';
                            } else if (type == TypeMarket.destination) {
                              final destinationWaypoint = Waypoint(
                                name: resp.name,
                                lat: resp.geometry.location.lat,
                                lng: resp.geometry.location.lng,
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
                              prefs.lugarFin = resp.name;
                              prefs.ltLnFin =
                                  '${resp.geometry.location.lat} , ${resp.geometry.location.lng}';
                            } else if (type == TypeMarket.waypoints &&
                                mapBloc.state.originPoint != null &&
                                mapBloc.state.destinationPoint != null) {
                              final origin = mapBloc.state.originPoint!;
                              final destination =
                                  mapBloc.state.destinationPoint!;

                              final newWaypoint = Waypoint(
                                name: resp.name,
                                lat: resp.geometry.location.lat,
                                lng: resp.geometry.location.lng,
                              );

                              mapBloc.add(AddWaypointEvent(newWaypoint));
                              await drawRoute(origin, destination,
                                  [...waypointsBefore, newWaypoint]);
                            }

                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 27),
              btn.button(label: 'Confirmar', onPressed: () {}, type: 'black'),
              SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  ).whenComplete(() {});
}
