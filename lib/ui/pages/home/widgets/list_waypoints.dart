import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_usuario/blocs/blocs.dart';
import 'package:ride_usuario/models/waypoints.dart';
import 'package:ride_usuario/themes/themes.dart';

import '../blocs/map/map_bloc.dart';

class ListWaypoints extends StatefulWidget {
  const ListWaypoints({super.key, required this.destinationName});

  final String destinationName;

  @override
  State<ListWaypoints> createState() => _ListWaypointsState();
}

class _ListWaypointsState extends State<ListWaypoints> {
  Widget _getIconForIndex(int index, int logintud) {
    if (index == logintud - 1) {
      return Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: AppColors.green15,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: EdgeInsets.all(4),
        child: SvgPicture.asset(
          'assets/img/arrow_cool_down.svg',
          width: 11,
          height: 16,
        ),
      );
    } else {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);

    List<Waypoint> combinedWaypoints = List.from(mapBloc.state.waypoints);

    String lastWaypoint = widget.destinationName;

    if (mapBloc.state.destinationPoint != null) {
      final destinationWaypoint = Waypoint(
        name: lastWaypoint,
        lat: mapBloc.state.destinationPoint!.lat,
        lng: mapBloc.state.destinationPoint!.lng,
      );
      combinedWaypoints.add(destinationWaypoint);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: constraints.maxHeight,
          ),
          child: ReorderableListView(
            shrinkWrap: true,
            buildDefaultDragHandles: false,
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final waypoint = combinedWaypoints.removeAt(oldIndex);
                combinedWaypoints.insert(newIndex, waypoint);
              });
            },
            children: [
              for (final waypoint in combinedWaypoints)
                Column(
                  key: ValueKey(
                      '${waypoint.name}_${combinedWaypoints.indexOf(waypoint)}'),
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          _getIconForIndex(combinedWaypoints.indexOf(waypoint),
                              combinedWaypoints.length),
                          SizedBox(width: 10),
                          Expanded(child: Text(waypoint.name)),
                          GestureDetector(
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.black04,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.close,
                                  color: AppColors.black,
                                  size: 16,
                                ),
                              ),
                            ),
                            onTap: () async {
                              final origin = mapBloc.state.originPoint!;

                              setState(() {
                                if (combinedWaypoints.last == waypoint) {
                                  combinedWaypoints.removeLast();
                                  mapBloc.add(UpdateDestinationPointEvent(
                                    Waypoint(
                                        name: combinedWaypoints[
                                                combinedWaypoints.length - 1]
                                            .name,
                                        lat: combinedWaypoints[
                                                combinedWaypoints.length - 1]
                                            .lat,
                                        lng: combinedWaypoints[
                                                combinedWaypoints.length - 1]
                                            .lng),
                                  ));
                                  mapBloc.add(RemoveWaypointEvent(
                                      combinedWaypoints[
                                          combinedWaypoints.length - 1]));
                                  Navigator.pop(context);
                                } else {
                                  combinedWaypoints.remove(waypoint);
                                  mapBloc.add(RemoveWaypointEvent(waypoint));
                                }
                              });

                              Waypoint beforeDraw = combinedWaypoints.last;
                              beforeDraw = combinedWaypoints.removeLast();
                              final searchPolylines =
                                  await searchBloc.getCoorsStartToEnd(
                                      origin,
                                      Waypoint(
                                        name: beforeDraw.name,
                                        lat: beforeDraw.lat,
                                        lng: beforeDraw.lng,
                                      ),
                                      combinedWaypoints);
                              await mapBloc.drawRoutePolyline(
                                  searchPolylines, combinedWaypoints);

                              combinedWaypoints = [
                                beforeDraw,
                                ...combinedWaypoints
                              ];
                            },
                          ),
                          SizedBox(
                            width: 11,
                          ),
                          ReorderableDragStartListener(
                            index: combinedWaypoints.indexOf(waypoint),
                            child: SvgPicture.asset(
                                'assets/img/drag_indicator.svg'),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: AppColors.black10, height: 1),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
