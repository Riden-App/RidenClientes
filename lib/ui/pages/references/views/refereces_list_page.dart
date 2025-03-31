import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ride_usuario/models/response/all_referred_detail_response.dart';
import 'package:ride_usuario/services/referred_service.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/services/user_service.dart';
import 'package:ride_usuario/themes/colors.dart';

class ReferencesListAllPage extends StatefulWidget {
  const ReferencesListAllPage({super.key, required this.users});
  final List users;

  @override
  State<ReferencesListAllPage> createState() => _ReferencesListAllPageState();
}

class _ReferencesListAllPageState extends State<ReferencesListAllPage> {
  bool isLoading = false;
  PreferenciasUsuario prefs = PreferenciasUsuario();

  ReferredService referredService = ReferredService();
  UserService userService = UserService();

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
              Text('Mis referidos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  )),
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
                            '${referido.referred.firstName} ${referido.referred.lastName}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                          subtitle: Text(
                            'Referido desde el  ${formatDate(referido.referredDate)}.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black60,
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
