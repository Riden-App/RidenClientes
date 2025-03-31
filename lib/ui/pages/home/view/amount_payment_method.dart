import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_usuario/enums/categori.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/themes/themes.dart';
import 'package:ride_usuario/ui/pages/home/blocs/map/map_bloc.dart';
import 'package:ride_usuario/ui/pages/home/blocs/search/search_bloc.dart';
import 'package:ride_usuario/ui/widgets/radio_button_custom.dart';

import '/utils/button.dart' as btn;

void showAmountPaymentMethodBottomSheet(
    BuildContext context, bool isFastDrive) {
  final controller = TextEditingController();
  final PreferenciasUsuario prefs = PreferenciasUsuario();
  int selectedCategory = prefs.categoryTrip == 'Espacioso'
      ? 2
      : prefs.categoryTrip == 'Confort'
          ? 1
          : 0;
  int indexRadio = prefs.selectedMethodPayment;

  final List<Map<String, dynamic>> categories = [
    {
      'title': RideCategory.standard.value,
      'image': 'assets/img/estandar.png',
    },
    {
      'title': RideCategory.comfort.value,
      'image': 'assets/img/confort.png',
    },
    {
      'title': RideCategory.spacious.value,
      'image': 'assets/img/spacious.png',
    },
  ];

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) =>
          StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
            final mapBloc = BlocProvider.of<MapBloc>(context);
            final searchBloc = BlocProvider.of<SearchBloc>(context);
            return SafeArea(
              child: Container(
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
                          isFastDrive
                              ? 'Fast drive activo'
                              : 'Ofrece tu tarifa',
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
                    SizedBox(height: 22),
                    isFastDrive
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text:
                                          'Cuando activas esta opción, el aplicativo ',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.black60),
                                    ),
                                    const TextSpan(
                                      text:
                                          'selecciona el precio automáticamente, ',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.black60),
                                    ),
                                    const TextSpan(
                                      text:
                                          'en base a la categoría que hayas escogido.',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.black60),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              Divider(
                                height: 1,
                                color: AppColors.black10,
                              )
                            ],
                          )
                        : TextFormField(
                            keyboardType: TextInputType.number,
                            maxLength: 3,
                            controller: controller,
                            decoration: InputDecoration(
                              counterText: '',
                              border: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.black),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.black60),
                              ),
                              hintText: 'S/ ${(prefs.oferta)}',
                              hintStyle: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: AppColors.black25,
                              ),
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(categories.length, (index) {
                          return GestureDetector(
                            onTap: () async {
                              prefs.categoryTrip =
                                  '${categories[index]['title']}';

                              await searchBloc.getPriceRoute(
                                  mapBloc.state.originPoint!,
                                  mapBloc.state.destinationPoint!,
                                  mapBloc.state.waypoints);
                              myState(() {
                                selectedCategory = index;
                              });
                            },
                            child: Container(
                                width: 137,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: selectedCategory == index
                                      ? Color(0xff9E9E9E)
                                      : AppColors.black04,
                                  borderRadius: BorderRadius.circular(17),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Image.asset(
                                        categories[index]['image'],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(13.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            categories[index]['title'],
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: selectedCategory == index
                                                    ? Colors.white
                                                    : AppColors.black),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Image.asset(
                          'assets/img/efectivo.png',
                        ),
                        SizedBox(
                          width: 13,
                        ),
                        Expanded(
                            child: Text(
                          'Efectivo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        )),
                        CustomRadioButton(
                          isSelected: indexRadio == 1,
                          onPressed: () {
                            myState(() {
                              indexRadio = 1;
                            });
                          },
                          color: AppColors.blue,
                        ),
                      ],
                    ),
                    SizedBox(height: 27),
                    Row(
                      children: [
                        Image.asset(
                          'assets/img/yape.png',
                        ),
                        SizedBox(
                          width: 13,
                        ),
                        Expanded(
                            child: Text(
                          'Yape',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        )),
                        CustomRadioButton(
                          isSelected: indexRadio == 2,
                          onPressed: () {
                            myState(() {
                              indexRadio = 2;
                            });
                          },
                          color: AppColors.blue,
                        ),
                      ],
                    ),
                    SizedBox(height: 27),
                    Row(
                      children: [
                        Image.asset(
                          'assets/img/plin.png',
                        ),
                        SizedBox(
                          width: 13,
                        ),
                        Expanded(
                            child: Text(
                          'Plin',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        )),
                        CustomRadioButton(
                          isSelected: indexRadio == 3,
                          onPressed: () {
                            myState(() {
                              indexRadio = 3;
                            });
                          },
                          color: AppColors.blue,
                        ),
                      ],
                    ),
                    // SizedBox(height: 27),
                    // Row(
                    //   children: [
                    //     Image.asset(
                    //       'assets/img/visa.png',
                    //     ),
                    //     SizedBox(
                    //       width: 13,
                    //     ),
                    //     Expanded(
                    //         child: Text(
                    //       'Débito 4213',
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w500,
                    //         color: AppColors.black,
                    //       ),
                    //     )),
                    //     Radio<int>(
                    //       splashRadius: 20,
                    //       activeColor: AppColors.blue,
                    //       value: 4,
                    //       groupValue: selectedMethodPayment,
                    //       onChanged: (int? value) {
                    //         myState(() {
                    //           selectedMethodPayment = value;
                    //           _prefs.paymentMethod = 'Débito 4213';
                    //         });
                    //       },
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 27),
                    btn.button(
                        label: 'Confirmar',
                        onPressed: () {
                          prefs.selectedMethodPayment = indexRadio;
                          if (controller.text.isNotEmpty) {
                            prefs.oferta = controller.text;
                          }
                          Navigator.pop(context);
                        },
                        type: 'black'),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            );
          })).whenComplete(() {});
}
