import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/theme/colors.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/custom_network_image.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/dashboard/charts/learning_time_multiline_chart.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/dashboard/comming_soon.dart';

import '../../helpers/const.dart';
import '../../model/auth/users.dart';
import '../../widgets/dashboard/app_maintacne_notice_widget.dart';
import '../../widgets/dashboard/charts/learn_o_meter.dart';
import '../../widgets/dashboard/charts/learning_outcome_chart.dart';
import '../../widgets/dashboard/charts/learning_time.dart';
import '../../widgets/dashboard/charts/lo_time_multiline_chart.dart';
import '../../widgets/dashboard/less_then_lo_table.dart';
import '../../widgets/dashboard/pending_hw_list_table.dart';
import '../../widgets/dashboard/progressive_perfomers_table.dart';
import '../../widgets/dashboard/top_perfomers_list_table.dart';
import '../lucky-draw/lucky_draw_registration_screen.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final PageController pageController = PageController();

  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    authController.renewUser().then((v) {
      if (authController.currentUser.value.isDrawCode == null &&
          authController.currentUser.value.drawCode == null &&
          authController.isOpenSubscriptionPopup.isFalse) {
        Get.to(const LuckyDrawRegistrationScreen(), transition: Transition.leftToRight);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScreenBg1Purple,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                HeaderComp(),
                SizedBox(
                  height: 10.h,
                ),
                const AppMaintanceNoticeWidget(),
                const _TopHeadingViewPager(),
                SizedBox(
                  height: 10.h,
                ),
                LerningOutComeChart(),
                SizedBox(
                  height: 10.h,
                ),
                // Text(
                //   "Growth Chart",
                //   style: textTitle14StylePoppins.merge(const TextStyle(fontWeight: FontWeight.w600)),
                // ),
                // SizedBox(
                //   height: 5.h,
                // ),
                // const GrowthChartViewPager(),
                // SizedBox(
                //   height: 10.h,
                // ),
                // const CommingSoon(
                //   child: NoticeBoard(
                //     noticeBoardText: "Final exam of class 1 to 8 is starting from 12 April.",
                //   ),
                // ),
                // SizedBox(
                //   height: 10.h,
                // ),
                // const CommingSoon(child: DataTableViewPager()),
                // SizedBox(
                //   height: 10.h,
                // ),
                // const CommingSoon(child: BrainChart()),
                // SizedBox(
                //   height: 10.h,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GrowthChartViewPager extends StatefulWidget {
  const GrowthChartViewPager({Key? key}) : super(key: key);

  @override
  State<GrowthChartViewPager> createState() => _GrowthChartViewPagerState();
}

class _GrowthChartViewPagerState extends State<GrowthChartViewPager> {
  final PageController _controller = PageController(
    initialPage: 0,
  );

  double currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        currentPage = _controller.page!.floorToDouble();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: const [CommingSoon(child: LOTimeMultiLineChart()), CommingSoon(child: LearnigTimeMultiLineChart())],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ViewPagerIndicator(
                index: 0,
                controllerIndex: currentPage,
              ),
              ViewPagerIndicator(
                index: 1,
                controllerIndex: currentPage,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class DataTableViewPager extends StatefulWidget {
  const DataTableViewPager({Key? key}) : super(key: key);

  @override
  State<DataTableViewPager> createState() => _DataTableViewPagerState();
}

class _DataTableViewPagerState extends State<DataTableViewPager> {
  final PageController _controller = PageController(
    initialPage: 0,
  );

  double currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        currentPage = _controller.page!.floorToDouble();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320.h,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: [
                HWPendingListTable(),
                LessthenLOTable(),
                TopPerfomersTable(),
                ProgressivePerfomersTable(),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ViewPagerIndicator(
                index: 0,
                controllerIndex: currentPage,
              ),
              ViewPagerIndicator(
                index: 1,
                controllerIndex: currentPage,
              ),
              ViewPagerIndicator(
                index: 2,
                controllerIndex: currentPage,
              ),
              ViewPagerIndicator(
                index: 3,
                controllerIndex: currentPage,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _TopHeadingViewPager extends StatefulWidget {
  const _TopHeadingViewPager({Key? key}) : super(key: key);

  @override
  State<_TopHeadingViewPager> createState() => _TopHeadingViewPagerState();
}

class _TopHeadingViewPagerState extends State<_TopHeadingViewPager> {
  final PageController _controller = PageController(
    initialPage: 0,
  );

  double currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        currentPage = _controller.page!.floorToDouble();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getScrenHeight(context) - 50.h > 700 ? 300.h : 380.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: const [
                _TopHeadingViewPagerPage1(),
                _TopHeadingViewPagerPage2(),
                // _TopHeadingViewPagerPage3(),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ViewPagerIndicator(
                index: 0,
                controllerIndex: currentPage,
              ),
              ViewPagerIndicator(
                index: 1,
                controllerIndex: currentPage,
              ),
              // ViewPagerIndicator(
              //   index: 2,
              //   controllerIndex: currentPage,
              // ),
            ],
          )
        ],
      ),
    );
  }
}

// class _TopHeadingViewPagerPage3 extends StatelessWidget {
//   const _TopHeadingViewPagerPage3({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           height: 360.h,
//           width: getScreenWidth(context) * 0.3,
//           child: const CommingSoon(
//             child: PreConceptClearedChart(
//               gainedValue: 80,
//               totalValue: 160,
//               diffrenceValue: 4,
//               isValueUp: true,
//               clearedUsingSaarthi: 40,
//             ),
//           ),
//         ),
//         const SizedBox(
//           width: 10,
//         ),
//         Expanded(
//           child: SizedBox(
//             height: 360.h,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 CommingSoon(
//                   child: TestAllotedChart(
//                     gainedValue: 206,
//                     totalValue: 500,
//                     pieData: [
//                       CustomPieChartData(
//                         value: 60,
//                         borderColor: colorPink400,
//                         color: colorPink500,
//                         darkColor: colorPink600,
//                         title: "Teacher\nGen.",
//                       ),
//                       CustomPieChartData(
//                         value: 40,
//                         borderColor: colorGreen400,
//                         color: colorGreen500,
//                         darkColor: colorGreen600,
//                         title: "System\nGen.",
//                       )
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 CommingSoon(
//                   child: WSAllotedChart(
//                     gainedValue: 476,
//                     totalValue: 500,
//                     pieData: [
//                       CustomPieChartData(
//                         value: 66,
//                         borderColor: colorYellow400,
//                         color: colorYellow500,
//                         darkColor: colorYellow600,
//                         title: "Teacher\nGen.",
//                       ),
//                       CustomPieChartData(
//                         value: 34,
//                         borderColor: colorSky400,
//                         color: colorSky500,
//                         darkColor: colorSky600,
//                         title: "System\nGen.",
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

class _TopHeadingViewPagerPage2 extends StatelessWidget {
  const _TopHeadingViewPagerPage2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: getScreenWidth(context) - 32.w,
          height: 360.h,
          child: LearningTimeChart(),
        ),
        // const SizedBox(
        //   width: 10,
        // ),
        // Expanded(
        //   child: Column(
        //     children: [
        //       SizedBox(
        //         height: 145.h,
        //         child: CommingSoon(
        //           child: AttemptedQuestionsChart(
        //             value: 200,
        //             pieData: [
        //               CustomPieChartData(
        //                 value: 60,
        //                 color: colorBlue500,
        //                 darkColor: colorBlue600,
        //                 borderColor: colorBlue400,
        //                 title: "Incorrect\nQues.",
        //               ),
        //               CustomPieChartData(
        //                 value: 40,
        //                 color: colorGreen500,
        //                 darkColor: colorGreen600,
        //                 borderColor: colorGreen400,
        //                 title: "Correct\nQues.",
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //       SizedBox(
        //         height: 10.h,
        //       ),
        //       SizedBox(
        //         height: 145.h,
        //         child: const CommingSoon(
        //           child: ConceptClearedChart(
        //             gainedValue: 222,
        //             totalValue: 400,
        //             bySaarthiLearning: 40,
        //             bySelf: 35,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // )
      ],
    );
  }
}

