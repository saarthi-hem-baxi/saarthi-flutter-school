import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/precap_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/chapters_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/model/precap_model/key_learning_list.dart';
import 'package:saarthi_pedagogy_studentapp/model/precap_model/pre_concept.dart';
import 'package:saarthi_pedagogy_studentapp/model/subject_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/screen/ItemCards/pre_concept_list_cards.dart';
import 'package:saarthi_pedagogy_studentapp/screen/exam_screen.dart';
import 'package:saarthi_pedagogy_studentapp/screen/result_screen.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/gradient_circle.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/header.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';

import '../theme/colors.dart';
import '../theme/style.dart';

class PrecapConceptkeyLearningPage extends StatefulWidget {
  final Datum subjectData;
  final ChaptersDatum chaptersData;
  final bool isFromTests;
  final bool isFromNotification;

  const PrecapConceptkeyLearningPage({
    Key? key,
    required this.subjectData,
    required this.chaptersData,
    this.isFromTests = false,
    this.isFromNotification = false,
  }) : super(key: key);

  @override
  State<PrecapConceptkeyLearningPage> createState() => _PrecapConceptkeyLearningPageState();
}

class _PrecapConceptkeyLearningPageState extends State<PrecapConceptkeyLearningPage> with SingleTickerProviderStateMixin {
  // final dashBoardController = Get.put(DashboardController());

  final testsController = Get.put(PrecapController());

  @override
  void initState() {
    super.initState();
    testsController.precapLoading.value = true;
    testsController.isKeylearningScreen = true;
    testsController.totalKeyLearnings = 0;
    testsController.totalKeylerningExamPer = 0.0;
    testsController.totalKeyLearningsPercentage = 0.0;
    if (widget.isFromTests || widget.isFromNotification) {
      Future.delayed(Duration.zero, () {
        testsController.getPrecapData(subjectData: widget.subjectData, chaptersData: widget.chaptersData);
      });
    }
  }

  void onResume() {}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    Navigator.pop(context);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: _onBackPressed,
          child: Obx(
            () => testsController.precapLoading.isTrue
                ? const Center(
                    child: LoadingSpinner(color: Colors.blue),
                  )
                : Stack(
                    children: [
                      const Positioned(
                        left: -100,
                        child: GradientCircle(
                          gradient: circleOrangeGradient,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(125),
                            bottomRight: Radius.circular(125),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          HeaderCard(
                            title: (testsController.preCapModel.value.precapData?.chapter?.name ?? ""),
                            backEnabled: true,
                            onTap: () {
                              _onBackPressed();
                            },
                          ),
                          Expanded(
                            child: Container(
                              width: getScreenWidth(context),
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Concepts",
                                    style: sectionTitleTextStyle.merge(
                                      const TextStyle(fontSize: 16, color: sectionTitleColor),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      width: getScreenWidth(context),
                                      child: ListView.builder(
                                          itemCount: (testsController.preCapModel.value.precapData?.preConcepts ?? []).length,
                                          itemBuilder: (BuildContext context, int index) {
                                            PreConcept preConceptData = testsController.preCapModel.value.precapData!.preConcepts![index];
                                            return PrecapConceptListItem(preConceptData: preConceptData);
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              {
                                testsController.isKeylearningScreen = true;
                                getPercentage().then((value) {
                                  if (!testsController.preCapModel.value.precapData!.examCompleted!.status!) {
                                    testsController
                                        .getPrecapExamData(
                                      context: context,
                                      precapData: testsController.preCapModel.value.precapData!,
                                      map: {},
                                      isFirst: true,
                                    )
                                        .then((value) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ExamPage(
                                              subjectData: widget.subjectData, chaptersData: widget.chaptersData, isFromTests: widget.isFromTests),
                                        ),
                                      ).then((value) {
                                        onResume();
                                      });
                                    });
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ResultScreenPage(
                                            subjectData: widget.subjectData, chaptersData: widget.chaptersData, isFromTests: widget.isFromTests),
                                      ),
                                    ).then((value) => {onResume()});
                                  }
                                });
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.all(16),
                              height: 46,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: testsController.preCapModel.value.precapData?.examStarted?.status ?? false ? pinkGradient : purpleGradient,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      testsController.preCapModel.value.precapData?.examStarted?.status ?? false ? "Continue Precap" : "Start Precap",
                                      style: textTitle18WhiteBoldStyle),
                                  SvgPicture.asset(
                                    imageAssets +
                                        (testsController.preCapModel.value.precapData?.examStarted?.status ?? false
                                            ? 'tests/continueprecap.svg'
                                            : 'tests/start_rocket.svg'),
                                    height: 23,
                                    width: 23,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<bool> getPercentage() async {
    for (PreConcept item in (testsController.preCapModel.value.precapData?.preConcepts ?? [])) {
      testsController.totalKeyLearnings = testsController.totalKeyLearnings + item.keyLearnings!.length;
    }
    if (testsController.totalKeyLearnings != 0) {
      testsController.totalKeyLearningsPercentage = 100 / testsController.totalKeyLearnings;
    }

    if (testsController.isKeylearningScreen) {
      for (PreConcept cItem in (testsController.preCapModel.value.precapData?.preConcepts ?? [])) {
        for (KeyLearningList kItem in cItem.keyLearnings ?? []) {
          if (kItem.cleared != null) {
            testsController.totalKeylerningExamPer = testsController.totalKeylerningExamPer + testsController.totalKeyLearningsPercentage;
          }
        }
      }
    }

    return true;
  }
}
