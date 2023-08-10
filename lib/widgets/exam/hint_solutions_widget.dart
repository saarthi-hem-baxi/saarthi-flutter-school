import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/exam/hint_solution_video_player_widget.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/media/media_video.dart';
import '../../helpers/utils.dart';
import '../../model/tests_model/hint_solution_model.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../common/custom_network_image.dart';
import '../common/custom_webview.dart';
import '../media/media_utils.dart';

class HintSolutionBottomSheetHandler {
  static openHintSolutionSheet({
    required BuildContext context,
    Solution? hintSolutionData,
    bool isHint = false,
    bool isTestSolution = false,
    bool isAnswerKeySolution = false,
    String? topicName = '',
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return _HintSolutionBottomSheetWidget(
          hintSolutionData: hintSolutionData,
          isHint: isHint,
          isTestSolution: isTestSolution,
          isAnswerKeySolution: isAnswerKeySolution,
          topicName: topicName,
        );
      },
    );
  }
}

class _HintSolutionBottomSheetWidget extends StatelessWidget {
  _HintSolutionBottomSheetWidget({Key? key, this.hintSolutionData, this.isHint, this.isTestSolution, this.isAnswerKeySolution, this.topicName})
      : super(key: key);

  final Solution? hintSolutionData;
  final bool? isHint;
  final bool? isTestSolution;
  final bool? isAnswerKeySolution;
  final String? topicName;

