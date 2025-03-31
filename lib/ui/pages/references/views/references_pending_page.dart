import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/services/user_service.dart';
import 'package:ride_usuario/themes/colors.dart';

class ReferencesPendingPage extends StatefulWidget {
  const ReferencesPendingPage({super.key, required this.users});
  final List users;

  @override
  State<ReferencesPendingPage> createState() => _ReferencesPendingPageState();
}

class _ReferencesPendingPageState extends State<ReferencesPendingPage> {
  List<Map<String, dynamic>> result = [];
  UserService userService = UserService();
  PreferenciasUsuario prefs = PreferenciasUsuario();
  @override
  void initState() {
    getReferreds();
    super.initState();
  }

  Future<void> getReferreds() async {
    for (var item in widget.users) {
      final idUser = item['idUser'];

      try {
        final userInfo = await userService.getInfo(idUser.toString());

        final newObject = {
          'name':
              '${userInfo.data!.data.firstName} ${userInfo.data!.data.lastName}',
          'date': item['created_at'],
        };

        result.add(newObject);
        setState(() {});
      } catch (e) {
        print('Error al obtener información del usuario con id $idUser: $e');
      }
    }
  }

  String formatDate(DateTime date) {
    final DateTime localDate = date.toLocal();
    final DateFormat formatter = DateFormat('d MMM', 'es');
    return 'Invitado el ${formatter.format(localDate)}';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
              Text('Inactivos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  )),
              SizedBox(
                height: 27,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'Estos amigos aún están evaluando tu solicitud. Puedes comunicarte con ellos para asegurarte de que ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black60,
                        ),
                      ),
                      TextSpan(
                        text: 'recibieron la invitación',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black60,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: result.length,
                itemBuilder: (context, index) {
                  final referido = result[index];
                  return ListTile(
                    title: Text(
                      referido['name'],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                    subtitle: Text(
                      'Invitado el ${referido['date'].split('T')[0]}.',
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
