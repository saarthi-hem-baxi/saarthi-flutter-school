import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/media/media_utils.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/media/media_widget.dart';

import '../../controllers/view_content_report_controller.dart';
import '../../model/view_content_report/view_content_report_detail_model.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import 'view_content_report_media.dart';

class ViewContentReportDetailsCard extends StatelessWidget {
  final ViewContentReportController viewContentReportController = Get.put(ViewContentReportController());

  ViewContentReportDetailsCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Data? reportData = viewContentReportController.viewContentReportDetailModel.value.data;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      padding: const EdgeInsets.all(15.0),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ViewReportContentMedia(
            contentDataType: reportData?.content?.contentDataType ?? '',
          ),
          const Divider(
            color: colorFormFieldBorder,
            thickness: 1,
          ),
          Text(
            'Comment',
            style: textTitle14RegularStyle.merge(const TextStyle(
              color: colorHeaderTextColor,
              fontWeight: FontWeight.w700,
            )),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            reportData?.message?.description ?? '',
            style: textTitle14RegularStyle.merge(
              const TextStyle(
                color: colorWebPanelDarkText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          //display user's commented media
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: (reportData?.message?.media ?? []).map(
                (media) {
                  return AppMediaWidget(
                    mediaUrl: media.url ?? "",
                    thumbUrl: media.thumbUrl,
                    mediaType: MediaTypes.image,
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
