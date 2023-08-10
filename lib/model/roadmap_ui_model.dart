import 'package:flutter/material.dart';
import 'package:saarthi_pedagogy_studentapp/model/road_map_model/topics.dart';
import 'package:saarthi_pedagogy_studentapp/model/road_map_model/unclear_pre_concept.dart';

class RoadMapUIData {
  int currentMilestone;
  List<Milestone> milestones = [];
  RoadMapUIData(this.currentMilestone, this.milestones);
}

class Milestone {
  String type;
  String title;
  String? clarity;
  ProgressMilestone? progress;
  double? height;
  UnclearPreConcept? unclearPreConcept;
  Topics? topics;
  Milestone(
      {required this.type,
      required this.title,
      this.clarity,
      this.progress,
      this.unclearPreConcept,
      this.topics,
      this.height});
}

class ProgressMilestone {
  int total;
  int completed;

  ProgressMilestone({required this.total, required this.completed});
}

class MilestoneDetail {
  double height;
  Widget detailWidget;
  MilestoneDetail({required this.height, required this.detailWidget});
}
