import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/urls.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/header.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../helpers/utils.dart';
import '../../../theme/colors.dart';
import '../../controllers/auth_controllers.dart';
import '../../controllers/roadmap_controller.dart';
import '../../theme/style.dart';
import '../../widgets/common/loading_spinner.dart';

class ConceptWebViewPage extends StatefulWidget {
  const ConceptWebViewPage({
    Key? key,
    required this.subjectId,
    required this.chapterId,
    this.onActionHandler,
    this.fromPage = '',
  }) : super(key: key);

  final String subjectId;
  final String chapterId;
  final Function? onActionHandler;
  final String fromPage;

  @override
  State<ConceptWebViewPage> createState() => _ConceptWebViewPageState();
}

class _ConceptWebViewPageState extends State<ConceptWebViewPage> {
  final RoadmapController _roadmapController = Get.put(RoadmapController());
  final AuthController _authController = Get.put(AuthController());

  bool isLoading = false;
  bool isTokenLoaded = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });

    _roadmapController.getClassConceptMapAuthToken(data: {
      "subject": widget.subjectId,
      "chapter": widget.chapterId,
    }).then((value) {
      setState(() {
        isTokenLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getScrenHeight(context),
      width: double.infinity,
      child: Scaffold(
        backgroundColor: colorExtraLightGreybg,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: HeaderCard(
                    title: "Concept Map",
                    onTap: () {
                      if (isTokenLoaded) {
                        Navigator.pop(context);
                        if (widget.fromPage == 'roadmap') {
                          Navigator.pop(context);
                        }
                      }
                    },
                    backEnabled: true,
                    leadingIcon: Icons.cancel_rounded,
                    marginTop: 0,
                  ),
                ),
                widget.fromPage == 'roadmap'
                    ? InkWell(
                        onTap: () {
                          isTokenLoaded ? Navigator.pop(context) : () {};
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.w,
                          ),
                          margin: EdgeInsets.only(right: 10.w),
                          decoration: BoxDecoration(
                            color: colorBlue500,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "View More",
                            style: textTitle14BoldStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            Expanded(
              child: Obx(() {
                if (isTokenLoaded && _roadmapController.loadingConceptMapAuth.isFalse) {
                  return WebView(
                    zoomEnabled: true,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (conntroller) {
                      String userSessionToken = _authController.sessionToken.value;
                      String url = APIUrls().conceptMapUrl + (_roadmapController.conceptMapAuthToken.value) + '?from=${widget.fromPage}';
                      conntroller.loadUrl(url, headers: {"Authorization": "Bearer $userSessionToken"});
                    },
                    javascriptChannels: {
                      JavascriptChannel(
                        name: 'ConceptMapHandler',
                        onMessageReceived: (JavascriptMessage message) async {
                          if (widget.onActionHandler != null && message.message != "") {
                            widget.onActionHandler!(json.decode(message.message)) ?? () {};
                          }
                        },
                      ),
                    },
                  );
                } else {
                  return Column(
                    children: [
                      Text(
                        _roadmapController.conceptMapAuthToken.value,
                        style: const TextStyle(fontSize: 0),
                      ),
                      const LoadingSpinner(),
                    ],
                  );
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
