import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/no_data_found.dart';

import '../../controllers/tests_controller.dart';
import '../../helpers/const.dart';
import '../../model/tests_model/tests_model.dart';

class CompletedTestsPage extends StatefulWidget {
  const CompletedTestsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CompletedTestsPage> createState() => _CompletedTestsPageState();
}

class _CompletedTestsPageState extends State<CompletedTestsPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  var testsController = Get.put(TestsController());
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<TestData>? tests = [];
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
    debugPrint("_refreshData");
    currentPage = 1;
    tests = [];
    _loadMore();
  }

  _loadMore() async {
    bool issuccess = await testsController.getCompletedGeneralTests(context: context, page: currentPage.toString(), limit: "15");
    if (issuccess) {
      if ((testsController.testsCompletedModel.value.tests ?? []).isNotEmpty) {
        currentPage += 1;
        tests?.addAll(testsController.testsCompletedModel.value.tests!);
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
      body: (tests ?? []).isEmpty && testsController.loading.isTrue || !shouldExecute
          ? const Center(
              child: LoadingSpinner(),
            )
          : (tests ?? []).isEmpty && testsController.loading.isFalse
              ? const NoDataCard(
                  title: "Oops...\n No Tests found",
                  description: "No Tests found \nkindly contact your teacher.",
                )
              : Stack(
                  children: [
                    Positioned(
                      bottom: 100.h,
                      right: 20.h,
                      child: SizedBox(
                        width: 180.h,
                        height: 300.h,
                        child: SvgPicture.asset(
                          imageAssets + 'tests/tests_illustration.svg',
                          fit: BoxFit.contain,
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
                          children: const [],
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
}
