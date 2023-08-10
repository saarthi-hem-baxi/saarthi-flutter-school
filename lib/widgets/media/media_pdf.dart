import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/media/pdf_viewer.dart';

import '../../helpers/const.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import 'media_utils.dart';

class MediaPdf extends StatelessWidget {
  const MediaPdf({
    Key? key,
    required this.pdfUrl,
    this.title,
    this.margin,
    this.customWidget,
    this.size = 87,
  }) : super(key: key);

  final String pdfUrl;
  final String? title;
  final EdgeInsets? margin;
  final int? size;

  /// if you want to use own custom widget for display thumb then use this parameters
  final Widget? customWidget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (pdfUrl.isNotEmpty) {
          if (isLocalFileUrl(url: pdfUrl)) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomPDFViewer(
                  pdfFile: File(pdfUrl),
                  pdfUrl: '',
                  title: '',
                  isFileForm: true,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomPDFViewer(
                  pdfUrl: pdfUrl,
                  title: title ?? "",
                ),
              ),
            );
          }
        }
      },
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
                      '${imageAssets}lessonplan/pdf_thumb.svg',
                      fit: BoxFit.fitHeight,
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
