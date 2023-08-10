import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/media/media_widget.dart';

import '../../helpers/const.dart';
import '../../helpers/utils.dart';
import '../../model/communication/get_message_list.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';

class DynamicGridItem extends StatefulWidget {
  const DynamicGridItem({
    Key? key,
    required this.context,
    required this.messageData,
    required this.index,
    required this.gridCount,
    required this.updateDownloadUI,
  }) : super(key: key);

  final BuildContext context;
  final List<MessageData> messageData;
  final int index;
  final int gridCount;
  final Function updateDownloadUI;

  @override
  State<DynamicGridItem> createState() => _DynamicGridItemState();
}

class _DynamicGridItemState extends State<DynamicGridItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 10.h),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: ((getScreenWidth(context) * 0.78) / 3) * widget.gridCount,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12.w, top: 10.h, right: 8.w),
                child: Text(
                  // (widget.messageData[widget.index].schoolUser?.firstName ??
                  //         '') +
                  //     ' ' +
                  widget.messageData[widget.index].schoolUser?.name != null
                      ? (widget.messageData[widget.index].schoolUser?.name ?? '')
                      : (widget.messageData[widget.index].schoolUser?.firstName ?? '') +
                          ' ' +
                          (widget.messageData[widget.index].schoolUser?.lastName ?? ''),
                  style: textBody14Style.merge(const TextStyle(color: colorBlueDark, fontWeight: FontWeight.bold)),
                ),
              ),
              ((widget.messageData)[widget.index].message ?? '').isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.only(left: 12.w, right: 8.w, top: 8.h),
                      child: Text(
                        widget.messageData[widget.index].message ?? '',
                        style: textTitle14RegularStyle.merge(const TextStyle(color: colorWebPanelDarkText)),
                      ),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.gridCount,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: widget.messageData[widget.index].media?.length,
                  itemBuilder: (context, innerIndex) {
                    return AppMediaWidget(
                      mediaUrl: widget.messageData[widget.index].media?[innerIndex].url ?? "",
                      thumbUrl: widget.messageData[widget.index].media?[innerIndex].thumb,
                      margin: const EdgeInsets.only(top: 5),
                      size: 75,
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 12.w,
                  right: 8.w,
                  bottom: 10.h,
                  top: 5.h,
                ),
                child: Text(
                  getDateTime(widget.messageData[widget.index].date ?? ''),
                  textAlign: TextAlign.end,
                  style: textTitle8darkText8SemiBoldStyle.merge(
                    TextStyle(fontSize: 9.sp, color: colorDisable),
                  ),
                ),
              ),
            ],
          ),
          // ),
        ),
      ),
    );
  }
}
