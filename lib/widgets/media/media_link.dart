import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/const.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';

class MediaLink extends StatelessWidget {
  const MediaLink({
    Key? key,
    required this.link,
    this.title,
    this.margin,
    this.customWidget,
    this.size = 87,
  }) : super(key: key);

  final String link;
  final String? title;
  final EdgeInsets? margin;
  final int? size;

  /// if you want to use own custom widget for display thumb then use this parameters
  final Widget? customWidget;

  void openLink() async {
    if (!await launchUrl(Uri.parse(link))) {
      Fluttertoast.showToast(msg: 'Cannot open link $link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: openLink,
      child: customWidget ??
          Container(
            margin: margin,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: size?.w,
                  width: size?.w,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: colorPurpleLight,
                  ),
                  alignment: AlignmentDirectional.center,
                  child: SizedBox(
                    height: 53,
                    width: 50,
                    child: SvgPicture.asset(
                      '${imageAssets}lessonplan/link_thumb.svg',
                    ),
                  ),
                ),
                SizedBox(
                  height: (title ?? "").isNotEmpty ? 10.h : 0,
                ),
                (title ?? "").isNotEmpty
                    ? SizedBox(
                        width: size?.w,
                        height: 28.h,
                        child: Text(
                          title ?? "",
                          style: textTitle12BoldStyle.merge(
                            const TextStyle(fontWeight: FontWeight.w700, color: sectionTitleColor),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
    );
  }
}
