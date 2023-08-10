import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/screen/roadmap/constants.dart';

class RoadmapPath extends StatelessWidget {
  final List<dynamic> milestones;
  final List<MilestoneKey> milestoneKeys;
  final GlobalKey masterKey;

  const RoadmapPath({
    Key? key,
    required this.milestones,
    required this.milestoneKeys,
    required this.masterKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PathPainter(
        milestones: milestones,
        milestoneKeys: milestoneKeys,
        masterKey: masterKey,
        milestoneWidth: getMinMilestoneWidth(context),
        screenWidth: getScreenWidth(context),
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  final Paint blackStroke = Paint()
    ..color = const Color.fromRGBO(82, 101, 171, 1)
    ..strokeWidth = 3
    ..style = PaintingStyle.stroke;

  final List<dynamic> milestones;
  final List<MilestoneKey> milestoneKeys;
  final GlobalKey masterKey;
  final double milestoneWidth;
  final double screenWidth;

  PathPainter({
    required this.milestones,
    required this.milestoneKeys,
    required this.masterKey,
    required this.milestoneWidth,
    required this.screenWidth,
  });

  Size getSize(GlobalKey key) {
    return (key.currentContext?.findRenderObject() as RenderBox).size;
  }

  Offset getOffset(GlobalKey key, {RenderObject? ancestor}) {
    return (key.currentContext?.findRenderObject() as RenderBox)
        .localToGlobal(Offset.zero, ancestor: ancestor);
  }

  RenderBox getRenderBox(GlobalKey key) {
    return key.currentContext?.findRenderObject() as RenderBox;
  }

  createRoadmapPath() {
    Path path = Path();
    final milestones = this.milestones.map((e) => e).toList().reversed.toList();
    final milestoneKeys =
        this.milestoneKeys.map((e) => e).toList().reversed.toList();

    for (int i = 0; i < milestones.length - 1; i++) {
      final ms = getSize(milestoneKeys[i].key);
      final mw = ms.width;
      final mh = ms.height;

      final co = getOffset(
        milestoneKeys[i].containerKey,
        ancestor: getRenderBox(masterKey),
      );
      final cy = co.dy;
      final mo = getOffset(
        milestoneKeys[i].key,
        ancestor: getRenderBox(milestoneKeys[i].containerKey),
      );
      final mx = mo.dx;
      final my = mo.dy;

      final sx = mx + mw / 2;
      final sy = cy + my + mh / 2;

      final nms = getSize(milestoneKeys[i + 1].key);
      final nmw = nms.width;
      final nmh = nms.height;

      final nco = getOffset(
        milestoneKeys[i + 1].containerKey,
        ancestor: getRenderBox(masterKey),
      );
      final ncy = nco.dy;
      final nmo = getOffset(
        milestoneKeys[i + 1].key,
        ancestor: getRenderBox(milestoneKeys[i + 1].containerKey),
      );
      final nmx = nmo.dx;
      final nmy = nmo.dy;

      final dx = nmx + nmw / 2;
      final dy = ncy + nmy + nmh / 2;

      path.moveTo(sx, sy);
      path.cubicTo(sx + ((dx - sx) / 5), dy - ((dy - sy) / 1.8),
          dx - ((dx - sx) / 5), sy + ((dy - sy) / 1.8), dx, dy);
    }
    return path;
  }

  @override
  bool shouldRepaint(PathPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    Path p = createRoadmapPath();
    canvas.drawPath(
      dashPath(
        p,
        dashArray: CircularIntervalList<double>(
          <double>[12, 12],
        ),
      ),
      blackStroke,
    );
  }
}
