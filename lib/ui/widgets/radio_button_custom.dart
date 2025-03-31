import 'package:flutter/material.dart';
import 'package:ride_usuario/themes/colors.dart';

class CustomRadioButton extends StatefulWidget {
  const CustomRadioButton(
      {super.key,
      required this.isSelected,
      required this.onPressed,
      this.color});
  final bool isSelected;
  final Function() onPressed;
  final Color? color;

  @override
  _CustomRadioButtonState createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: widget.isSelected
                  ? widget.color ?? AppColors.blue
                  : AppColors.black10),
        ),
        child: widget.isSelected
            ? Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color ??AppColors.blue,
                ),
                child: Icon(Icons.check, color: AppColors.white),
              )
            : Container(),
      ),
    );
  }
}
