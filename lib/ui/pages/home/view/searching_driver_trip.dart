import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_usuario/blocs/blocs.dart';
import 'package:ride_usuario/enums/enums.dart';
import 'package:ride_usuario/services/services.dart';
import 'package:ride_usuario/themes/themes.dart';
import 'package:ride_usuario/ui/widgets/animate_search.dart';

import '/utils/button.dart' as btn;

class SearchingDriverTrip extends StatelessWidget {
  const SearchingDriverTrip({
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
  TripService tripService = TripService();
  late Timer _timer;
  int _minutes = 0;
  int _seconds = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderObject = contentKey.currentContext?.findRenderObject();
      if (renderObject != null && renderObject is RenderBox) {
        setState(() {
          contentHeight = renderObject.size.height;
        });
      }
    });
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        if (_seconds == 60) {
          _seconds = 0;
          _minutes++;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
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
        minChildSize: 0.1,
        maxChildSize: 0.43,
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
                  margin: const EdgeInsets.only(top: 8),
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
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Rider revisando tu tarifa ...',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black),
                            ),
                            Text(
                              '  ${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black50,
                              ),
                            ),
                            InfiniteBubbleAnimation(),
                            btn.button(
                                label: 'Cancelar viaje',
                                onPressed: cancelTrip,
                                type: 'gray',
                                textColorApp: AppColors.red)
                          ],
                        ),
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
