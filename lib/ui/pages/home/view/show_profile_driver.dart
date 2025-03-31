import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ride_usuario/models/response/detail_trip_response.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/themes/colors.dart';

import '/utils/button.dart' as btn;

void showProfileDriverBottomSheet(BuildContext context, VehicleData vehicle) {
  PreferenciasUsuario prefs = PreferenciasUsuario();
  final detailTrip = prefs.detailTripResponse.data;
  late String colorVehicle = '';

  switch (vehicle.vehicleColor) {
    case 'WHITE':
      colorVehicle = 'Blanco';
      break;
    case 'BLACK':
      colorVehicle = 'Negro';
      break;
    case 'GRAY':
      colorVehicle = 'Gris';
      break;
    case 'BLUE':
      colorVehicle = 'Azul';
      break;
    case 'YELLOW':
      colorVehicle = 'Amarillo';
      break;
    case 'BEIGE':
      colorVehicle = 'Beige';
      break;
    case 'BROWN':
      colorVehicle = 'Marrón';
      break;
    case 'RED':
      colorVehicle = 'Rojo';
      break;
    default:
      colorVehicle = 'Blanco';
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
                    '${detailTrip.driverUser!.firstName} ${detailTrip.driverUser!.lastName}',
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
              SizedBox(height: 18),
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
                padding: EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 103,
                      height: 103,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(500),
                        child: Image.network(
                          '${detailTrip.user!.profilePictureUrl}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 26,
                    ),
                    Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/img/car_settings.svg',
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                    child: Text(
                                  '12 años conductor',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.black,
                                  ),
                                ))
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/img/start_outlined.svg',
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                    child: Text(
                                  '${(detailTrip.driverUser!.ratingAverageDriver).toStringAsFixed(1)} calificación',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.black,
                                  ),
                                ))
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/img/branch.svg',
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                    child: Text(
                                  '30 viajes',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.black,
                                  ),
                                ))
                              ],
                            )
                          ],
                        )),
                  ],
                ),
              ),
              SizedBox(height: 33),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Información',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              ListTile(
                leading: SvgPicture.asset('assets/img/car_settings.svg'),
                title: Text(
                  vehicle.vehicleType,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                subtitle: Text(
                  'Toyota Corolla, $colorVehicle, ${vehicle.plateNumber}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                // trailing: Container(
                //     decoration: BoxDecoration(
                //       color: AppColors.black03,
                //       borderRadius: BorderRadius.circular(50),
                //     ),
                //     child: SvgPicture.asset('assets/img/copy.svg')),
              ),
              SizedBox(height: 38),
              btn.button(
                label: 'Cerrar',
                onPressed: () {
                  Navigator.pop(context);
                },
                type: 'gray',
                textColorApp: AppColors.black,
              ),
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
