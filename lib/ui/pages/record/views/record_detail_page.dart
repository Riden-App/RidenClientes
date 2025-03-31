import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ride_usuario/models/response/history_trip_response.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/services/trip_service.dart';
import 'package:ride_usuario/themes/colors.dart';
import 'package:ride_usuario/ui/widgets/map_detail.dart';
import 'package:ride_usuario/ui/widgets/option_menu_subtitle.dart';

import '/utils/button.dart' as btn;

class RecordDetailPage extends StatefulWidget {
  const RecordDetailPage({super.key, required this.data});
  final TripHistory data;

  @override
  State<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  int _selectedRating = 3;

  final TripService tripService = TripService();
  final PreferenciasUsuario prefs = PreferenciasUsuario();

  String formatDate(DateTime date) {
    final DateTime localDate = date.toLocal();
    final DateFormat formatter = DateFormat('EEE, d MMMM · h:mm a', 'es');
    return formatter.format(localDate);
  }

  @override
  Widget build(BuildContext context) {
    LatLng point1 =
        LatLng(widget.data.pickupLocation.lat, widget.data.pickupLocation.lng);
    LatLng point2 = LatLng(widget.data.dropoffLocations.last.lat,
        widget.data.dropoffLocations.last.lng);

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.black03,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                          child: Icon(
                        Icons.close,
                        color: AppColors.blue,
                      )),
                    ),
                  )
                ],
              ),
            ),
            Text(
              formatDate(widget.data.createdAt),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            MapContainer(
              height: 300,
              width: MediaQuery.of(context).size.width,
              point1: point1,
              point2: point2,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.black10,
                          ),
                        ),
                        child: Text(
                          widget.data.tripClass == 'comfort'
                              ? 'Confort'
                              : widget.data.tripClass == 'fast'
                                  ? 'Fast'
                                  : 'Estándar',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.black50,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: widget.data.tripState == 'arrived_at_destination'
                                  ? AppColors.green
                                  : AppColors.red,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                widget.data.tripState ==
                                        'arrived_at_destination'
                                    ? Icons.check_circle_outline_sharp
                                    : Icons.close_rounded,
                                size: 18,
                                color: widget.data.tripState ==
                                        'arrived_at_destination'
                                    ? AppColors.green
                                    : AppColors.red,
                              ),
                              SizedBox(width: 5),
                              Text(
                                widget.data.tripState ==
                                        'arrived_at_destination'
                                    ? 'Completado'
                                    : 'Cancelado',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: widget.data.tripState ==
                                          'arrived_at_destination'
                                      ? AppColors.green
                                      : AppColors.red,
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.blue15,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: SvgPicture.asset(
                            width: 11,
                            height: 16,
                            'assets/img/arrow_warm_up.svg'),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Text(
                          widget.data.pickupLocation.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.green15,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: SvgPicture.asset(
                            width: 11,
                            height: 16,
                            'assets/img/arrow_cool_down.svg'),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Text(
                          widget.data.dropoffLocations.last.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 30),
                    child: Container(
                      padding: const EdgeInsets.all(19),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black08,
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.black03,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                  child: Text('Alexis Rosales',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.black,
                                      ))),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SvgPicture.asset(
                                    'assets/img/star.svg',
                                    colorFilter: ColorFilter.mode(
                                        index < _selectedRating
                                            ? Colors.yellow
                                            : Colors.grey,
                                        BlendMode.srcIn),
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: AppColors.black10,
                  ),
                  widget.data.vehicle == null &&
                          widget.data.vehicle?.model != null
                      ? optionMenuSubtitle(context,
                          leading: 'car_settings',
                          onTap: () {},
                          title: 'Auto',
                          subtitle:
                              '${widget.data.vehicle?.model ?? ''}  ${widget.data.vehicle?.brand ?? ''} · ${widget.data.vehicle?.color ?? ''}')
                      : Divider(
                          height: 1,
                          color: AppColors.black10,
                        ),
                  optionMenuSubtitle(context,
                      leading: 'money',
                      onTap: () {},
                      title: 'Pago',
                      subtitle:
                          'S/${(widget.data.offer)} · ${widget.data.paymentMethod}'),
                  Divider(
                    height: 1,
                    color: AppColors.black10,
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: AppColors.blue,
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0))),
                            onPressed: () {},
                            child: Container(
                              margin: const EdgeInsets.all(18.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/img/user_message.svg',
                                    colorFilter: ColorFilter.mode(
                                        AppColors.blue, BlendMode.srcIn),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Contactar soporte',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  btn.button(
                    label: 'Eliminar registro',
                    textColorApp: AppColors.red,
                    backgroundColorApp: AppColors.black04,
                    onPressed: () {},
                    type: 'login',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
