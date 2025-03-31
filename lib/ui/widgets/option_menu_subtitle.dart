import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ride_usuario/themes/colors.dart';

Widget optionMenuSubtitle(
  BuildContext context, {
  required String leading,
  required String title,
  required Function() onTap,
  required String subtitle,
}) {
  return GestureDetector(
    onTap: onTap,
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
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.black60,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
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
