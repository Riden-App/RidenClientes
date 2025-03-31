import 'package:flutter/material.dart';
import 'package:ride_usuario/themes/colors.dart';
import 'package:ride_usuario/ui/widgets/menu.dart';

class BtnMenu extends StatelessWidget {
  const BtnMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.menu,
            color: AppColors.blue,
          ),
          onPressed: () {
              showMenuBottonSheet(context);
          },
        ));
  }
}
