import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saarthi_pedagogy_studentapp/globals.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/screen/productvideotour/learn_introvideo_screen.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';

class ChaperRoadmapAppBar extends StatelessWidget {
  const ChaperRoadmapAppBar({
    Key? key,
    required this.title,
    this.onTap,
    this.onRefreshed,
    required this.onActionTap,
    this.introVideoEnabled = true,
  }) : super(key: key);

  final String title;
  final VoidCallback? onTap;
  final VoidCallback? onRefreshed;
  final VoidCallback onActionTap;
  final bool introVideoEnabled;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          SizedBox(width: 5.w),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap ??
                () {
                  Navigator.pop(context);
                },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25.h,
            ),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Text(
              title,
              style: sectionTitleTextStyle
                  .merge(const TextStyle(color: Colors.white)),
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: onActionTap,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w, right: 10.h),
                  child: SvgPicture.asset(
                    imageAssets + "flow_icon.svg",
                  ),
                ),
              ),
              introVideoEnabled
                  ? const SizedBox()
                  : InkWell(
                      onTap: () {
                        videoControl = true;
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder:
                                (context, animation, anotherAnimation) {
                              return const LearnIntroVideoScreen();
                            },
                            transitionDuration:
                                const Duration(milliseconds: 1000),
                            transitionsBuilder:
                                (context, animation, anotherAnimation, child) {
                              animation = CurvedAnimation(
                                  curve: Curves.easeInOutCubicEmphasized,
                                  parent: animation);
                              return Align(
                                child: SizeTransition(
                                  sizeFactor: animation,
                                  child: child,
                                  axisAlignment: 0.0,
                                ),
                              );
                            }));
                      },
                      child: Container(
                        height: 30.w,
                        width: 30.w,
                        margin: EdgeInsets.only(right: 10.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.w),
                          border: Border.all(
                            width: 1,
                            color: const Color(0xffF4EFF6),
                          ),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.w),
                            child: SvgPicture.asset(
                              imageAssets + 'ic_introvideo.svg',
                              allowDrawingOutsideViewBox: true,
                              //color: Colors.white,
                              fit: BoxFit.fitHeight,
                            )
                            // Image.asset(imageAssets + 'ic_introvideo.svg'),
                            ),
                      ),
                    )
            ],
          ),
        ],
      ),
      elevation: 2,
      shadowColor: const Color.fromRGBO(29, 43, 42, 0.2),
      backgroundColor: sectionTitleDarkBgColor,
    );
  }
}
