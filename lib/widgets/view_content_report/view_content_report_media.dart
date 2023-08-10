import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/media/media_widget.dart';

import '../../controllers/view_content_report_controller.dart';
import '../../model/view_content_report/view_content_report_detail_model.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../common/custom_webview.dart';
import '../media/media_utils.dart';

class ViewReportContentMedia extends StatelessWidget {
  ViewReportContentMedia({
    Key? key,
    required this.contentDataType,
  }) : super(key: key);

  final String contentDataType;
  final ViewContentReportController viewContentReportController = Get.put(ViewContentReportController());

  @override
  Widget build(BuildContext context) {
    Data? data = viewContentReportController.viewContentReportDetailModel.value.data;
    String? type = viewContentReportController.viewContentReportDetailModel.value.data?.content?.type;
    if (type == 'content') {
      if (contentDataType == 'forStudent') {
        return Text(
          (data?.content?.forStudent?.studentInstruction ?? ''),
          style: textTitle14RegularStyle.merge(const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600)),
        );
      } else if (contentDataType == 'forTeacher') {
        return Text(
          (data?.content?.forTeacher?.teacherInstruction ?? ''),
          style: textTitle14RegularStyle.merge(const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600)),
        );
      } else if (contentDataType == 'description') {
        return CustomWebView(htmlString: data?.content?.description?.description ?? "");
      } else if (contentDataType == 'example') {
        return CustomWebView(
          htmlString: data?.content?.example?.description ?? "",
        );
      } else if (contentDataType == 'word') {
        return Text(
          data?.content?.word?.meaning ?? "",
          style: textTitle14RegularStyle.merge(const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w600)),
        );
      } else {
        return const Text('No Data Found');
      }
    } else if (type == 'media') {
      if (contentDataType == 'video') {
        return AppMediaWidget(
          mediaUrl: data?.content?.video?.url ?? '',
          thumbUrl: data?.content?.video?.thumb ?? '',
          mediaType: MediaTypes.video,
        );
      } else if (contentDataType == 'image') {
        return AppMediaWidget(
          mediaUrl: data?.content?.image?.url ?? '',
          thumbUrl: data?.content?.image?.thumb ?? '',
          mediaType: MediaTypes.image,
        );
      } else if (contentDataType == 'pdf') {
        return AppMediaWidget(
          mediaUrl: data?.content?.pdf?.url ?? '',
          mediaType: MediaTypes.pdf,
        );
      } else if (contentDataType == 'document') {
        return AppMediaWidget(
          mediaUrl: data?.content?.document?.url ?? '',
          mediaType: MediaTypes.doc,
        );
      } else if (contentDataType == 'audio') {
        return AppMediaWidget(
          mediaUrl: data?.content?.audio?.url ?? '',
          mediaType: MediaTypes.audio,
        );
      } else if (contentDataType == 'simulation') {
        return AppMediaWidget(
          mediaUrl: data?.content?.simulation?.url ?? '',
          mediaType: MediaTypes.simulation,
        );
      } else if (contentDataType == 'link') {
        return AppMediaWidget(
          mediaUrl: data?.content?.link?.url ?? '',
          mediaType: MediaTypes.link,
        );
      } else if (contentDataType == 'word') {
        return AppMediaWidget(
          mediaUrl: data?.content?.word?.wordMedia?.url ?? '',
          thumbUrl: data?.content?.word?.wordMedia?.thumb ?? '',
        );
      } else {
        return const Text('No Data Found');
      }
    } else if (type == 'question') {
      return CustomWebView(
          htmlString: viewContentReportController.viewContentReportDetailModel.value.data?.content?.question?.questionData?.question ?? "");
    } else {
      return const Text('No Data Found');
    }
  }
}
