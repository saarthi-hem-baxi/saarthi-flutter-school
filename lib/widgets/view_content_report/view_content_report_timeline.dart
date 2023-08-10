import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/view_content_report_controller.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';

class ViewContentReportTimeline extends StatefulWidget {
  const ViewContentReportTimeline({Key? key}) : super(key: key);

  @override
  State<ViewContentReportTimeline> createState() => _ViewContentReportTimelineState();
}

class _ViewContentReportTimelineState extends State<ViewContentReportTimeline> {
  final viewContentReportController = Get.put(ViewContentReportController());

  @override
  void initState() {
    getStatus(status: viewContentReportController.viewContentReportDetailModel.value.data?.currentStatus ?? '');
    super.initState();
  }

  bool isSecond = false;
  bool isThird = false;

  getStatus({required String status}) {
    if (status == 'unassigned') {
      setState(() {
        isSecond = false;
        isThird = false;
      });
    } else if (status == 'assigned' ||
        status == 'in-progress' ||
        status == 'assign-to-verify' ||
        status == 'assigned-to-verify' ||
        status == 'to-notify' ||
        status == 'escalated') {
      setState(() {
        isSecond = true;
      });
    } else if (status == 'notified') {
      setState(() {
        isSecond = true;
        isThird = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76.h,
      margin: EdgeInsets.only(left: 14.w, right: 14.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 28.w, right: 28.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: colorGreen,
                          size: 28.w,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 3.h,
                          margin: EdgeInsets.only(
                            left: 5.w,
                            right: 5.w,
                          ),
                          decoration: BoxDecoration(
                            color: isSecond ? colorGreen : const Color(0xff98A2B3),
                            borderRadius: BorderRadius.circular(20.w),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      isSecond
                          ? Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.check_circle_rounded,
                                color: colorGreen,
                                size: 28.w,
                              ),
                            )
                          : Container(
                              height: 26.w,
                              width: 26.w,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff98A2B3),
                              ),
                            ),
                      Expanded(
                        child: Container(
                          height: 3.h,
                          margin: EdgeInsets.only(
                            left: 5.w,
                            right: 5.w,
                          ),
                          decoration: BoxDecoration(
                            color: isThird ? colorGreen : const Color(0xff98A2B3),
                            borderRadius: BorderRadius.circular(20.w),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      isThird
                          ? Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.check_circle_rounded,
                                color: colorGreen,
                                size: 28.w,
                              ),
                            )
                          : Container(
                              height: 26.w,
                              width: 26.w,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff98A2B3),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: 10.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Issue\nReported',
                  textAlign: TextAlign.center,
                  style: textTitle14RegularStyle.copyWith(
                    color: colorDarkText,
                    fontFamily: fontFamilyNunitoMedium,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  'In Progress',
                  textAlign: TextAlign.center,
                  style: textTitle14RegularStyle.copyWith(
                    color: colorDarkText,
                    fontFamily: fontFamilyNunitoMedium,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  'Resolved',
                  textAlign: TextAlign.center,
                  style: textTitle14RegularStyle.copyWith(
                    color: colorDarkText,
                    fontFamily: fontFamilyNunitoMedium,
                    fontSize: 14.sp,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
