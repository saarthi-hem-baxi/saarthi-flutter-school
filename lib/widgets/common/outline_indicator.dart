import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OutlineIndicator extends Decoration {
  const OutlineIndicator({
    this.color = Colors.white,
    this.strokeWidth = 2,
    this.radius = const Radius.circular(24),
  });

  final Color color;
  final double strokeWidth;
  final Radius radius;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _OutlinePainter(
      color: color,
      strokeWidth: strokeWidth,
      radius: radius,
      onChange: onChanged,
    );
  }
}

class _OutlinePainter extends BoxPainter {
  _OutlinePainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    VoidCallback? onChange,
  })  : _paint = Paint()
          ..style = PaintingStyle.stroke
          ..color = color
          ..strokeWidth = strokeWidth,
        super(onChange);

  final Color color;
  final double strokeWidth;
  final Radius radius;
  final Paint _paint;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    var rect = Rect.fromCenter(
        center:
            Offset(offset.dx + configuration.size!.width / 2, offset.dy + 50.h),
        width: 45.w,
        height: 2.h);
    // var rect = Rect.fromLTWH((offset.dx + 40), (offset.dy + 35).h, (configuration.size!.width - 70), 2);

    var rrect = RRect.fromRectAndRadius(rect, radius);
    canvas.drawRRect(rrect, _paint);
  }
}
