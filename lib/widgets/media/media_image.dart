import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/media/zoomable_image_view.dart';

import '../../helpers/const.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../common/custom_network_image.dart';
import 'media_utils.dart';

class MediaImage extends StatelessWidget {
  const MediaImage({
    Key? key,
    required this.thumbUrl,
    required this.imageUrl,
    this.title,
    this.customWidget,
    this.margin,
    this.size = 87,
  }) : super(key: key);

  final String imageUrl;
  final String thumbUrl;
  final String? title;
  final EdgeInsets? margin;
  final int? size;

  /// if you want to use own custom widget for display image then use this parameters
  final Widget? customWidget;

  String getThumbUrl() {
    if (thumbUrl.isNotEmpty) {
      return thumbUrl;
    }
    return imageUrl;
  }

  Widget getThumbWidget() {
    if (thumbUrl.isEmpty && imageUrl.isEmpty) {
      return SvgPicture.asset('${imageAssets}broken.svg');
    } else if (getThumbUrl().isEmpty) {
      return SvgPicture.asset('${imageAssets}broken.svg');
    } else {
      if (isLocalFileUrl(url: imageUrl)) {
        return Image.file(File(imageUrl));
      }
      return CustomNetworkImage(imageUrl: getThumbUrl());
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (imageUrl.isNotEmpty) {
          if (isLocalFileUrl(url: imageUrl)) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ZoomableImageView(
                  imageUrl: '',
                  imageFile: File(imageUrl),
                  title: title ?? "",
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ZoomableImageView(
                  imageUrl: imageUrl,
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
                SizedBox(
                  height: size?.w,
                  width: size?.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: getThumbWidget(),
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
                            const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: sectionTitleColor,
                            ),
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
