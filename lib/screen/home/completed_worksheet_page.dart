import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/worksheet_controller.dart';
// import 'package:saarthi_pedagogy_studentapp/model/worksheet_model/worksheet_model.dart';
import 'package:saarthi_pedagogy_studentapp/model/worksheet_model/homework_model_new.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/no_data_found.dart';

import '../../helpers/const.dart';
import '../../theme/colors.dart';
import '../../widgets/common/gradient_circle.dart';
import '../ItemCards/tests_cards.dart';
import '../ItemCards/worksheet_cards.dart';

class CompletedWorksheetPage extends StatefulWidget {
  const CompletedWorksheetPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CompletedWorksheetPage> createState() => _CompletedWorksheetPageState();
}

class _CompletedWorksheetPageState extends State<CompletedWorksheetPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  var workController = Get.put(WorksheetController());
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<Worksheet>? worksheet = [];
  int currentPage = 1;
  bool shouldExecute = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.delayed(Duration.zero, () => {_refreshData()});
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  void onResume() {
    _refreshData();
  }

  _refreshData() async {
    currentPage = 1;
    worksheet = [];
    _loadMore();
  }

  _loadMore() async {
    bool issuccess = await workController.getCompletedWorksheet(
        context: context, page: currentPage.toString(), limit: "15");

    if (issuccess) {
      // if ((workController.worksheetCompletedModel.value.tests ?? []).isNotEmpty) {
      if ((workController.worksheetCompletedModel.value.worksheets ?? [])
          .isNotEmpty) {
        currentPage += 1;
        worksheet
            ?.addAll(workController.worksheetCompletedModel.value.worksheets!);
        shouldExecute = true;
        if (mounted) setState(() {});
        _refreshController.loadComplete();
      } else {
        shouldExecute = true;
        if (mounted) setState(() {});
        _refreshController.loadComplete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (worksheet ?? []).isEmpty && workController.loading.isTrue ||
              !shouldExecute
          ? const Center(
              child: LoadingSpinner(),
            )
          : (worksheet ?? []).isEmpty && workController.loading.isFalse
              ? const NoDataCard(
                  title: "Oops...\n No Worksheet found",
                  description:
                      "No Worksheet found \nkindly contact your teacher.",
                )
              : Stack(
                  children: [
                    const Positioned(
                      left: -100,
                      top: -100,
                      child: GradientCircle(
                        gradient: circleOrangeGradient,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(125),
                          bottomRight: Radius.circular(125),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: SvgPicture.asset(
                        imageAssets + 'worksheet_background.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      right: -120,
                      bottom: -100,
                      child: Transform.rotate(
                        angle: 360,
                        child: const GradientCircle(
                          gradient: circlePurpleGradient,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(125),
                            bottomLeft: Radius.circular(125),
                          ),
                        ),
                      ),
                    ),
                    SmartRefresher(
                      enablePullDown: false,
                      enablePullUp: true,
                      header: const WaterDropHeader(),
                      footer: CustomFooter(
                        builder: (context, mode) {
                          Widget body;
                          if (mode == LoadStatus.idle) {
                            body = const SizedBox();
                          } else if (mode == LoadStatus.loading) {
                            body = const Center(
                              child: LoadingSpinner(),
                            );
                          } else if (mode == LoadStatus.failed) {
                            body = const Text("Load Failed!Click retry!");
                          } else if (mode == LoadStatus.canLoading) {
                            body = const Text("release to load more");
                          } else {
                            body = const SizedBox();
                          }
                          return SizedBox(
                            height: 55.0,
                            child: Center(child: body),
                          );
                        },
                      ),
                      controller: _refreshController,
                      onLoading: _loadMore,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...(worksheet ?? []).map(
                              (worksheet) {
                                return getCardWidget(worksheet);
                              },
                            ).toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  refresh() {
    setState(() {});
  }

  // Widget getCardWidget(Worksheet worksheet) {
  //   if (worksheet.type == 'online-test' || worksheet.type == 'system-generated') {
  //     if (worksheet.precap) {}
  //     return TestsCards(
  //       testDatum: worksheet,
  //       isPending: false,
  //       refreshData: _refreshData,
  //     );
  //   } else {
  //     return WorksheetCards(
  //       worksheetData: worksheet,
  //       isPending: false,
  //       refreshData: _refreshData,
  //     );
  //   }
  // }

  Widget getCardWidget(Worksheet worksheet) {
    if (worksheet.type == 'online-test' ||
        worksheet.type == 'system-generated') {
      return TestsCards(
        testDatum: worksheet,
        isPending: false,
        refreshData: _refreshData,
      );
    } else if (worksheet.precap?.isNotEmpty ?? false) {
      return TestsCards(
        testDatum: worksheet,
        isPending: false,
        refreshData: _refreshData,
      );
    } else {
      return WorksheetCards(
        worksheetData: worksheet,
        isPending: false,
        refreshData: _refreshData,
      );
    }
  }
}
