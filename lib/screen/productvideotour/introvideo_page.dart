// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saarthi_pedagogy_studentapp/globals.dart';

import '../../widgets/media/video_player.dart';
import '../../widgets/media/youtube_video_player.dart';

class IntroVideoPage extends StatefulWidget {
  IntroVideoPage({Key? key, required this.lan}) : super(key: key);

  String lan;

  @override
  State<IntroVideoPage> createState() => _IntroVideoPageState();
}

class _IntroVideoPageState extends State<IntroVideoPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String introVideoUrl = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    introVideoUrl = widget.lan;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void onResume() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          introVideoUrl.contains("youtube") || introVideoUrl.contains("youtu.be")
              ? YoutubeVideoPlayer(
                  videoUrl: introVideoUrl,
                  startTime: "0",
                  endTime: "",
                  isActionBar: videoControl! ? true : false,
                  autoPlay: videoControl! ? false : true,
                )
              : CustomVideoPlayer(
                  videoUrl: introVideoUrl.contains("drive.google.com")
                      ? introVideoUrl.replaceAll("file/d/", "uc?export=download&id=").replaceAll("/view?usp=sharing", "").replaceAll("/view", "")
                      : introVideoUrl,
                  isActionBar: videoControl! ? true : false,
                  startTime: "0",
                  endTime: "",
                  showControls: videoControl! ? true : false,
                  // isfromLocal: isFromLocal,
                ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
