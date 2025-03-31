import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ride_usuario/themes/colors.dart';

Widget optionMenu(
  BuildContext context, {
  required String leading,
  required String title,
  required String link,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, link);
    },
    child: ListTile(
      trailing: SizedBox(
        width: 24,
        height: 24,
        child: Center(
          child: SvgPicture.asset('assets/img/arrow_right.svg'),
        ),
      ),
      title: Text(
        title,
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
          child: SvgPicture.asset('assets/img/$leading.svg'),
        ),
      ),
    ),
  );
}
