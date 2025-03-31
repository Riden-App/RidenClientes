import 'package:flutter/material.dart';
import 'package:ride_usuario/themes/colors.dart';

class InfiniteBubbleAnimation extends StatefulWidget {
  const InfiniteBubbleAnimation({super.key});

  @override
  _InfiniteBubbleAnimationState createState() =>
      _InfiniteBubbleAnimationState();
}

class _InfiniteBubbleAnimationState extends State<InfiniteBubbleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              for (int i = 0; i < 3; i++)
                _buildExpandingCircle(
                  delay: i * 0.5,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildExpandingCircle({required double delay}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double progress = (_controller.value + delay) % 1.0;

        double size = (progress * 200);

        return Opacity(
          opacity: (1 - progress),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.lerp(AppColors.blue10, AppColors.blue06, progress),
            ),
          ),
        );
      },
    );
  }
}
