import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ride_usuario/blocs/blocs.dart';
import 'package:ride_usuario/enums/enums.dart';
import 'package:ride_usuario/services/location_service.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/services/trip_service.dart';
import 'package:ride_usuario/themes/themes.dart';
import 'package:ride_usuario/ui/pages/chat/chat_page.dart';
import 'package:ride_usuario/ui/pages/home/view/show_detail_trip.dart';
import 'package:ride_usuario/ui/pages/home/view/show_profile_driver.dart';
import 'package:ride_usuario/ui/pages/home/view/show_security.dart';
import 'package:ride_usuario/ui/widgets/data_vehicle.dart';
import 'package:ride_usuario/utils/actions_trip.dart';

import '/utils/button.dart' as btn;

class WaitingUserTrip extends StatelessWidget {
  const WaitingUserTrip({
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
  late Timer _timer;
  int _remainingTime = 300;
  Color _textColor = AppColors.blue;
  TripService tripService = TripService();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _textColor = AppColors.red;
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
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
    PreferenciasUsuario prefs = PreferenciasUsuario();
    final detailResponseTrip = prefs.detailTripResponse;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: DraggableScrollableSheet(
        controller: widget.scrollController,
        initialChildSize: 0.38,
        minChildSize: 0.1,
        maxChildSize: 0.62,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
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
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Text(
                              _textColor == AppColors.red
                                  ? 'Estás a destiempo'
                                  : 'El rider te está esperando',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black),
                            ),
                            Text(
                              _formatTime(_remainingTime),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _textColor,
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.black08,
                                    blurRadius: 20,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: dataVehicle(
                                  context, detailResponseTrip.data.vehicle!),
                            ),
                            SizedBox(height: 36),
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    '${detailResponseTrip.data.user!.profilePictureUrl}',
                                    width: 45,
                                    height: 45,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    showProfileDriverBottomSheet(context,
                                        detailResponseTrip.data.vehicle!);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        '${detailResponseTrip.data.driverUser!.firstName} ${detailResponseTrip.data.driverUser!.lastName}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(Icons.arrow_forward_ios_rounded)
                                    ],
                                  ),
                                )),
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    makePhoneCall(detailResponseTrip
                                        .data.driverUser!.mobile);
                                  },
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    padding: EdgeInsets.all(11.0),
                                    decoration: BoxDecoration(
                                      color: AppColors.black03,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/img/call.svg',
                                      colorFilter: ColorFilter.mode(
                                          AppColors.black, BlendMode.srcIn),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatPage()));
                                  },
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    padding: EdgeInsets.all(11.0),
                                    decoration: BoxDecoration(
                                      color: AppColors.black03,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/img/chat.svg',
                                      colorFilter: ColorFilter.mode(
                                          AppColors.black, BlendMode.srcIn),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 35,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    shareTrip(
                                      startLat: detailResponseTrip
                                          .data.pickupLocation!.lat,
                                      startLng: detailResponseTrip
                                          .data.pickupLocation!.lng,
                                      endLat: detailResponseTrip
                                          .data.dropoffLocations.last.lat,
                                      endLng: detailResponseTrip
                                          .data.dropoffLocations.last.lng,
                                    );
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.black03,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.all(19.0),
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/img/shared_road.svg',
                                          ),
                                          SizedBox(
                                            height: 14,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Compartir recorrido',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.black50,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                )),
                                SizedBox(width: 10),
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    showDetailTripInProgressBottomSheet(
                                        context);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.black03,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.all(19.0),
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/img/detail_trip.svg',
                                          ),
                                          SizedBox(
                                            height: 14,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Detalles del viaje',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.black50,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                )),
                                SizedBox(width: 10),
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    showSecurityBottomSheet(context);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.black03,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.all(19.0),
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/img/shield_person.svg',
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Seguridad',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.black50,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      )),
                                )),
                              ],
                            ),
                            SizedBox(height: 21),
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
