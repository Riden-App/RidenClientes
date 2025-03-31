import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ride_usuario/models/response/all_referred_detail_response.dart';
import 'package:ride_usuario/services/referred_service.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/themes/colors.dart';
import 'package:ride_usuario/ui/pages/references/views/ganancias_referred_by_id_page.dart';
import 'package:ride_usuario/ui/pages/references/views/withdraw_money_page.dart';
import '/utils/button.dart' as btn;

class GananciasReferidosPage extends StatefulWidget {
  const GananciasReferidosPage({super.key, required this.balance});
  final String balance;

  @override
  State<GananciasReferidosPage> createState() => _GananciasReferidosPageState();
}

class _GananciasReferidosPageState extends State<GananciasReferidosPage> {
  bool isLoading = false;
  PreferenciasUsuario prefs = PreferenciasUsuario();
  ReferredService referredService = ReferredService();

  Future<void> getReferreds() async {
    setState(() {
      isLoading = true;
    });

    final idUser = prefs.idUser;
    final result = await referredService.getReferralCommisionGroup(idUser);
    if (result.isSuccess) {
      setState(() {
        referidos = result.data!.data;
        isLoading = false;
      });
    } else {
      print('Error getReferreds: ${result.error}');
    }
  }

  List<DataReferred> referidos = [];

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
              Text('Ganancias',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  )),
              SizedBox(height: 27),
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
                      'ganados hasta ahora',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    btn.button(
                        label: 'Retirar dinero',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WithdrawMoneyPage(
                                        balance: widget.balance,
                                      )));
                        },
                        type: 'black')
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
                        final formatterDate = formatDate(referido.referredDate);
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GananciasReferidosByIdPage(
                                          balance:
                                              referido.totalAmount.toString(),
                                          name:
                                              '${referido.referred.firstName} ${referido.referred.lastName}',
                                          date: formatterDate,
                                          idUser: referido.referred.id,
                                        )));
                          },
                          title: Text(
                            '${referido.referred.firstName} ${referido.referred.lastName}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                          subtitle: Text(
                            'Referido desde el $formatterDate',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black60,
                            ),
                          ),
                          trailing: SizedBox(
                            width: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'S/${num.parse(referido.totalAmount).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 20,
                                )
                              ],
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
