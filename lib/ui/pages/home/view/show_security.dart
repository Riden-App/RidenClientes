import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ride_usuario/themes/colors.dart';
import 'package:ride_usuario/utils/actions_trip.dart';

import '/utils/button.dart' as btn;

void showSecurityBottomSheet(BuildContext context) {
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
                    'Seguridad',
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
              SizedBox(height: 42),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.black03,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.all(29.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: SvgPicture.asset(
                            'assets/img/support.svg',
                            colorFilter: ColorFilter.mode(
                                AppColors.black, BlendMode.srcIn),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Contáctate con soporte',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black50,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      makePhoneCall('105');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.all(29.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: SvgPicture.asset(
                              'assets/img/megafono.svg',
                              colorFilter: ColorFilter.mode(
                                  AppColors.white, BlendMode.srcIn),
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Llamar a emergencias',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.white80,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ))
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  ).whenComplete(() {});
}
