import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/view_content_report_controller.dart';
import '../../helpers/utils.dart';
import '../../model/view_content_report/view_content_report_detail_model.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';

class ViewContentReportChapterCategoryInfo extends StatelessWidget {
  final ViewContentReportController viewContentReportController = Get.put(ViewContentReportController());

  ViewContentReportChapterCategoryInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Data? reportData = viewContentReportController.viewContentReportDetailModel.value.data;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(15.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chapter’s name',
                style: textTitle16WhiteRegularStyle.merge(
                  const TextStyle(
                    color: colorBodyText,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  (reportData?.chapter?.name ?? ''),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: textTitle16WhiteRegularStyle.merge(
                    const TextStyle(
                      color: colorWebPanelDarkText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Category',
                style: textTitle16WhiteRegularStyle.merge(
                  const TextStyle(
                    color: colorBodyText,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Text(
                capitalize((reportData?.content?.type ?? '')),
                style: textTitle16WhiteRegularStyle.merge(
                  const TextStyle(
                    color: colorWebPanelDarkText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Submitted on',
                style: textTitle16WhiteRegularStyle.merge(const TextStyle(color: colorBodyText, fontWeight: FontWeight.w400)),
              ),
              Text(
                (reportData?.createdAt != null ? DateFormat("dd/MM/yy hh:mm a").format(reportData!.createdAt!) : ""),
                style: textTitle16WhiteRegularStyle.merge(
                  const TextStyle(
                    color: colorWebPanelDarkText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
          reportData?.currentStatus == 'notified'
              ? Column(
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Resolved on',
                          style: textTitle16WhiteRegularStyle.merge(
                            const TextStyle(
                              color: colorBodyText,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          (viewContentReportController
                                      .viewContentReportDetailModel.value.data?.solution?[(reportData?.solution ?? []).length - 1].date !=
                                  null
                              ? DateFormat("dd/MM/yy hh:mm a").format(viewContentReportController
                                  .viewContentReportDetailModel.value.data!.solution![(reportData?.solution ?? []).length - 1].date!)
                              : ""),
                          style: textTitle16WhiteRegularStyle.merge(
                            const TextStyle(
                              color: colorWebPanelDarkText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
