import 'package:flutter/material.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/themes/colors.dart';
import 'package:ride_usuario/ui/widgets/radio_button_custom.dart';

import '/utils/button.dart' as btn;

class MotiveDeleteAccountPage extends StatefulWidget {
  const MotiveDeleteAccountPage({super.key});

  @override
  State<MotiveDeleteAccountPage> createState() =>
      _MotiveDeleteAccountPageState();
}

class _MotiveDeleteAccountPageState extends State<MotiveDeleteAccountPage> {
  final PreferenciasUsuario prefs = PreferenciasUsuario();
  int indexRadio = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(children: [
                Row(
                  children: [
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor:
                            const Color(0xffF7F7F7).withOpacity(0.8),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.blue,
                      ),
                    ),
                  ],
                ),
                const Text(
                  '¿Por qué quieres eliminar la cuenta? ',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 46),
                motives(
                  motive: 'Mala experiencia con los viajes',
                  index: 0,
                ),
                SizedBox(height: 28),
                motives(
                  motive: 'Problemas con mi cuenta',
                  index: 1,
                ),
                SizedBox(height: 28),
                motives(
                  motive: 'Tengo otra cuenta',
                  index: 2,
                ),
                SizedBox(height: 28),
                motives(
                  motive: 'Otro motivo',
                  index: 3,
                ),
                SizedBox(height: 25),
                indexRadio == 3
                    ? TextFormField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Por favor, explícanos tu motivo.',
                          hintStyle: TextStyle(
                            color: AppColors.black60,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.black10,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.black10,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      )
                    : SizedBox(),
                SizedBox(height: indexRadio == 3 ? 25 : 0),
                Spacer(),
                btn.button(
                    label: 'Eliminar cuenta',
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false);
                    },
                    disabled: indexRadio == -1,
                    backgroundColorApp: AppColors.red,
                    type: 'black'),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget motives({
    required String motive,
    required int index,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            motive,
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
        CustomRadioButton(
          isSelected: indexRadio == index,
          onPressed: () {
            setState(() {
              indexRadio = index;
            });
          },
          color: AppColors.red,
        ),
      ],
    );
  }
}
