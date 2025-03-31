import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:ride_usuario/enums/enums.dart';
import 'package:ride_usuario/themes/themes.dart';


mensaje(int duracion, BuildContext context, TypeMessage colorDeFondoS,
     String textoMensaje) {
  late Color colorDeFondo;
  late IconData icono;
  if (colorDeFondoS == TypeMessage.success) {
    colorDeFondo = AppColors.green;
    icono = Icons.check;
  } else if (colorDeFondoS == TypeMessage.danger) {
    colorDeFondo = AppColors.red;
    icono = Icons.no_encryption_gmailerrorred_outlined;
  } else if (colorDeFondoS == TypeMessage.info) {
    colorDeFondo = AppColors.blue;
    icono = Icons.info_outline;
  } else if (colorDeFondoS == TypeMessage.warning) {
    colorDeFondo = AppColors.yellow;
    icono = Icons.warning_amber_outlined;
  }

  showFlash(
      context: context,
      duration: Duration(seconds: duracion),
      builder: (context, controller) {
        return Flash(
          controller: controller,
          child: FlashBar(
            controller: controller,
            backgroundColor: colorDeFondo,
            content: Container(
                constraints: BoxConstraints(minHeight: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icono,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 250),
                      child: Text(textoMensaje,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800)),
                    ),
                  ],
                )),
          ),
        );
      });
}
