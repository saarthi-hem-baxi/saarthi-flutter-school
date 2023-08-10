import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/lucky_draw_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';

import '../../helpers/const.dart';

class LuckydrawThankyouScreen extends StatefulWidget {
  const LuckydrawThankyouScreen({Key? key}) : super(key: key);

  @override
  State<LuckydrawThankyouScreen> createState() => _LuckydrawThankyouScreenState();
}

class _LuckydrawThankyouScreenState extends State<LuckydrawThankyouScreen> {
  bool hasFocus = false;

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  final LuckyDrawController luckydrawcontroller = LuckyDrawController();
  TextEditingController codecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: hasFocus ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
            child: SizedBox(
              height: getScrenHeight(context) - (getScrenHeight(context) > 800 ? 60.h : 30.h),
              child: Animate(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 82.h,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: getScrenHeight(context) * 0.95,
                          maxWidth: getScreenWidth(context) * 0.98,
                        ),
                        child: Image.asset(
                          "${imageAssets}lucky-draw/background_n.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0.h,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: getScreenWidth(context) * 1.02,
                        ),
                        child: Image.asset(
                          "${imageAssets}lucky-draw/cloud_trimmed.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50.h,
                      child: Image.asset(
                        "${imageAssets}lucky-draw/box_cover.png",
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      top: 310.h,
                      left: 30.w,
                      child: Image.asset(
                        "${imageAssets}lucky-draw/star_2.png",
                      ),
                    )
                        .animate()
                        .fadeIn(
                          curve: Curves.ease,
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 600),
                        )
                        .slideY(
                          begin: -1.1,
                          curve: Curves.ease,
                          duration: const Duration(milliseconds: 1300),
                        ), // left star - 1
                    Positioned(
                      top: 250.h,
                      left: 50.w,
                      child: Image.asset(
                        "${imageAssets}lucky-draw/star_2.png",
                      ),
                    )
                        .animate()
                        .fadeIn(
                          curve: Curves.ease,
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 600),
                        )
                        .slideY(
                          begin: -1.1,
                          curve: Curves.ease,
                          duration: const Duration(milliseconds: 1300),
                        ), //left star - 2
                    Positioned(
                      top: 220.h,
                      right: 70.w,
                      child: Image.asset(
                        "${imageAssets}lucky-draw/star_1.png",
                      ),
                    )
                        .animate()
                        .fadeIn(
                          curve: Curves.ease,
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 600),
                        )
                        .slideX(
                          begin: -0.5,
                          curve: Curves.ease,
                          duration: const Duration(milliseconds: 1200),
                        ), // right star -1
                    Positioned(
                      top: 380.h,
                      right: 25.w,
                      child: Image.asset(
                        "${imageAssets}lucky-draw/star_5.png",
                      ),
                    ).animate().fadeIn(
                          curve: Curves.ease,
                          delay: const Duration(milliseconds: 400),
                          duration: const Duration(milliseconds: 1200),
                        ), // right star - 2
                    Positioned(
                      top: 435.h,
                      right: 35.w,
                      child: Image.asset(
                        "${imageAssets}lucky-draw/star_2.png",
                      ),
                    ).animate().fadeIn(
                          curve: Curves.ease,
                          delay: const Duration(milliseconds: 400),
                          duration: const Duration(milliseconds: 1200),
                        ), // right star - 3
                    Positioned(
                      top: 95.h,
                      right: 28.w,
                      child: 
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          size: 23.h,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 230.h,
                      child: 
                      Container(
                        height: 95.h,
                        width: 95.h,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                        child: Center(
                          child: Image.asset(
                            "${imageAssets}lucky-draw/125669-party.gif",
                            height: 64.h,
                            width: 64.h,
                          ),
                        ),
                      ),
                    ).animate().fade(
                          curve: Curves.ease,
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 500),
                        ),
                    Positioned(
                      top: 360.h,
                      child: 
                      Text(
                        "THANK YOU FOR THE \n REGISTRATION",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 23.sp,
                          fontFamily: fontFamilyLexend,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ).animate().fade(
                          curve: Curves.ease,
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 500),
                        ),
                    Positioned(
                      top: 430.h,
                      child: 
                      Text(
                        "We’ll Announce The Winner Soon !",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          fontFamily: fontFamilyLexend,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ).animate().fade(
                          curve: Curves.ease,
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 500),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
