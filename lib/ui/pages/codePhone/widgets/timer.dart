import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({Key? key}) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  static const int _initialSeconds = 10;
  int _secondsRemaining = _initialSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining = _initialSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _resetTimer() {
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String displayText = _secondsRemaining > 0
        ? '$_secondsRemaining segundos'
        : 'Tiempo agotado';

    return GestureDetector(
      onTap: _secondsRemaining == 0 ? _resetTimer : null,
      child: Text(
        displayText,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: _secondsRemaining > 0 ? Colors.black : Color(0xff0077FF),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
