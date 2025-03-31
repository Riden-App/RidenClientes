import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ride_usuario/enums/trip_status.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/services/trip_service.dart';
import 'package:ride_usuario/themes/colors.dart';
import 'package:ride_usuario/ui/pages/home/blocs/map/map_bloc.dart';

import '/utils/button.dart' as btn;

void showDetailTripInProgressBottomSheet(BuildContext context) {
  PreferenciasUsuario prefs = PreferenciasUsuario();
  final detailTrip = prefs.detailTripResponse;
  TripService tripService = TripService();

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

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    builder: (context) {
      return SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                    'Detalles de viaje',
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
              SizedBox(height: 39),
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
                        width: 11, height: 16, 'assets/img/arrow_warm_up.svg'),
                  ),
                  SizedBox(
                    width: 17,
                  ),
                  Expanded(
                    child: Text(
                      detailTrip.data.pickupLocation!.name,
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
              for (int i = 0; i < detailTrip.data.dropoffLocations.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color:
                              i == detailTrip.data.dropoffLocations.length - 1
                                  ? AppColors.green15
                                  : AppColors.black,
                          borderRadius: i ==
                                  detailTrip.data.dropoffLocations.length - 1
                              ? BorderRadius.circular(50) // Flecha redondeada
                              : BorderRadius.circular(
                                  8), // Cuadrado para intermedios
                        ),
                        child: i == detailTrip.data.dropoffLocations.length - 1
                            ? SvgPicture.asset(
                                'assets/img/arrow_cool_down.svg',
                                width: 11,
                                height: 16,
                              )
                            : Center(
                                child: Text(
                                  '${i + 1}', // Muestra el índice como número
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(width: 17),
                      Expanded(
                        child: Text(
                          detailTrip.data.dropoffLocations[i].name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Divider(color: AppColors.black10, thickness: 1),
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(),
                    child: SvgPicture.asset('assets/img/yape.svg'),
                  ),
                  SizedBox(
                    width: 17,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pago',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black60,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text:
                                'S/ ${(detailTrip.data.amount).toStringAsFixed(2)} ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                          TextSpan(
                            text: '· ${detailTrip.data.paymentMethod}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                        ]))
                      ],
                    ),
                  )
                ],
              ),
              Divider(color: AppColors.black10, thickness: 1),
              detailTrip.data.tripDetail == ''
                  ? Container()
                  : Row(
                      children: [
                        Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.black,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.menu,
                              color: AppColors.white,
                              size: 18,
                            )),
                        SizedBox(
                          width: 17,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detalles',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black60,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                detailTrip.data.tripDetail,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
              SizedBox(
                height: 35,
              ),
              btn.button(label: 'Soporte', onPressed: () {}, type: 'gray'),
              SizedBox(
                height: 12,
              ),
              btn.button(
                  label: 'Cancelar viaje',
                  onPressed: cancelTrip,
                  type: 'gray',
                  textColorApp: AppColors.red),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      );
    },
  ).whenComplete(() {});
}
