import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/themes/colors.dart';
import 'package:ride_usuario/ui/widgets/option_menu_subtitle.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final PreferenciasUsuario prefs = PreferenciasUsuario();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                        Icons.arrow_back,
                        color: AppColors.blue,
                      )),
                    ),
                  )
                ],
              ),
              Text(
                'Datos de perfil ${prefs.idUser}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 29),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  'https://i0.wp.com/lamiradafotografia.es/wp-content/uploads/2014/07/foto-perfil-psicologo-180x180.jpg?resize=180%2C180',
                  width: 85,
                  height: 85,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 29),
              optionMenuSubtitle(
                context,
                leading: 'user',
                onTap: () {
                  Navigator.pushNamed(context, '/nameEditProfile');
                },
                title: prefs.firstName,
                subtitle: prefs.lastName,
              ),
              Divider(
                height: 14,
                color: AppColors.black10,
              ),
              optionMenuSubtitle(
                context,
                leading: 'phone',
                onTap: () {
                  Navigator.pushNamed(context, '/phoneEditProfile');
                },
                title: 'Celular',
                subtitle: prefs.phoneNumber,
              ),
              Divider(
                height: 14,
                color: AppColors.black10,
              ),
              optionMenuSubtitle(
                context,
                leading: 'mail',
                onTap: () {
                  Navigator.pushNamed(context, '/emailEditProfile');
                },
                title: 'Correo',
                subtitle: prefs.email,
              ),
              Divider(
                height: 14,
                color: AppColors.black10,
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/deleteAccount'),
                child: ListTile(
                  trailing: SizedBox(
                    width: 24,
                    height: 24,
                    child: Center(
                      child: SvgPicture.asset('assets/img/arrow_right.svg',
                          colorFilter:
                              ColorFilter.mode(AppColors.red, BlendMode.srcIn)),
                    ),
                  ),
                  title: Text(
                    'Eliminar cuenta',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.red,
                    ),
                  ),
                  leading: SizedBox(
                    width: 24,
                    height: 24,
                    child: Center(
                      child: SvgPicture.asset('assets/img/user_close.svg'),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