class _TopHeadingViewPagerPage1 extends StatelessWidget {
  const _TopHeadingViewPagerPage1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: getScreenWidth(context) - 32.w, child: LearnOMeterWidget()),
          // SizedBox(
          //   width: 10.w,
          // ),
          // Expanded(
          //   child: SizedBox(
          //     height: 300.h,
          //     child: CommingSoon(
          //       child: AggregateSubjectList(
          //         listOfAggregateData: [
          //           AggregatedSubjectListModal(subjectName: "Eng", value: 80),
          //           AggregatedSubjectListModal(subjectName: "Math", value: 67),
          //           AggregatedSubjectListModal(subjectName: "Sci", value: 32),
          //           AggregatedSubjectListModal(subjectName: "SST", value: 55),
          //           AggregatedSubjectListModal(subjectName: "Hin", value: 22),
          //           AggregatedSubjectListModal(subjectName: "Guj", value: 16),
          //           AggregatedSubjectListModal(subjectName: "Comp", value: 87),
          //           AggregatedSubjectListModal(subjectName: "Hin", value: 22),
          //           AggregatedSubjectListModal(subjectName: "Guj", value: 16),
          //           AggregatedSubjectListModal(subjectName: "Comp", value: 87),
          //           AggregatedSubjectListModal(subjectName: "Hin", value: 22),
          //           AggregatedSubjectListModal(subjectName: "Guj", value: 16),
          //           AggregatedSubjectListModal(subjectName: "Comp", value: 87),
          //           AggregatedSubjectListModal(subjectName: "Hin", value: 22),
          //           AggregatedSubjectListModal(subjectName: "Guj", value: 16),
          //           AggregatedSubjectListModal(subjectName: "Comp", value: 87),
          //           AggregatedSubjectListModal(subjectName: "Hin", value: 22),
          //           AggregatedSubjectListModal(subjectName: "Guj", value: 16),
          //           AggregatedSubjectListModal(subjectName: "Comp", value: 87),
          //         ],
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

