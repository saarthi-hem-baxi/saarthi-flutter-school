import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';

import '../../helpers/const.dart';

class LuckydrawThankyouScreen extends StatefulWidget {
  const LuckydrawThankyouScreen({Key? key}) : super(key: key);

  @override
  State<LuckydrawThankyouScreen> createState() => _LuckydrawThankyouScreenState();
}

class _LuckydrawThankyouScreenState extends State<LuckydrawThankyouScreen> {
  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: getScrenHeight(context) - 10.h,
                child: Animate(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 60.h,
                        child: SvgPicture.asset(
                          "${imageAssets}lucky-draw/gradient_bg.svg",
                          width: getScreenWidth(context) - 16.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: getScrenHeight(context) > 768 ? getScrenHeight(context) / 6.3 : getScrenHeight(context) / 8.5,
                        child: Image.asset(
                          "${imageAssets}lucky-draw/light_rays.png",
                          width: getScreenWidth(context),
                          height:
                              getScrenHeight(context) - (getScrenHeight(context) > 768 ? getScrenHeight(context) / 3 : getScrenHeight(context) / 9),
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        top: getScrenHeight(context) / 2.7,
                        left: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 25.w),
                              child: Image.asset(
                                "${imageAssets}lucky-draw/star_2.png",
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
                                  ),
                            ), //left star - 1
                            SizedBox(
                              height: getScrenHeight(context) / 30,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 60.w),
                              child: Transform.rotate(
                                angle: 165,
                                child: SvgPicture.asset(
                                  "${imageAssets}lucky-draw/star_portion.svg",
                                  width: 4.w,
                                  height: 2.w,
                                )
                                    .animate(
                                      delay: Duration.zero,
                                    )
                                    .fadeIn(
                                      curve: Curves.ease,
                                      delay: const Duration(milliseconds: 400),
                                      duration: const Duration(milliseconds: 1200),
                                    ),
                              ),
                            ),
                            SizedBox(
                              height: getScrenHeight(context) / 40,
                            ),
                            Image.asset(
                              "${imageAssets}lucky-draw/star_2.png",
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
                                ), // left star - 2
                          ],
                        ),
                      ),
                      Positioned(
                        top: getScrenHeight(context) / 3.5,
                        right: 0.w,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 40.w),
                              child: Image.asset(
                                "${imageAssets}lucky-draw/star_1.png",
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
                                  ),
                            ), // right star -1
                            SizedBox(
                              height: getScrenHeight(context) / 5.7,
                            ),
                            Image.asset(
                              "${imageAssets}lucky-draw/star_5.png",
                            ).animate().fadeIn(
                                  curve: Curves.ease,
                                  delay: const Duration(milliseconds: 400),
                                  duration: const Duration(milliseconds: 1200),
                                ), // right star - 2
                            SizedBox(
                              height: getScrenHeight(context) / 25,
                            ),
                            Image.asset(
                              "${imageAssets}lucky-draw/star_2.png",
                            ).animate().fadeIn(
                                  curve: Curves.ease,
                                  delay: const Duration(milliseconds: 400),
                                  duration: const Duration(milliseconds: 1200),
                                ), // right star - 3

                            SizedBox(
                              height: getScrenHeight(context) / 35,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 20.w),
                              child: SvgPicture.asset(
                                "${imageAssets}lucky-draw/star_portion.svg", // right side small portion of the star
                                width: 4.w, height: 2.w,
                              ).animate().fadeIn(
                                    curve: Curves.ease,
                                    delay: const Duration(milliseconds: 400),
                                    duration: const Duration(milliseconds: 1200),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 80.h,
                        right: 30.w,
                        child: InkWell(
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
                        top: 25.h,
                        child: Column(
                          children: [
                            Image.asset(
                              "${imageAssets}lucky-draw/box_cover.png",
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              height: 70.h,
                            ),
                            Container(
                              height: 95.w,
                              width: 95.w,
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                              child: Center(
                                child: Image.asset(
                                  "${imageAssets}lucky-draw/125669-party.gif",
                                  fit: BoxFit.cover,
                                  height: 65.w,
                                  width: 65.w,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40.h,
                            ),
                            Text(
                              "THANK YOU FOR THE \n REGISTRATION",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 23.sp,
                                fontFamily: fontFamilyLexend,
                              ),
                              textAlign: TextAlign.center,
                            ).animate().fade(
                                  curve: Curves.ease,
                                  delay: const Duration(milliseconds: 200),
                                  duration: const Duration(milliseconds: 500),
                                ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Text(
                              "We'll Announce The Winner Soon !",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                fontFamily: fontFamilyLexend,
                              ),
                              textAlign: TextAlign.center,
                            ).animate().fade(
                                  curve: Curves.ease,
                                  delay: const Duration(milliseconds: 200),
                                  duration: const Duration(milliseconds: 500),
                                ),
                            SizedBox(
                              height: 90.h,
                            ),
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      "${imageAssets}lucky-draw/cloud_trimmed.png",
                                      fit: BoxFit.contain,
                                      width: getScreenWidth(context) - 8.w,
                                    ),
                                    Container(
                                      height: 50.h,
                                      width: getScreenWidth(context),
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
