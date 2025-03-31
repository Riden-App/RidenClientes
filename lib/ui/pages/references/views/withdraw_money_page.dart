import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ride_usuario/models/response/referred_user_referred.dart';
import 'package:ride_usuario/services/referred_service.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/themes/colors.dart';
import 'package:ride_usuario/ui/pages/references/views/withdrawal_data_page.dart';
import '/utils/button.dart' as btn;

class WithdrawMoneyPage extends StatefulWidget {
  const WithdrawMoneyPage({super.key, required this.balance});
  final String balance;

  @override
  State<WithdrawMoneyPage> createState() => _WithdrawMoneyPageState();
}

class _WithdrawMoneyPageState extends State<WithdrawMoneyPage> {
  bool isLoading = false;
  PreferenciasUsuario prefs = PreferenciasUsuario();
  ReferredService referredService = ReferredService();
  TextEditingController controllerAmount = TextEditingController();
  bool amountEmpty = true;

  List<DataReferreds> withdraw = [];

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat("d 'de' MMM");
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
              Text('Retira',
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Monto',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            amountEmpty = true;
                          } else {
                            amountEmpty = false;
                          }
                        });
                      },
                      keyboardType: TextInputType.number,
                      controller: controllerAmount,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        counterText: '',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.black,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.black,
                          ),
                        ),
                        hintText: 'Máx: S/${widget.balance}',
                        hintStyle: TextStyle(
                          color: const Color(0xff141414).withOpacity(0.25),
                          fontWeight: FontWeight.w600,
                          fontSize: 21,
                        ),
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 21,
                      ),
                    ),
                    SizedBox(height: 44),
                    Text(
                      'El dinero se verá reflejado en tu cuenta en un plazo de 24 a 48 hrs.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    btn.button(
                        label: 'Retirar dinero',
                        onPressed: () {},
                        disabled: amountEmpty,
                        type: 'black')
                  ],
                ),
              ),
              SizedBox(height: 27),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WithdrawalDataPage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.black03,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Depositar a',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'Cuenta de retiros ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.blue),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 27),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Últimos retiros',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 27),
              isLoading
                  ? CircularProgressIndicator()
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            'Tran a visa 1488 ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                          subtitle: Text(
                            '15 agosto, 2:33 p.m.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black60,
                            ),
                          ),
                          trailing: Text(
                            'S/152.80',
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
