import 'package:flutter/material.dart';
import 'package:ride_usuario/models/response/detail_trip_response.dart';
import 'package:ride_usuario/themes/colors.dart';

Widget dataVehicle(BuildContext context, VehicleData vehicle) {
  late String linkVehicleColor = '';
  late String colorVehicle = '';

  switch (vehicle.vehicleColor) {
    case 'WHITE':
      linkVehicleColor = 'assets/img/white.png';
      colorVehicle = 'Blanco';
      break;
    case 'BLACK':
      linkVehicleColor = 'assets/img/black.png';
      colorVehicle = 'Negro';
      break;
    case 'GRAY':
      linkVehicleColor = 'assets/img/gray.png';
      colorVehicle = 'Gris';
      break;
    case 'BLUE':
      linkVehicleColor = 'assets/img/blue.png';
      colorVehicle = 'Azul';
      break;
    case 'YELLOW':
      linkVehicleColor = 'assets/img/yellow.png';
      colorVehicle = 'Amarillo';
      break;
    case 'BEIGE':
      linkVehicleColor = 'assets/img/beige.png';
      colorVehicle = 'Beige';
      break;
    case 'BROWN':
      linkVehicleColor = 'assets/img/brown.png';
      colorVehicle = 'Marrón';
      break;
    case 'RED':
      linkVehicleColor = 'assets/img/red.png';
      colorVehicle = 'Rojo';
      break;
    default:
      linkVehicleColor = 'assets/img/white.png';
      colorVehicle = 'Blanco';
  }

  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.black40,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 4.0),
                  child: Text(
                    vehicle.plateNumber,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white),
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.black40,
                      )),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 4.0),
                  child: Text(
                    vehicle.tripClasses[0] == 'standard'
                        ? 'Estándar'
                        : vehicle.tripClasses[0] == 'comfort'
                            ? 'Confort'
                            : 'Espacioso',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black40),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                colorVehicle,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                '${vehicle.vehicleMakeId} ${vehicle.vehicleModelId}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black),
              ),
            ),
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 175,
            height: 100,
            padding: EdgeInsets.only(
              right: 20,
              top: 20,
              left: 20,
            ),
            child: Image.asset(
              linkVehicleColor,
              width: 30,
              height: 30,
            ),
          )
        ],
      )
    ],
  );
}
