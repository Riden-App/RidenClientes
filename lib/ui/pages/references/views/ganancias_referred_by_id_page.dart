import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ride_usuario/models/response/history_trip_response.dart';
import 'package:ride_usuario/models/response/referral_comission_referred.dart';
import 'package:ride_usuario/services/referred_service.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/themes/colors.dart';

class GananciasReferidosByIdPage extends StatefulWidget {
  const GananciasReferidosByIdPage(
      {super.key,
      required this.balance,
      required this.name,
      required this.date,
      required this.idUser});
  final String balance;
  final String name;
  final String date;
  final int idUser;

  @override
  State<GananciasReferidosByIdPage> createState() =>
      _GananciasReferidosByIdPageState();
}

class _GananciasReferidosByIdPageState
    extends State<GananciasReferidosByIdPage> {
  bool isLoading = false;
  PreferenciasUsuario prefs = PreferenciasUsuario();
  ReferredService referredService = ReferredService();

  Future<void> getReferreds() async {
    setState(() {
      isLoading = true;
    });

    final result = await referredService
        .getReferralCommissionByReferred((widget.idUser).toString());
    if (result.isSuccess) {
      setState(() {
        isLoading = false;
        referidos = result.data!.data.reversed.toList();
      });
    } else {
      print('Error getReferreds: ${result.error}');
    }
  }

  List<DataComissionReferred> referidos = [];

  @override
  void initState() {
    getReferreds();
    super.initState();
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat("d 'de' MMM", 'es');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.black03,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_outlined,
                        color: AppColors.blue),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text('Referido',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  )),
              SizedBox(height: 27),
              Row(
                children: [
                  Expanded(
                    child: Text(widget.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        )),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('Tu referido desde el ${widget.date}',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.black60,
                        )),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(23.0),
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
                child: Column(
                  children: [
                    Text('S/${widget.balance}',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blue,
                        )),
                    Text(
                      'generados hasta ahora',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 27),
              isLoading
                  ? CircularProgressIndicator()
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: referidos.length,
                      itemBuilder: (context, index) {
                        final referido = referidos[index];
                        return ListTile(
                          title: Text(
                            ' ${formatDate(referido.createDate)} ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                          trailing: Text(
                            'S/ ${num.parse(referido.amount).toStringAsFixed(2)} ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: AppColors.black10,
                          thickness: 1,
                        );
                      },
                    )
            ],
          ),
        ),
      ),
    ));
  }
}
