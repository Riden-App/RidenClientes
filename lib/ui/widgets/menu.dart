import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_usuario/services/login_service.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/themes/themes.dart';
import 'package:ride_usuario/ui/widgets/option_menu.dart';

void showMenuBottonSheet(BuildContext context) {
  PreferenciasUsuario prefs = PreferenciasUsuario();
  LoginService loginService = LoginService();
  Future<void> logout() async {
    final response = await loginService.logout(prefs.accessToken);
    if (response.statusCode == 201) {
      print('usuario cerrado');
      prefs.tokenFirebase = '';
      prefs.isAuthenticated = false;
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

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
                    '',
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
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  'https://i0.wp.com/lamiradafotografia.es/wp-content/uploads/2014/07/foto-perfil-psicologo-180x180.jpg?resize=180%2C180',
                  width: 85,
                  height: 85,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 9),
              Text(
                '${prefs.firstName} ${prefs.lastName}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  buildMenu(context,
                      icon: 'referidos',
                      label: 'Ver a mis referidos',
                      link: '/references'),
                  SizedBox(width: 10),
                  buildMenu(context,
                      icon: 'history',
                      label: 'Historial de viajes',
                      link: '/record'),
                  SizedBox(width: 10),
                  buildMenu(context,
                      icon: 'payment',
                      label: 'Medios de pago',
                      link: '/methodPayment'),
                ],
              ),
              SizedBox(height: 39),
              optionMenu(
                context,
                leading: 'config',
                title: 'Ajustes generales',
                link: '/generalSettings',
              ),
              SizedBox(height: 16),
              optionMenu(
                context,
                leading: 'support',
                title: 'soporte',
                link: '/support',
              ),
              SizedBox(height: 16),
              optionMenu(
                context,
                leading: 'car_settings',
                title: 'Ser conductor',
                link: '/carSettings',
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: logout,
                child: ListTile(
                  trailing: SizedBox(
                    width: 24,
                    height: 24,
                    child: Center(
                      child: SvgPicture.asset('assets/img/arrow_right.svg'),
                    ),
                  ),
                  title: Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ),
                  leading: SizedBox(
                    width: 24,
                    height: 24,
                    child: Center(
                      child: SvgPicture.asset('assets/img/logout.svg'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  ).whenComplete(() {});
}

Widget buildMenu(BuildContext context,
    {required String icon, required String label, required String link}) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, link);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.black03,
        ),
        child: Column(
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: Center(
                child: SvgPicture.asset('assets/img/$icon.svg'),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.black50,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    ),
  );
}