  List<SolutionMedia> getfilteredVideoMedia({required List solutionMedia}) {
    List<SolutionMedia> videoMedia = [];
    for (SolutionMedia mediaItem in solutionMedia) {
      if (getMediaTypeFromUrl(mediaItem.url?.enUs ?? '') == MediaTypes.video) {
        videoMedia.add(mediaItem);
      }
    }
    return videoMedia;
  }

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    List<SolutionMedia> filteredVideo = getfilteredVideoMedia(solutionMedia: hintSolutionData?.media ?? []);
    if (isAnswerKeySolution == true) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.w,
            top: 20.h,
            right: 14.w,
            bottom: 16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              filteredVideo.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Videos',
                          style: textTitle16WhiteRegularStyle.copyWith(
                            color: const Color(0xff4D1877),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.cancel,
                            color: const Color(0xff4D1877),
                            size: 25.w,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              filteredVideo.isNotEmpty
                  ? SizedBox(
                      height: 208.h,
                      child: ListView.builder(
                          itemCount: filteredVideo.length,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(_openRoute(
                                  filteredVideo: filteredVideo,
                                  index: index,
                                  topicName: topicName ?? '',
                                  isFromAnswerKey: true,
                                ))
                                    .then((value) {
                                  if (value == 'backtoTest') {
                                    Navigator.pop(context);
                                  }
                                });
                              },
                              child: _HintSolutionCustomMediaWidget(
                                mediaUrl: filteredVideo[index].url?.enUs ?? '',
                                thumbUrl: filteredVideo[index].thumb?.enUs,
                                isAnswerKey: true,
                              ),
                            );
                          }),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (hintSolutionData?.description?.enUs ?? "").isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 18.w),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isHint == true ? 'Hint' : 'Explanation',
                              style: textTitle16WhiteBoldStyle.copyWith(
                                color: colorHeaderTextColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.cancel,
                                color: const Color(0xff4D1877),
                                size: 25.w,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 10.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: (hintSolutionData?.description?.enUs ?? "").isNotEmpty ? 10.h : 0,
                  ),
                  (hintSolutionData?.description?.enUs ?? "").isNotEmpty
                      ? ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 77.h),
                          child: RawScrollbar(
                            controller: _scrollController,
                            thumbColor: colorDarkText,
                            radius: const Radius.circular(20),
                            thickness: 5,
                            thumbVisibility: true,
                            trackVisibility: true,
                            trackColor: const Color(0xffD9D9D9),
                            trackRadius: const Radius.circular(20),
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: ListView(
                                controller: _scrollController,
                                children: [
                                  SizedBox(
                                    width: getScreenWidth(context),
                                    child: CustomWebView(
                                      htmlString: hintSolutionData?.description?.enUs ?? "",
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  SizedBox(
                    height: (hintSolutionData?.description?.enUs ?? "").isNotEmpty ? 10.h : 0,
                  ),
                  filteredVideo.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isHint == true ? 'Videos' : 'Revise concept again',
                              style: textTitle16WhiteBoldStyle.copyWith(
                                color: colorHeaderTextColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            isHint == true || isTestSolution == true && (hintSolutionData?.description?.enUs ?? "").isNotEmpty
                                ? const SizedBox()
                                : InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.cancel,
                                      color: const Color(0xff4D1877),
                                      size: 25.w,
                                    ),
                                  ),
                          ],
                        )
                      : const SizedBox(),
                  filteredVideo.isNotEmpty
                      ? SizedBox(
                          height: 120.h,
                          child: ListView.builder(
                            itemCount: filteredVideo.length,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(_openRoute(
                                    filteredVideo: filteredVideo,
                                    index: index,
                                    topicName: topicName ?? '',
                                    isFromAnswerKey: false,
                                  ))
                                      .then((value) {
                                    if (value == 'backtoTest') {
                                      Navigator.pop(context);
                                    }
                                  });
                                },
                                child: _HintSolutionCustomMediaWidget(
                                  mediaUrl: filteredVideo[index].url?.enUs ?? '',
                                  thumbUrl: filteredVideo[index].thumb?.enUs,
                                  isAnswerKey: false,
                                ),
                              );
                            },
                          ),
                        )
                      : const SizedBox(),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 16.h),
                      height: 40.h,
                      width: getScreenWidth(context),
                      alignment: AlignmentDirectional.center,
                      decoration: const BoxDecoration(
                        color: colorHeaderTextColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isHint == true ? "Got It" : "Continue",
                            style: textTitle18WhiteBoldStyle.merge(
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: isHint == true ? 0 : 10.w,
                          ),
                          isHint == true
                              ? const SizedBox()
                              : const Icon(
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
            ),
          ],
        ),
      );
    }
  }

  Route _openRoute({
    required List<SolutionMedia> filteredVideo,
    required int index,
    required String topicName,
    required bool isFromAnswerKey,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HintSolutionVideoPlayerWidget(
        videoUrl: filteredVideo[index].url?.enUs ?? '',
        isYoutubeVideo: isYoutubeUrl(
          url: filteredVideo[index].url?.enUs ?? '',
        ),
        topicName: topicName,
        thumbUrl: filteredVideo[index].thumb?.enUs ?? '',
        isFromAnswerKey: isFromAnswerKey,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

class _HintSolutionCustomMediaWidget extends StatelessWidget {
  const _HintSolutionCustomMediaWidget({
    Key? key,
    required this.mediaUrl,
    this.thumbUrl,
    required this.isAnswerKey,
  }) : super(key: key);

  final String mediaUrl;
  final String? thumbUrl;
  final bool isAnswerKey;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: isAnswerKey ? 208.h : 120.h,
          margin: EdgeInsets.only(
            right: isAnswerKey ? 16.w : 14.w,
            top: 10.h,
          ),
          width: getScreenWidth(context) * 0.75,
          decoration: const BoxDecoration(
            color: colorExtraLightGreybg,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            child: (thumbUrl ?? '').isEmpty
                ? MediaVideoThumbnail(
                    videoUrl: mediaUrl,
                    size: Size(getScreenWidth(context), getScrenHeight(context)),
                    thumbnailBoxFit: BoxFit.fill,
                  )
                : CustomNetworkImage(
                    imageUrl: isYoutubeUrl(url: mediaUrl) ? getThumbUrlFromYoutubeLink(videoUrl: mediaUrl) : thumbUrl ?? "",
                    fit: BoxFit.fill,
                  ),
          ),
        ),
        Container(
          height: isAnswerKey ? 208.h : 120.h,
          margin: EdgeInsets.only(
            right: 14.w,
            top: 10.h,
          ),
          alignment: Alignment.center,
          width: getScreenWidth(context) * 0.75,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Image.asset(imageAssets + 'communication_video.png'),
        )
      ],
    );
  }
}
