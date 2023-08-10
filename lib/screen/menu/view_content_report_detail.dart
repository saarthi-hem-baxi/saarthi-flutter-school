import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/view_content_report_controller.dart';
import '../../model/view_content_report/view_content_report_detail_model.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/common/loading_spinner.dart';
import '../../widgets/view_content_report/view_content_report_chapter_details.dart';
import '../../widgets/view_content_report/view_content_report_details_card.dart';
import '../../widgets/view_content_report/view_content_report_report_status.dart';
import '../../widgets/view_content_report/view_content_report_timeline.dart';

const kTileHeight = 140.0;

class ViewContentReportDetail extends StatefulWidget {
  const ViewContentReportDetail({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  State<ViewContentReportDetail> createState() => _ViewContentReportDetailState();
}

class _ViewContentReportDetailState extends State<ViewContentReportDetail> {
  final viewContentReportController = Get.put(ViewContentReportController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      viewContentReportController.getContentReportDetail(widget.id).then((value) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorExtraLightGreybg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.w),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: sectionTitleColor,
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Obx(() {
                      Data? report = viewContentReportController.viewContentReportDetailModel.value.data;
                      return Text(
                        viewContentReportController.loading.isTrue ? "" : '#${(report?.reportId ?? '')} ${(report?.subject?.name ?? '')}',
                        style: sectionTitleTextStyle.merge(TextStyle(fontSize: 19.sp)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      );
                    }),
                  ),
                  Obx(
                    () => viewContentReportController.loading.isTrue
                        ? const SizedBox()
                        : ReportContentReportStatusWidget(
                            status: viewContentReportController.viewContentReportDetailModel.value.data?.currentStatus ?? '',
                          ),
                  )
                ],
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: colorExtraLightGreybg,
      ),
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          Data? reportData = viewContentReportController.viewContentReportDetailModel.value.data;
          if (viewContentReportController.loading.isTrue || reportData == null) {
            return SizedBox(
              height: 100.h,
              child: const Center(
                child: LoadingSpinner(color: Colors.blue),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  (reportData.currentStatus ?? '').isNotEmpty ? const ViewContentReportTimeline() : const LoadingSpinner(),
                  //report chapter category
                  ViewContentReportChapterCategoryInfo(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Text(
                      'Reported Content',
                      style: textTitle16WhiteRegularStyle.merge(const TextStyle(color: colorHeaderTextColor, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  //REPORTED CONTENT DETAILS CARD
                  ViewContentReportDetailsCard(),
                  reportData.currentStatus == 'notified'
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                          child: Text(
                            'Resolution',
                            style: textTitle16WhiteRegularStyle.merge(const TextStyle(color: colorHeaderTextColor, fontWeight: FontWeight.w700)),
                          ),
                        )
                      : const SizedBox(),
                  reportData.currentStatus == 'notified'
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                          padding: const EdgeInsets.all(15.0),
                          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (viewContentReportController
                                        .viewContentReportDetailModel.value.data?.solution?[(reportData.solution ?? []).length - 1].description ??
                                    ''),
                                style: textTitle14RegularStyle.merge(const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600)),
                              )
                            ],
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            );
          }
        }),
      ),
    );
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
