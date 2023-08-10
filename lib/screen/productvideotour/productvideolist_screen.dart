import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/learn_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/auth/IntroVideo/introvideo.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';
import 'learn_introvideo_screen.dart';

class ProductvideoListScreen extends StatefulWidget {
  const ProductvideoListScreen({Key? key}) : super(key: key);

  @override
  State<ProductvideoListScreen> createState() => _ProductvideoListScreenState();
}

class _ProductvideoListScreenState extends State<ProductvideoListScreen> {
  final dashBoardController = Get.put(LearnController());

  @override
  void initState() {
    super.initState();

    dashBoardController.getIntroVideosList(context);
  }

  void onResume() {
    dashBoardController.getIntroVideosList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product Tour Video",
          style: sectionTitleTextStyle,
        ),
        elevation: 0,
        backgroundColor: colorgray249,
        iconTheme: const IconThemeData(
          color: sectionTitleColor, //change your color here
        ),
      ),
      body: SafeArea(
        child: Obx(
              () => dashBoardController.loading.isTrue
              ? const Center(
            child: LoadingSpinner(color: Colors.blue),
          )
              : Stack(
            children: [
              dashBoardController.introVideoList.value.data == null
                  ? Center(
                child: Text(
                  "Oops...\nSome Went Wrong! Try Again",
                  style: sectionTitleTextStyle,
                  textAlign: TextAlign.center,
                ),
              )
                  : Container(
                alignment: AlignmentDirectional.centerStart,
                margin: marginLeftRight16,
                child: Column(
                  children: [
                    ...(dashBoardController
                        .introVideoList.value.data??[])
                        .mapIndexed(
                          (index, data) {
                        //  ChaptersDatum data = dashBoardController.chaptersData.value.data![index];
                        return MenuItemCard(
                          videoItem: data,
                          bgColor: colorPurpleLight,
                          isFullWidth: true,
                          onTap: () {
                            dashBoardController
                                .introVideo.value.data = data;
                            showTourVideo();
                          },
                        );
                      },
                    ).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showTourVideo() {
    if ((dashBoardController.introVideo.value.data?.videos??[]).isNotEmpty) {
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, anotherAnimation) {
            return const LearnIntroVideoScreen();
          },
          transitionDuration: const Duration(milliseconds: 1000),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
                curve: Curves.easeInOutCubicEmphasized, parent: animation);
            return Align(
              child: SizeTransition(
                sizeFactor: animation,
                child: child,
                axisAlignment: 0.0,
              ),
            );
          }));
    } else {
      Fluttertoast.showToast(msg: 'No product tour videos found');
    }
  }
}

class MenuItemCard extends StatefulWidget {
  const MenuItemCard({
    Key? key,
    required this.bgColor,
    required this.isFullWidth,
    required this.videoItem,
    required this.onTap,
  }) : super(key: key);

  final Color bgColor;
  final bool isFullWidth;
  final VideoData videoItem;
  final VoidCallback onTap;

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(123, 160, 44, 0.12),
              offset: Offset(
                5.0,
                5.0,
              ),
              blurRadius: 10.0,
              spreadRadius: 2.0,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(0.0, 0.0),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 10.w,
            ),
            SizedBox(
              width: widget.isFullWidth
                  ? getScreenWidth(context) / 1.4
                  : getScreenWidth(context) / 3 - 7.w - 16.w,
              child: widget.videoItem.screen?.length == 2
                  ? Row(
                children: [
                  Text(
                    widget.videoItem.screen?.first ?? '',
                    style: textTitle16WhiteBoldStyle.merge(
                        const TextStyle(color: colorWebPanelDarkText)),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    widget.videoItem.screen![1],
                    style: textTitle16WhiteBoldStyle.merge(
                        const TextStyle(color: colorWebPanelDarkText)),
                  ),
                ],
              )
                  : Text(
                widget.videoItem.screen?.first ?? '',
                style: textTitle16WhiteBoldStyle
                    .merge(const TextStyle(color: colorWebPanelDarkText)),
              ),
            ),
            MenuItemIcon(
              iconpath: imageAssets + 'communication_video.png',
              bgColor: widget.bgColor,
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItemIcon extends StatelessWidget {
  const MenuItemIcon({Key? key, required this.iconpath, required this.bgColor})
      : super(key: key);

  final String iconpath;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40.h,
        height: 40.h,
        alignment: AlignmentDirectional.center,
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.black12,
          child: Image.asset(iconpath),
        ));
  }
}