import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/media/media_video.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/media/media_widget.dart';
import '../../theme/colors.dart';
import '../media/media_utils.dart';

class HintSolutionVideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool isYoutubeVideo;
  final String topicName;
  final String thumbUrl;
  final bool isFromAnswerKey;

  const HintSolutionVideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    required this.isYoutubeVideo,
    required this.topicName,
    required this.thumbUrl,
    required this.isFromAnswerKey,
  }) : super(key: key);

  @override
  State<HintSolutionVideoPlayerWidget> createState() => _HintSolutionVideoPlayerWidgetState();
}

class _HintSolutionVideoPlayerWidgetState extends State<HintSolutionVideoPlayerWidget> {
  String getFilteredUrl() {
    if (widget.videoUrl.contains("drive.google.com")) {
      return widget.videoUrl.replaceAll("file/d/", "uc?export=download&id=").replaceAll("/view?usp=sharing", "").replaceAll("/view", "");
    }
    return widget.videoUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.topicName,
                            style: textTitle20WhiteBoldStyle.copyWith(
                              color: colorHeaderTextColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            'Let\'s master with saarthi !',
                            style: textTitle14RegularStyle.copyWith(
                              color: colorDarkText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 32.w,
                      width: 32.w,
                      alignment: AlignmentDirectional.center,
                      decoration: boxDecoration10.copyWith(
                        border: Border.all(color: const Color(0xffF4EFF6), width: 1),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.close,
                        ),
                        iconSize: 16.h,
                        color: colorHeaderTextColor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // widget.isFromAnswerKey
              //     ?
              AppMediaWidget(
                mediaUrl: widget.videoUrl,
                thumbUrl: widget.thumbUrl,
                mediaType: MediaTypes.video,
                // size: getScreenWidth(context).toInt(),
                customWidget: Stack(
                  children: [
                    Container(
                      margin: widget.isFromAnswerKey ? EdgeInsets.only(left: 38.w, right: 38.w) : EdgeInsets.only(left: 15.w, right: 15.w),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        child: MediaVideoThumbnail(
                          videoUrl: widget.videoUrl,
                          size: Size(getScreenWidth(context), 180),
                          thumbnailBoxFit: BoxFit.fill,
                          thumbUrl: widget.thumbUrl,
                        ),
                      ),
                    ),
                    EmptyVideoThumbnail(
                      isWhiteAlpha: true,
                      size: Size(getScreenWidth(context), 180),
                    )
                  ],
                ),
              )
              // :
              //  AppMediaWidget(
              //     mediaUrl: widget.videoUrl,
              //     thumbUrl: widget.thumbUrl,
              //     mediaType: MediaTypes.video,
              //     size: getScreenWidth(context).toInt(),
              //     thumbnailBoxFit: BoxFit.fill,
              //   )
              ,
              widget.isFromAnswerKey
                  ? const SizedBox()
                  : Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 20.h,
                        horizontal: 15.w,
                      ),
                      height: 40.h,
                      width: getScreenWidth(context),
                      alignment: AlignmentDirectional.center,
                      decoration: const BoxDecoration(
                        color: colorHeaderTextColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context, 'backtoTest');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Back to test",
                              style: textTitle18WhiteBoldStyle.merge(
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ));
  }
}
