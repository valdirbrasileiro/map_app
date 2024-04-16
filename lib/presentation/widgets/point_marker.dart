import 'package:flutter/material.dart';

class PointMarker extends StatelessWidget {
  final double radius;
  final List<Color> gradientColors;
  final double borderWidth;
  final Color borderColor;
  final Widget? child;

  const PointMarker({
    Key? key,
    required this.radius,
    required this.gradientColors,
    this.borderWidth = 2.0,
    this.borderColor = Colors.white,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: borderWidth, color: borderColor),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: child,
      ),
    );
  }
}