class ViewPagerIndicator extends StatelessWidget {
  const ViewPagerIndicator({
    Key? key,
    required this.index,
    required this.controllerIndex,
  }) : super(key: key);

  final double index;
  final double controllerIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: index == controllerIndex ? 30.w : 10.w,
      height: 4.h,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        color: index == controllerIndex ? colorGrey600 : colorGrey400,
        borderRadius: BorderRadius.circular(40.w),
      ),
    );
  }
}

class HeaderComp extends StatelessWidget {
  HeaderComp({
    Key? key,
  }) : super(key: key);

  final AuthController authController = Get.put(AuthController());

  Widget getUserThumbWidget(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Icon(
        Icons.account_circle_rounded,
        size: 30.w,
        color: colorText163Gray,
      );
    } else {
      return CustomNetworkImage(imageUrl: imageUrl);
    }
  }

  Widget getSchoolThumbWidget(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return SvgPicture.asset(
        imageAssets + 'schoollogo.svg',
        fit: BoxFit.cover,
      );
    } else {
      return CustomNetworkImage(imageUrl: imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      User user = authController.currentUser.value;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30.w),
            child: Container(
              height: 30.w,
              width: 30.w,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: getUserThumbWidget(user.thumb),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Flexible(
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Hello, ${user.name == null ? ('${user.firstName} ${user.lastName}') : ('${user.name}')}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTitle20WhiteBoldStyle.merge(
                  const TextStyle(color: colorHeaderTextColor),
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // InkWell(
              //   onTap: () {},
              //   child: Container(
              //     padding: EdgeInsets.all(7.w),
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(10.w),
              //       border: Border.all(
              //         width: 1,
              //         color: const Color(0xffF4EFF6),
              //       ),
              //     ),
              //     child: const Icon(
              //       Icons.notifications,
              //       color: colorHeaderTextColor,
              //     ),
              //   ),
              // ),
              SizedBox(
                width: 6.w,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 40.w,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.w),
                    border: Border.all(
                      width: 1,
                      color: const Color(0xffF4EFF6),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.w),
                    child: getSchoolThumbWidget(user.school?.logoThumb),
                  ),
                ),
              ),
            ],
          )
        ],
      );
    });
  }
}
