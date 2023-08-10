import 'package:flutter/material.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';

double getMinMilestoneWidth(BuildContext context) {
  return getScreenWidth(context) > 250 ? 250 : getScreenWidth(context);
}

const double milestoneMarginVertical = 80;
const double spacing = 20;
const double iconSize = 70;
const double iconLgSize = 110;
// const double cardWidth = 150;
const double cardRadius = 8;

const double startingPointPaddingVertical = 50;
const double startingPointSize = 35;
const double startingPointRadius = 15;

enum MileStoneAlignment {
  left,
  right,
}

class MilestoneKey {
  final String type;
  final GlobalKey key;
  final GlobalKey containerKey;
  final dynamic milestone;

  MilestoneKey({
    required this.type,
    required this.key,
    required this.containerKey,
    required this.milestone,
  });
}

class RoadmapIds {
  String? classId;
  String? sectionId;
  String? subjectId;
  String? chapterId;
  String? roadmapId;

  RoadmapIds({
    this.classId,
    this.sectionId,
    this.subjectId,
    this.chapterId,
    this.roadmapId,
  });
}
