import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ride_usuario/models/response/history_trip_response.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/services/trip_service.dart';
import 'package:ride_usuario/themes/colors.dart';
import 'package:ride_usuario/ui/pages/record/views/record_detail_page.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final TripService tripService = TripService();
  final PreferenciasUsuario prefs = PreferenciasUsuario();

  List<TripHistory> trips = [];

  @override
  void initState() {
    getAllHistoryTrip();
    super.initState();
  }

  getAllHistoryTrip() async {
    final result = await tripService.getAllHistoryTrip();
    if (result.isSuccess) {
      setState(() {
        trips = result.data!.data.trips;
      });
    } else {
      print('Error getAllHistoryTrip: ${result.error}');
    }
  }

  String formatDate(DateTime date) {
    final DateTime localDate = date.toLocal();
    final DateFormat formatter = DateFormat('EEE, d MMMM · h:mm a', 'es');
    return formatter.format(localDate);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
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
                Text(
                  'Historial',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 29),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: trips.length,
                  itemBuilder: (BuildContext context, int index) {
                    final historyTrip = trips[index];
                    final formatterDate = formatDate(historyTrip.createdAt);
                    final tripClass = historyTrip.tripClass == 'comfort'
                        ? 'Confort'
                        : historyTrip.tripClass == 'fast'
                            ? 'Fast'
                            : 'Estándar';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecordDetailPage(
                                      data: historyTrip,
                                    )));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(16),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: AppColors.black03,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formatterDate,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 11),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: AppColors.black10,
                                          ),
                                        ),
                                        child: Text(
                                          tripClass,
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: AppColors.black10,
                                            ),
                                          ),
                                          child: RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                              text:
                                                  'S/${(historyTrip.offer)}, ',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.black50,
                                              ),
                                            ),
                                            TextSpan(
                                              text: historyTrip.paymentMethod,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.black50,
                                              ),
                                            ),
                                          ])))
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Container(
                                        width: 26,
                                        height: 26,
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: AppColors.blue15,
                                          borderRadius:
                                              BorderRadius.circular(50),
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
                                          historyTrip.pickupLocation.name,
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
                                          borderRadius:
                                              BorderRadius.circular(50),
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
                                          historyTrip
                                              .dropoffLocations.last.name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: historyTrip.tripState ==
                                              'arrived_at_destination'
                                          ? AppColors.green10
                                          : AppColors.red10,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Icon(
                                      historyTrip.tripState ==
                                              'arrived_at_destination'
                                          ? Icons.check_circle_outline_sharp
                                          : Icons.close_rounded,
                                      color: historyTrip.tripState ==
                                              'arrived_at_destination'
                                          ? AppColors.green
                                          : AppColors.red,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
