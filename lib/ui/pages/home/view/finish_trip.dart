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

import '/utils/button.dart' as btn;

class CompleteTrip extends StatelessWidget {
  const CompleteTrip({
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

int _selectedRating = 0;
final _commentController = TextEditingController();
TripService tripService = TripService();

class _SearchTripState extends State<_SearchTrip> {
  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    PreferenciasUsuario prefs = PreferenciasUsuario();

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: DraggableScrollableSheet(
        controller: widget.scrollController,
        initialChildSize: 0.45,
        minChildSize: 0.1,
        maxChildSize: 0.45,
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
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Califica tu viaje',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black),
                            ),
                            SizedBox(height: 41),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedRating = index + 1;
                                    });
                                  },
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
                            SizedBox(height: 41),
                            TextFormField(
                              controller: _commentController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Cuéntanos cómo estuvo tu viaje',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.black60,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide(
                                    color: AppColors.black10,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide(
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 41),
                            btn.button(
                              label: 'Continuar',
                              onPressed: () async {
                                final tripId = prefs.detailTripResponse.data.id;
                                final resultRating =
                                    await tripService.sendRating(
                                        tripId,
                                        _selectedRating,
                                        _commentController.text);
                                if (resultRating.isSuccess) {
                                  mapBloc
                                      .add(ChangeStatusEvent(TripStatus.none));

                                  locationService.stopSendingLocation();
                                } else {
                                  print('Error al enviar rating');
                                }
                              },
                              type: 'black',
                            )
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
