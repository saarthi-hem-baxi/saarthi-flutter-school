import 'package:flutter/material.dart';

class GradientCircle extends StatefulWidget {
  final LinearGradient gradient;
  final BorderRadius borderRadius;

  const GradientCircle(
      {Key? key, required this.gradient, required this.borderRadius})
      : super(key: key);

  @override
  _GradientCircleState createState() => _GradientCircleState();
}

class _GradientCircleState extends State<GradientCircle> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0,
      child: Container(
        height: 250,
        width: 250,
        decoration: BoxDecoration(
          gradient: widget.gradient,
          borderRadius: widget.borderRadius,
        ),
      ),
    );
  }
}
