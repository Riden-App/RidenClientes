import 'package:flutter/material.dart';
import 'package:ride_usuario/themes/colors.dart';
import 'package:ride_usuario/ui/widgets/menu.dart';
import 'package:ride_usuario/ui/widgets/option_menu.dart';

class GeneralSettingsPage extends StatefulWidget {
  const GeneralSettingsPage({super.key});

  @override
  State<GeneralSettingsPage> createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
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
                'Ajustes generales',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 29),
              optionMenu(context,
                  leading: 'user_check',
                  title: 'Datos de Peril',
                  link: '/userProfile'),
              SizedBox(height: 16),
              optionMenu(context,
                  leading: 'lock',
                  title: 'Privacidad',
                  link: '/userProfile'),
              SizedBox(height: 16),
              optionMenu(context,
                  leading: 'term',
                  title: 'Términos y condiciones',
                  link: '/userProfile'),
              Divider(
                height: 16,
                color: AppColors.black10,
              ),
              optionMenu(context,
                  leading: 'logout',
                  title: 'Cerrar sesión',
                  link: '/userProfile'),
            ],
          ),
        ),
      ),
    );
  }
}
