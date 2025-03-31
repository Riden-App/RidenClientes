import 'package:flutter/material.dart';
import 'package:ride_usuario/themes/colors.dart';

Widget button(
    {required String label,
    required VoidCallback onPressed,
    required String type,
    double? borderRadius,
    Color? textColorApp,
    Color? backgroundColorApp,
    bool? disabled = false}) {
  Color backgroundColor;
  Color textColor;
  borderRadius ??= 50.0;

  switch (type) {
    case 'white':
      backgroundColor = Colors.white;
      textColor = AppColors.black;
      break;
    case 'black':
      backgroundColor = AppColors.black;
      textColor = Colors.white;
    case 'login':
      backgroundColor = AppColors.black04;
      textColor = AppColors.blue;
    case 'gray':
      backgroundColor = AppColors.black03;
      textColor = AppColors.black;
    default:
      backgroundColor = Colors.black;
      textColor = Colors.white;
  }

  if (disabled == true && type == 'black') {
    backgroundColor = AppColors.black10;
    textColor = Colors.white;
  }

  return Row(
    children: [
      Expanded(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColorApp ?? backgroundColor,
                foregroundColor: textColorApp ?? textColor,
                elevation: type == 'login' || type == 'gray' ? 0 : 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius))),
            onPressed: disabled == true ? null : onPressed,
            child: Container(
              margin: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            )),
      ),
    ],
  );
}

Widget buttonWhitIcon(
    {required String label,
    required VoidCallback onPressed,
    Widget? icon,
    bool iconRight = false,
    Color colorText = AppColors.black}) {
  Color backgroundColor = const Color(0xff0D0D0D).withOpacity(0.04);

  final buttonContent = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      if (icon != null && !iconRight) ...[
        icon,
        const SizedBox(width: 8),
      ],
      Expanded(
        child: Container(
          margin: EdgeInsets.only(
            right: iconRight ? 24.0 : 0.0,
            left: iconRight ? 0.0 : 24.0,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorText,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      if (icon != null && iconRight) ...[
        const SizedBox(width: 8),
        icon,
      ],
    ],
  );

  return Row(
    children: [
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: colorText,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          onPressed: onPressed,
          child: Container(
            margin: const EdgeInsets.all(16.0),
            child: buttonContent,
          ),
        ),
      ),
    ],
  );
}

Widget buttonWhitIconTrip({
  required String label,
  required VoidCallback onPressed,
  Widget? icon,
  bool iconRight = false,
}) {
  Color backgroundColor = Colors.transparent;
  Color textColor = const Color(0xff0D0D0D);

  final buttonContent = Row(
    children: <Widget>[
      if (icon != null && !iconRight) ...[
        icon,
        const SizedBox(width: 12),
      ],
      Expanded(
        child: Container(
          margin: EdgeInsets.only(
            right: iconRight ? 24.0 : 0.0,
            left: iconRight ? 0.0 : 24.0,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ),
    ],
  );

  return Row(
    children: [
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
              side: BorderSide(color: Color(0xff0D0D0D).withOpacity(0.1)),
            ),
          ),
          onPressed: onPressed,
          child: Container(
            margin: const EdgeInsets.all(11.0),
            child: buttonContent,
          ),
        ),
      ),
    ],
  );
}

Widget gradientButton({
  required String label,
  required VoidCallback onPressed,
  Widget? icon,
  bool iconRight = false,
}) {
  const Color textColor = Colors.white;

  final buttonContent = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      if (!iconRight && icon != null) ...[
        icon,
        const SizedBox(width: 8),
      ],
      Expanded(
        child: Container(
          margin: EdgeInsets.only(
            right: iconRight ? 24.0 : 0.0,
            left: iconRight ? 0.0 : 24.0,
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      if (iconRight && icon != null) ...[
        const SizedBox(width: 8),
        icon,
      ],
    ],
  );

  return Row(
    children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff007BFF), Color(0xff000BEB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: textColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
            onPressed: onPressed,
            child: Container(
              padding: const EdgeInsets.all(17.0),
              child: buttonContent,
            ),
          ),
        ),
      ),
    ],
  );
}
