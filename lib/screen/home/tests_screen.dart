// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/tests_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/tests_model/tests_model.dart';
import 'package:saarthi_pedagogy_studentapp/screen/ItemCards/pending_completed_tab.dart';
import 'package:saarthi_pedagogy_studentapp/screen/home/completed_tests_page.dart';
import 'package:saarthi_pedagogy_studentapp/screen/home/pending_tests_page.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/gradient_circle.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/header.dart';

import '../../theme/colors.dart';

class TestsPage extends StatefulWidget {
  const TestsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TestsPage> createState() => _TestScreenPageState();
}

class _TestScreenPageState extends State<TestsPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  var testsController = Get.put(TestsController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
    testsController.testsPendingModel = TestsModel().obs;
    testsController.testsCompletedModel = TestsModel().obs;
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
                        title: 'Tests',
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
                  children: const [PendingTestsPage(), CompletedTestsPage()],
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
