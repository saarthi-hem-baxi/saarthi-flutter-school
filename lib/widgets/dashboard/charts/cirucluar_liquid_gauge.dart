import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';

class CircularGaugeChart extends StatefulWidget {
  const CircularGaugeChart({
    Key? key,
    required this.color,
    required this.borderColor,
    required this.value,
  }) : super(key: key);

  final Color color;
  final Color borderColor;
  final num value;

  @override
  State<CircularGaugeChart> createState() => _CircularGaugeChartState();
}

class _CircularGaugeChartState extends State<CircularGaugeChart>
    with TickerProviderStateMixin {
  AnimationController? _bubbleAnimationController;
  Animation? _bubbleAnimation;

  @override
  void initState() {
    super.initState();

    _bubbleAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _bubbleAnimation =
        Tween<double>(begin: 2, end: 20).animate(_bubbleAnimationController!);
    _bubbleAnimation!.addListener(() {
      setState(() {});
    });

    _bubbleAnimationController!.repeat(reverse: true);
  }

  @override
  void dispose() {
    _bubbleAnimationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100.0,
        height: 100.0,
        child: Stack(
          children: [
            WaveProgress(
              size: 100.w,
              borderColor: widget.borderColor,
              fillColor: widget.color,
              progress: double.parse(widget.value.toString()),
            ),
            Align(
              alignment: Alignment.center,
              child: Text.rich(
                TextSpan(
                  text: widget.value.toStringAsFixed(0),
                  style: textTitle20StylePoppins.merge(
                    const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  children: <InlineSpan>[
                    TextSpan(
                      text: "%",
                      style: textTitle10StylePoppins.merge(
                        const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _bubbleAnimationController!,
              builder: (BuildContext context, Widget? child) {
                return Positioned(
                  left: 30 + convertNumToDouble(_bubbleAnimation!.value),
                  bottom: 50 - convertNumToDouble(_bubbleAnimation!.value),
                  child: child!,
                );
              },
              child: Container(
                width: 4.w,
                height: 4.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _bubbleAnimationController!,
              builder: (BuildContext context, Widget? child) {
                return Positioned(
                  right: 80 - convertNumToDouble(_bubbleAnimation!.value),
                  bottom: 50 - convertNumToDouble(_bubbleAnimation!.value),
                  child: child!,
                );
              },
              child: Container(
                width: 4.w,
                height: 4.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _bubbleAnimationController!,
              builder: (BuildContext context, Widget? child) {
                return Positioned(
                  right: 30 - convertNumToDouble(_bubbleAnimation!.value),
                  bottom: 25 + convertNumToDouble(_bubbleAnimation!.value),
                  child: child!,
                );
              },
              child: Container(
                width: 3.w,
                height: 3.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _bubbleAnimationController!,
              builder: (BuildContext context, Widget? child) {
                return Positioned(
                  left: 50 - convertNumToDouble(_bubbleAnimation!.value),
                  top: 16 + convertNumToDouble(_bubbleAnimation!.value),
                  child: child!,
                );
              },
              child: Container(
                width: 2.w,
                height: 2.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _bubbleAnimationController!,
              builder: (BuildContext context, Widget? child) {
                return Positioned(
                  left: 80 + convertNumToDouble(_bubbleAnimation!.value),
                  top: 11 + convertNumToDouble(_bubbleAnimation!.value),
                  child: child!,
                );
              },
              child: Container(
                width: 3.w,
                height: 3.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _bubbleAnimationController!,
              builder: (BuildContext context, Widget? child) {
                return Positioned(
                  left: 70 - convertNumToDouble(_bubbleAnimation!.value),
                  bottom: 30 - convertNumToDouble(_bubbleAnimation!.value),
                  child: child!,
                );
              },
              child: Container(
                width: 2.w,
                height: 2.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _bubbleAnimationController!,
              builder: (BuildContext context, Widget? child) {
                return Positioned(
                  right: 50 - convertNumToDouble(_bubbleAnimation!.value),
                  top: 80 - convertNumToDouble(_bubbleAnimation!.value),
                  child: child!,
                );
              },
              child: Container(
                width: 5.w,
                height: 5.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _bubbleAnimationController!,
              builder: (BuildContext context, Widget? child) {
                return Positioned(
                  left: 40 - convertNumToDouble(_bubbleAnimation!.value),
                  top: 60 + convertNumToDouble(_bubbleAnimation!.value),
                  child: child!,
                );
              },
              child: Container(
                width: 3.5.w,
                height: 3.5.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _bubbleAnimationController!,
              builder: (BuildContext context, Widget? child) {
                return Positioned(
                  left: 35 - convertNumToDouble(_bubbleAnimation!.value),
                  top: 110 - convertNumToDouble(_bubbleAnimation!.value),
                  child: child!,
                );
              },
              child: Container(
                width: 2.w,
                height: 2.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

double convertNumToDouble(num val) {
  return double.parse(val.toString());
}

class WaveProgress extends StatefulWidget {
  final double size;
  final Color borderColor, fillColor;
  final double progress;

  const WaveProgress({
    Key? key,
    required this.size,
    required this.borderColor,
    required this.fillColor,
    required this.progress,
  }) : super(key: key);

  @override
  WaveProgressState createState() => WaveProgressState();
}

class WaveProgressState extends State<WaveProgress>
    with TickerProviderStateMixin {
  AnimationController? controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    controller!.repeat();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      //decoration: new BoxDecoration(color: Colors.green),
      child: ClipPath(
        clipper: CircleClipper(),
        child: AnimatedBuilder(
          animation: controller!,
          builder: (BuildContext context, a) {
            return CustomPaint(
                painter: WaveProgressPainter(controller!, widget.borderColor,
                    widget.fillColor, widget.progress));
          },
        ),
      ),
    );
  }
}

class WaveProgressPainter extends CustomPainter {
  final Animation<double> _animation;
  final Color borderColor, fillColor;
  final double _progress;

  WaveProgressPainter(
      this._animation, this.borderColor, this.fillColor, this._progress)
      : super(repaint: _animation);

  @override
  void paint(Canvas canvas, Size size) {
    // draw small wave
    Paint wave2Paint = Paint()..color = fillColor.withOpacity(0.5);
    double p = _progress / 100.0;
    double n = 4.2;
    double amp = 4.0;
    double baseHeight = (1 - p) * size.height;

    Path path = Path();
    path.moveTo(0.0, baseHeight);
    for (double i = 0.0; i < size.width; i++) {
      path.lineTo(
          i,
          baseHeight +
              sin((i / size.width * 2 * pi * n) +
                      (_animation.value * 2 * pi) +
                      pi * 1) *
                  amp);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    canvas.drawPath(path, wave2Paint);

    // draw big wave
    Paint wave1Paint = Paint()..color = fillColor;
    n = 2.2;
    amp = 10.0;

    path = Path();
    path.moveTo(0.0, baseHeight);
    for (double i = 0.0; i < size.width; i++) {
      path.lineTo(
          i,
          baseHeight +
              sin((i / size.width * 2 * pi * n) + (_animation.value * 2 * pi)) *
                  amp);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    canvas.drawPath(path, wave1Paint);

    // draw border
    Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
