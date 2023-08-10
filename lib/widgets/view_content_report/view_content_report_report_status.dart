import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../helpers/const.dart';
import '../../theme/style.dart';

class ReportContentReportStatusWidget extends StatelessWidget {
  const ReportContentReportStatusWidget({
    Key? key,
    required this.status,
  }) : super(key: key);
  final String status;

  ReportContentData getReportContentData(String status) {
    ReportContentData reportContentData;
    switch (status) {
      case 'notified':
        reportContentData = ReportContentData('RESOLVED', const Color.fromRGBO(243, 251, 239, 1), const Color.fromRGBO(160, 223, 129, 1),
            const Color.fromRGBO(80, 152, 42, 1), imageAssets + 'menu/view_content_report/resolved_icon.svg');
        break;

      case 'unassigned':
        reportContentData = ReportContentData('REPORTED', const Color.fromRGBO(242, 244, 247, 1), const Color.fromRGBO(208, 213, 221, 1),
            const Color.fromRGBO(102, 112, 133, 1), imageAssets + 'menu/view_content_report/reported_icon.svg');

        break;

      case 'assigned':
        reportContentData = ReportContentData('IN PROGRESS', const Color.fromRGBO(255, 241, 224, 1), const Color.fromRGBO(255, 206, 148, 1),
            const Color.fromRGBO(229, 122, 0, 1), imageAssets + 'menu/view_content_report/inprogress_icon.svg');

        break;

      case 'in-progress':
        reportContentData = ReportContentData('IN PROGRESS', const Color.fromRGBO(255, 241, 224, 1), const Color.fromRGBO(255, 206, 148, 1),
            const Color.fromRGBO(229, 122, 0, 1), imageAssets + 'menu/view_content_report/inprogress_icon.svg');

        break;

      case 'assign-to-verify':
        reportContentData = ReportContentData('IN PROGRESS', const Color.fromRGBO(255, 241, 224, 1), const Color.fromRGBO(255, 206, 148, 1),
            const Color.fromRGBO(229, 122, 0, 1), imageAssets + 'menu/view_content_report/inprogress_icon.svg');

        break;

      case 'assigned-to-verify':
        reportContentData = ReportContentData('IN PROGRESS', const Color.fromRGBO(255, 241, 224, 1), const Color.fromRGBO(255, 206, 148, 1),
            const Color.fromRGBO(229, 122, 0, 1), imageAssets + 'menu/view_content_report/inprogress_icon.svg');

        break;

      case 'to-notify':
        reportContentData = ReportContentData('IN PROGRESS', const Color.fromRGBO(255, 241, 224, 1), const Color.fromRGBO(255, 206, 148, 1),
            const Color.fromRGBO(229, 122, 0, 1), imageAssets + 'menu/view_content_report/inprogress_icon.svg');

        break;

      case 'escalated':
        reportContentData = ReportContentData('IN PROGRESS', const Color.fromRGBO(255, 241, 224, 1), const Color.fromRGBO(255, 206, 148, 1),
            const Color.fromRGBO(229, 122, 0, 1), imageAssets + 'menu/view_content_report/inprogress_icon.svg');

        break;

      default:
        reportContentData = ReportContentData('REPORTED', const Color.fromRGBO(243, 251, 239, 1), const Color.fromRGBO(160, 223, 129, 1),
            const Color.fromRGBO(80, 152, 42, 1), imageAssets + 'menu/view_content_report/resolved_icon.svg');
    }
    return reportContentData;
  }

  @override
  Widget build(BuildContext context) {
    ReportContentData reportContentData = getReportContentData(status);

    return Container(
      padding: EdgeInsets.only(
        left: 4.w,
        right: 4.w,
        top: 2.h,
        bottom: 2.h,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: reportContentData.lineColor),
        borderRadius: BorderRadius.all(
          Radius.circular(4.w),
        ),
        color: reportContentData.bgColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: 4.w,
              bottom: (0.9).h,
            ),
            child: SvgPicture.asset(
              reportContentData.iconPath,
              width: 10.h,
              height: 10.h,
            ),
          ),
          Text(
            reportContentData.title.toUpperCase(),
            style: textTitle12BoldStyle.merge(TextStyle(
              color: reportContentData.textColor,
              fontWeight: FontWeight.w700,
              fontSize: 11.sp,
            )),
          )
        ],
      ),
    );
  }
}

class ReportContentData {
  final String title;
  final Color bgColor;
  final Color lineColor;
  final Color textColor;
  final String iconPath;

  ReportContentData(this.title, this.bgColor, this.lineColor, this.textColor, this.iconPath);
}
