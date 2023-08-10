import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../common/custom_network_image.dart';
import 'media_utils.dart';
import 'media_video_player.dart';

class MediaVideo extends StatelessWidget {
  const MediaVideo({
    Key? key,
    required this.thumbUrl,
    required this.videoUrl,
    this.title,
    this.startTime = "",
    this.endTime = "",
    this.margin,
    this.customWidget,
    this.size = 87,
    this.thumbnailBoxFit = BoxFit.cover,
  }) : super(key: key);

  final String videoUrl;
  final String thumbUrl;
  final String? title;
  final String startTime;
  final String endTime;
  final EdgeInsets? margin;
  final int? size;
  final BoxFit? thumbnailBoxFit;

  /// if you want to use own custom widget for display image then use this parameters
  final Widget? customWidget;

  void onTapVideo(BuildContext context) async {
    dio.Dio dioClient = dio.Dio();
    String url = videoUrl;
    if (isYoutubeUrl(url: videoUrl)) {
      // this process is do for checking is youtube video link is working on it
      try {
        String thumbLink = getThumbUrlFromYoutubeLink(videoUrl: url);
        var response = await dioClient.get(thumbLink);
        if (response.statusCode == 200) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MediaVideoPlayer(
                isYoutubeVideo: true,
                videoUrl: videoUrl,
                startTime: startTime,
                endTime: endTime,
              ),
            ),
          );
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Invalid video url');
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MediaVideoPlayer(
            isYoutubeVideo: false,
            videoUrl: videoUrl,
            startTime: startTime,
            endTime: endTime,
          ),
        ),
      );
    }
  }

  Future getThumbnailPath() async {
    if (isLocalFileUrl(url: videoUrl)) {
      String pathString = await generateThumbnail(url: videoUrl);
      return pathString;
    } else {
      if (isYoutubeUrl(url: videoUrl)) {
        return getThumbUrlFromYoutubeLink(videoUrl: videoUrl);
      } else {
        return thumbUrl;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (videoUrl.isNotEmpty) {
          onTapVideo(context);
        }
      },
      child: customWidget ??
          Container(
            margin: margin,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Container(
                    height: size?.w,
                    width: size?.w,
                    decoration: const BoxDecoration(
                      color: colorPurpleLight,
                    ),
                    child: Stack(
                      children: [
                        MediaVideoThumbnail(
                          videoUrl: videoUrl,
                          thumbUrl: thumbUrl,
                          size: Size((size ?? 0).toDouble(), (size ?? 0).toDouble()),
                          thumbnailBoxFit: thumbnailBoxFit ?? BoxFit.cover,
                        ),
                        EmptyVideoThumbnail(
                          isWhiteAlpha: true,
                          size: Size((size ?? 0).toDouble(), (size ?? 0).toDouble()),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: (title ?? "").isNotEmpty ? 10.h : 0,
                ),
                //display bottom title
                (title ?? "").isNotEmpty
                    ? SizedBox(
                        width: size?.w,
                        height: 28.h,
                        child: Text(
                          title ?? "",
                          style: textTitle12BoldStyle.copyWith(
                            fontWeight: FontWeight.w700,
                            color: sectionTitleColor,
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

class EmptyVideoThumbnail extends StatelessWidget {
  const EmptyVideoThumbnail({
    Key? key,
    required this.isWhiteAlpha,
    this.size = const Size(40, 40),
  }) : super(key: key);

  final bool isWhiteAlpha;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isWhiteAlpha ? Colors.white.withAlpha(125) : Colors.black.withAlpha(0),
      alignment: AlignmentDirectional.center,
      child: Container(
        width: size?.width.w,
        height: size?.height.h,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.zero,
            height: 30.w,
            width: 30.w,
            decoration: const BoxDecoration(
              // color: Colors.transparent,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              gradient: redGradient,
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class MediaVideoThumbnail extends StatelessWidget {
  final String videoUrl;
  final String? thumbUrl;
  final Size size;
  final BoxFit thumbnailBoxFit;

  const MediaVideoThumbnail({
    Key? key,
    required this.videoUrl,
    this.thumbUrl,
    required this.size,
    required this.thumbnailBoxFit,
  }) : super(key: key);

  Future getThumbnailPath() async {
    if (isLocalFileUrl(url: videoUrl)) {
      String pathString = await generateThumbnail(url: videoUrl);
      return pathString;
    } else {
      if (isYoutubeUrl(url: videoUrl)) {
        return getThumbUrlFromYoutubeLink(videoUrl: videoUrl);
      } else if (thumbUrl != null && (thumbUrl ?? "").isNotEmpty) {
        return thumbUrl;
      } else {
        String pathString = await generateThumbnail(url: videoUrl);
        return pathString;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getThumbnailPath(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String path = snapshot.data.toString();
          if (isLocalFileUrl(url: path)) {
            return SizedBox(
              height: size.height.h,
              width: size.width.w,
              child: Image.file(
                File(path),
                fit: thumbnailBoxFit,
              ),
            );
          } else {
            return SizedBox(
              height: size.height.h,
              width: size.width.w,
              child: CustomNetworkImage(
                imageUrl: path,
                fit: thumbnailBoxFit,
              ),
            );
          }
        }
        return SizedBox(
          height: size.height.h,
          width: size.width.w,
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 50.w,
              width: 50.w,
              child: const LoadingSpinner(),
            ),
          ),
        );
      },
    );
  }
}
