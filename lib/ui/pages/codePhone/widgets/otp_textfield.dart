import 'package:flutter/material.dart';

class OtpTextField extends StatefulWidget {
  const OtpTextField({
    super.key,
    required this.length,
    required this.onCompleted,
    this.backgroundColor = Colors.red,
    this.borderColor = Colors.black,
    this.textColor = Colors.black,
    this.focusedBorderColor = Colors.blue,
  });
  final int length;
  final ValueChanged<String> onCompleted;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color focusedBorderColor;

  @override
  _OtpTextFieldState createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  String _currentInput = '';
  late AnimationController _animationController;
  int _focusedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _controller.addListener(() {
      setState(() {
        _currentInput = _controller.text;
        _focusedIndex = _currentInput.length;
      });
      if (_currentInput.length == widget.length) {
        widget.onCompleted(_currentInput);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double circleDiameter =
            (maxWidth - (10.0 * (widget.length - 1))) / widget.length;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: CustomPaint(
            painter: OtpPainter(
              currentInput: _currentInput,
              length: widget.length,
              backgroundColor: widget.backgroundColor,
              borderColor: widget.borderColor,
              textColor: widget.textColor,
              focusedBorderColor: widget.focusedBorderColor,
              focusedIndex: _focusedIndex,
              animation: _animationController.view,
              circleDiameter: circleDiameter,
            ),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              maxLength: widget.length,
              cursorColor: Colors.transparent,
              style: const TextStyle(color: Colors.transparent),
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
              onTap: () {
                _animationController.forward(from: 0.0);
              },
            ),
          ),
        );
      },
    );
  }
}

class OtpPainter extends CustomPainter {
  OtpPainter({
    required this.currentInput,
    required this.length,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.focusedBorderColor,
    required this.focusedIndex,
    required this.animation,
    required this.circleDiameter,
  });
  final String currentInput;
  final int length;
  final double gap = 10.0;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color focusedBorderColor;
  final int focusedIndex;
  final Animation<double> animation;
  final double circleDiameter;

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0);

    for (int i = 0; i < length; i++) {
      double startX = i * (circleDiameter + gap);
      double centerY = size.height / 2;

      canvas.drawCircle(
        Offset(startX + circleDiameter / 2, centerY),
        circleDiameter / 2,
        backgroundPaint,
      );

      if (i < currentInput.length) {
        TextSpan span = TextSpan(
          style: TextStyle(color: textColor, fontSize: 24.0),
          text: currentInput[i],
        );
        TextPainter textPainter = TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(minWidth: circleDiameter, maxWidth: circleDiameter);
        double xCenter = startX + (circleDiameter - textPainter.width) / 2;
        double yCenter = centerY - textPainter.height / 2;
        textPainter.paint(canvas, Offset(xCenter, yCenter));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
