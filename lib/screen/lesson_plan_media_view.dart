import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../theme/colors.dart';
import '../widgets/media/video_player.dart';
import '../widgets/media/youtube_video_player.dart';

class LessonPlanMediaViewPage extends StatefulWidget {
  const LessonPlanMediaViewPage({
    Key? key,
    required this.type,
    required this.mediaUrl,
    required this.title,
    this.startTime = '',
    this.endTime = '',
  }) : super(key: key);

  final String type;
  final String mediaUrl;
  final String title;
  final String startTime;
  final String endTime;

  @override
  State<LessonPlanMediaViewPage> createState() => _LessonPlanMediaViewPageState();
}

class _LessonPlanMediaViewPageState extends State<LessonPlanMediaViewPage> with SingleTickerProviderStateMixin {
  bool videoInitialized = false;
  bool isPlaying = false;

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: widget.type == "videos"
                    ? Center(
                        child: Container(
                          color: colorBlue,
                          child: widget.mediaUrl.contains("youtube") || widget.mediaUrl.contains("youtu.be")
                              ? YoutubeVideoPlayer(
                                  videoUrl: widget.mediaUrl,
                                  startTime: widget.startTime,
                                  endTime: widget.endTime,
                                )
                              : CustomVideoPlayer(
                                  videoUrl: widget.mediaUrl.contains("drive.google.com")
                                      ? widget.mediaUrl
                                          .replaceAll("file/d/", "uc?export=download&id=")
                                          .replaceAll("/view?usp=sharing", "")
                                          .replaceAll("/view", "")
                                      : widget.mediaUrl,
                                  startTime: widget.startTime,
                                  endTime: widget.endTime,
                                ),
                        ),
                      )
                    : widget.type == "link" // || type == "url"
                        ? Center(
                            child: WebView(
                              backgroundColor: Colors.transparent,
                              initialUrl: widget.mediaUrl,
                              javascriptMode: JavascriptMode.unrestricted,
                            ),
                          )
                        : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
