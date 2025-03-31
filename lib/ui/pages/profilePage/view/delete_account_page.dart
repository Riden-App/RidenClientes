import 'package:flutter/material.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/themes/colors.dart';
import 'package:ride_usuario/ui/widgets/radio_button_custom.dart';

import '/utils/button.dart' as btn;

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final PreferenciasUsuario prefs = PreferenciasUsuario();
  bool confirmDelete = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
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
                  'Eliiminar cuenta',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(26.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black08,
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: Icon(
                          Icons.error_outline_rounded,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        'Algunas acciones no podrán deshacerse luego de eliminar tu cuenta. Por favor, lee cuidadosamente la siguiente información.',
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 33),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        color: AppColors.black60,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Tu historial de viajes, información personal y de pagos se perderá de forma permanente. \n Esta acción no puede deshacerse. Cualquier solicitud enviada para descargar tu información personal se cancelará si eliminas tu cuenta.\n',
                        style: TextStyle(
                          color: AppColors.black60,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        color: AppColors.black60,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Se conservará un registro de las infracciones en las que pudieras haber incurrido.',
                        style: TextStyle(
                          color: AppColors.black60,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 35),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'La solicitud para eliminar tu cuenta tendrá efecto inmediato y es',
                      ),
                      TextSpan(
                        text: ' irreversible.',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' Asegúrate de querer eliminar tu cuenta antes de hacerlo.',
                      ),
                    ],
                  ),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 42),
                Divider(height: 1, color: AppColors.black10),
                SizedBox(height: 25),
                Row(
                  children: [
                    CustomRadioButton(
                      isSelected: confirmDelete,
                      onPressed: () {
                        setState(() {
                          confirmDelete = !confirmDelete;
                        });
                      },
                      color: AppColors.red,
                    ),
                    SizedBox(width: 13),
                    Expanded(
                      child: Text(
                        'He leído y estoy de acuerdo.',
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                btn.button(
                    label: 'Siguiente',
                    onPressed: () {
                      Navigator.pushNamed(context, '/motiveDeleteAccount');
                    },
                    disabled: !confirmDelete,
                    type: 'black'),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
