// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/worksheet_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/screen/ItemCards/pending_completed_tab.dart';
import 'package:saarthi_pedagogy_studentapp/screen/home/completed_worksheet_page.dart';
import 'package:saarthi_pedagogy_studentapp/screen/home/pending_worksheet_page.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/gradient_circle.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/header.dart';

import '../../model/worksheet_model/homework_model_new.dart';
import '../../theme/colors.dart';

class WorksheetPage extends StatefulWidget {
  const WorksheetPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<WorksheetPage> createState() => _WorksheetPageState();
}

class _WorksheetPageState extends State<WorksheetPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  var worksheetController = Get.put(WorksheetController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
    worksheetController.worksheetPendingModel = HomeworkListModal().obs;
    worksheetController.worksheetCompletedModel = HomeworkListModal().obs;
  }

  Future<bool> _onBackPressed() async {
    debugPrint("On BackPressed Called");
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: getStatusBarHeight(context),
            left: -150,
            child: const GradientCircle(
              gradient: circleOrangeGradient,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(125),
                bottomRight: Radius.circular(125),
              ),
            ),
          ),
          Positioned(
            right: -100.h,
            bottom: -80.h,
            child: const GradientCircle(
              gradient: circlePurpleGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(125),
                bottomLeft: Radius.circular(125),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                color: Colors.white,
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    // color: loginScreenBackgroundColor,
                    children: [
                      HeaderCard(
                        title: 'Worksheet',
                        backEnabled: false,
                        onTap: () {},
                      ),
                      PendingCompletedTab(tabController: _tabController)
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    PendingWorksheetPage(),
                    CompletedWorksheetPage(),
                  ],
                ),
              ),
              // FooterMenu(notifyParent: refresh, route: worksheetRoute)
            ],
          ),
        ],
      ),
    );
  }

  refresh() {
    setState(() {});
  }
}
