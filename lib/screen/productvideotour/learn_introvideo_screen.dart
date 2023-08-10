// ignore_for_file: unused_element, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/learn_controller.dart';
import 'package:saarthi_pedagogy_studentapp/globals.dart';
import 'package:saarthi_pedagogy_studentapp/screen/ItemCards/intro_video_tab.dart';
import 'package:saarthi_pedagogy_studentapp/screen/productvideotour/introvideo_page.dart';
import 'package:wakelock/wakelock.dart';

class LearnIntroVideoScreen extends StatefulWidget {
  const LearnIntroVideoScreen({Key? key}) : super(key: key);

  @override
  State<LearnIntroVideoScreen> createState() => _LearnIntroVideoScreenState();
}

class _LearnIntroVideoScreenState extends State<LearnIntroVideoScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final dashBoardController = Get.put(LearnController());
  var videosLength;
  var videourl;
  var videoUrlEnglish, videoUrlHindi;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    isVideoComplete = false;
    videoControl ??= true;
    isTourVideo = true;
    showBackIcon = false;
    videosLength = (dashBoardController.introVideo.value.data?.videos ?? []).length;
    if (videosLength < 2) {
      if (dashBoardController.introVideo.value.data?.videos?[0].url?.enUS.obs.value != null) {
        videourl = dashBoardController.introVideo.value.data?.videos?[0].url?.enUS.toString();
      } else {
        videourl = dashBoardController.introVideo.value.data?.videos?[0].url?.hiIN.toString();
      }
    } else {
      if (((dashBoardController.introVideo.value.data?.videos ?? [])[0].lang.obs.value ?? []).contains('hi_IN')) {
        videoUrlHindi = dashBoardController.introVideo.value.data?.videos?[0].url?.hiIN.toString();
      } else {
        videoUrlEnglish = dashBoardController.introVideo.value.data?.videos?[0].url?.enUS.toString();
      }
      if (((dashBoardController.introVideo.value.data?.videos ?? [])[1].lang.obs.value ?? []).contains('hi_IN')) {
        videoUrlHindi = dashBoardController.introVideo.value.data?.videos?[1].url?.hiIN.toString();
      } else {
        videoUrlEnglish = dashBoardController.introVideo.value.data?.videos?[1].url?.enUS.toString();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
    isTourVideo = false;
    videoControl = true;
    showBackIcon = false;
    Wakelock.disable();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => videoControl! ? true : false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              videosLength == 1
                  ? IntroVideoPage(lan: videourl)
                  : Column(
                      children: [
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              IntroVideoPage(lan: videoUrlEnglish),
                              IntroVideoPage(lan: videoUrlHindi),
                            ],
                          ),
                        ),
                        IntroVideoTab(tabController: _tabController)
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     IntroVideoTab(tabController: _tabController)
                        //   ],
                        // ),
                        // FooterMenu(notifyParent: refresh, route: worksheetRoute)
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
