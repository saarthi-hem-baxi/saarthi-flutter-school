import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/const.dart';
import '../../helpers/utils.dart';
import '../../model/communication/get_message_list.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';

class TextMessageWidget extends StatelessWidget {
  const TextMessageWidget({
    Key? key,
    required this.messageData,
    required this.index,
  }) : super(key: key);

  final List<MessageData> messageData;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: getScreenWidth(context) * 0.75,
      padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 10.h),
      child: Align(
        // alignment: (index.isEven ? Alignment.topLeft : Alignment.topRight),
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: getScreenWidth(context) * 0.75),
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12.w, top: 10.h, right: 8.w),
                    child: Text(
                      messageData[index].schoolUser?.name != null
                          ? (messageData[index].schoolUser?.name ?? '')
                          : (messageData[index].schoolUser?.firstName ?? '') + ' ' + (messageData[index].schoolUser?.lastName ?? ''),
                      style: textBody14Style.merge(const TextStyle(color: colorBlueDark, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12.w, right: 8.w, top: 8.h),
                    child: isLink(messageData[index].message ?? '')
                        ? RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: messageData[index].message ?? '',
                                style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    if (await canLaunchUrl(Uri.parse(messageData[index].message ?? ''))) {
                                      await launchUrl(Uri.parse(messageData[index].message ?? ''));
                                    } else {
                                      throw 'Could not launch ';
                                    }
                                  },
                              ),
                            ]),
                          )
                        : Text(
                            messageData[index].message ?? '',
                            style: textTitle14RegularStyle.merge(const TextStyle(color: colorWebPanelDarkText)),
                          ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12.w, right: 8.w, bottom: 8.h),
                    child: Text(
                      getDateTime(messageData[index].date ?? ''),
                      textAlign: TextAlign.end,
                      style: textTitle8darkText8SemiBoldStyle.merge(
                        TextStyle(fontSize: 9.sp, color: colorDisable),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
