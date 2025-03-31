import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ride_usuario/blocs/blocs.dart';
import 'package:ride_usuario/enums/trip_status.dart';
import 'package:ride_usuario/services/location_service.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/themes/themes.dart';
import 'package:ride_usuario/ui/pages/chat/chat_page.dart';
import 'package:ride_usuario/ui/pages/home/view/show_detail_trip.dart';
import 'package:ride_usuario/ui/pages/home/view/show_profile_driver.dart';
import 'package:ride_usuario/ui/pages/home/view/show_security.dart';
import 'package:ride_usuario/ui/widgets/data_vehicle.dart';
import 'package:ride_usuario/utils/actions_trip.dart';

class ResumeTrip extends StatelessWidget {
  const ResumeTrip({
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
                child: _ResumeTrip(scrollController: scrollController));
      },
    );
  }
}

class _ResumeTrip extends StatefulWidget {
  const _ResumeTrip({
    super.key,
    required this.scrollController,
  });

  final DraggableScrollableController scrollController;

  @override
  State<_ResumeTrip> createState() => _ResumeTripState();
}

class _ResumeTripState extends State<_ResumeTrip> {
  @override
  void initState() {
    super.initState();
    updateLocation();
  }

  void updateLocation() async {
    locationService.startSendingLocation(context);
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
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Viajando al siguiente',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Disfruta de tu viaje con total seguridad',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.black60,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
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
