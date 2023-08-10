import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/lucky_draw_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/custominputformatter.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';

import '../../helpers/const.dart';
import 'lucky_draw_thank_you_screen.dart';

class LuckyDrawRegistrationScreen extends StatefulWidget {
  const LuckyDrawRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<LuckyDrawRegistrationScreen> createState() => _LuckyDrawRegistrationScreenState();
}

class _LuckyDrawRegistrationScreenState extends State<LuckyDrawRegistrationScreen> {
  bool hasFocus = false;

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  void onCodeFocusChange() {
    hasFocus = !hasFocus;
    setState(() {});
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
            child: Padding(
              padding: EdgeInsets.only(left: 8, right: 8, top: 10.h),
              child: SizedBox(
                height: getScrenHeight(context) - 20,
                child: Animate(
                  child: Stack(
                    children: [
                      Positioned(
                        top: getScrenHeight(context) / 15,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: getScrenHeight(context) > 700 ? getScrenHeight(context) / 1.4 : getScrenHeight(context) / 1.34,
                          width: getScreenWidth(context),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xff314196), Color(0xffD3559E)],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: getScrenHeight(context) > 800 ? getScrenHeight(context) / 7 : getScrenHeight(context) / 23,
                        child: Image.asset(
                          "${imageAssets}lucky-draw/light_rays.png",
                          width: getScreenWidth(context),
                          height:
                              getScrenHeight(context) - (getScrenHeight(context) > 768 ? getScrenHeight(context) / 3 : getScrenHeight(context) / 9),
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        top: getScrenHeight(context) / 5,
                        left: 10.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 15.w),
                              child: Image.asset(
                                "${imageAssets}lucky-draw/star_1.png",
                                fit: BoxFit.fitWidth,
                                width: 30.w,
                                height: 30.w,
                              )
                                  .animate()
                                  .fadeIn(
                                    curve: Curves.ease,
                                    delay: const Duration(milliseconds: 200),
                                    duration: const Duration(milliseconds: 600),
                                  )
                                  .slideX(
                                    begin: 1,
                                    curve: Curves.ease,
                                    duration: const Duration(milliseconds: 1200),
                                  ),
                            ),
                            SizedBox(
                              height: getScrenHeight(context) / 9,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
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
                                    begin: -0.8,
                                    curve: Curves.ease,
                                    duration: const Duration(milliseconds: 1300),
                                  ),
                            ), // left side star 2
                            SizedBox(
                              height: getScrenHeight(context) / 30,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 40.w),
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
                              height: getScrenHeight(context) / 33,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.w),
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
                                    begin: -1.2,
                                    curve: Curves.ease,
                                    duration: const Duration(milliseconds: 1300),
                                  ),
                            ), // left side star 3
                            SizedBox(
                              height: getScrenHeight(context) / 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 7.w),
                              child: Image.asset(
                                "${imageAssets}lucky-draw/star_6.png", //large
                                width: 22.w, height: 22.w,
                              )
                                  .animate()
                                  .fadeIn(
                                    curve: Curves.ease,
                                    delay: const Duration(milliseconds: 200),
                                    duration: const Duration(milliseconds: 800),
                                  )
                                  .slideY(
                                    begin: -1.2,
                                    curve: Curves.ease,
                                    duration: const Duration(milliseconds: 1300),
                                  ),
                            ), // left side star 4
                          ],
                        ),
                      ),
                      Positioned(
                        top: getScrenHeight(context) / 4.5,
                        right: 0.w,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 35.w),
                              child: Image.asset(
                                "${imageAssets}lucky-draw/star_5.png",
                                width: 24.w,
                                height: 24.w,
                                fit: BoxFit.contain,
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
                            ), //right side star 1
                            SizedBox(
                              height: getScrenHeight(context) / 8,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 15.w),
                              child: Image.asset(
                                "${imageAssets}lucky-draw/star_6.png", //large
                                width: 32.w,
                                height: 32.w,
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
                            ), //right side star 2
                            SizedBox(
                              height: getScrenHeight(context) / 9.5,
                            ),

                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Image.asset(
                                "${imageAssets}lucky-draw/star_6.png", //large
                                width: 22.w, height: 22.w,
                              ).animate().fadeIn(
                                    curve: Curves.ease,
                                    delay: const Duration(milliseconds: 400),
                                    duration: const Duration(milliseconds: 1200),
                                  ),
                            ), // right side star 3me
                            SizedBox(
                              height: getScrenHeight(context) / 100,
                            ),
                            Image.asset(
                              "${imageAssets}lucky-draw/star_3.png",
                            ).animate().fadeIn(
                                  curve: Curves.ease,
                                  delay: const Duration(milliseconds: 400),
                                  duration: const Duration(milliseconds: 1200),
                                ), // right side star 4,
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            Image.asset(
                              "${imageAssets}lucky-draw/man_with_cover.png",
                              fit: BoxFit.contain,
                              width: 168.w,
                              height: 103.h,
                            )
                                .animate()
                                .fadeIn(
                                  delay: const Duration(milliseconds: 200),
                                )
                                .scale(
                                  curve: Curves.easeInOut,
                                  duration: const Duration(milliseconds: 1000),
                                  begin: const Offset(1.4, 1.4),
                                )
                                .slide(
                                  curve: Curves.ease,
                                  duration: const Duration(milliseconds: 1500),
                                  begin: const Offset(0, 4),
                                ),
                            const SizedBox(
                              height: 10,
                            ),
                            Stack(
                              clipBehavior: Clip.antiAlias,
                              children: [
                                Text(
                                  "GET CHANCE TO \n WIN MACBOOK AIR",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 23.sp,
                                    fontFamily: fontFamilyLexend,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                                    .animate(
                                      delay: const Duration(milliseconds: 900),
                                    )
                                    .fadeIn(
                                      duration: const Duration(milliseconds: 1000),
                                    ),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Image.asset(
                              "${imageAssets}lucky-draw/macbook_air.png",
                              fit: BoxFit.contain,
                              width: 180.w,
                              height: 121.h,
                            )
                                .animate(
                                  delay: const Duration(milliseconds: 900),
                                )
                                .fadeIn(
                                  duration: const Duration(milliseconds: 500),
                                )
                                .scale(
                                  curve: Curves.easeInOut,
                                  delay: const Duration(milliseconds: 100),
                                  duration: const Duration(milliseconds: 600),
                                  begin: const Offset(0.1, 0.1),
                                ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Text(
                              "Enter The Code Given\nIn Academic Kitbox",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18.sp,
                                fontFamily: fontFamilyLexend,
                              ),
                              textAlign: TextAlign.center,
                            )
                                .animate(
                                  delay: const Duration(milliseconds: 800),
                                )
                                .fadeIn(
                                  curve: Curves.easeInOut,
                                  duration: const Duration(milliseconds: 300),
                                ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextInputBox(
                              codecontroller: codecontroller,
                              onFocusChange: onCodeFocusChange,
                            )
                                .animate(
                                  delay: const Duration(milliseconds: 200),
                                )
                                .slideY(
                                  begin: -3.00,
                                  curve: Curves.easeInOut,
                                  duration: const Duration(milliseconds: 900),
                                ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 13.w),
                              child: Row(
                                children: [
                                  UnlockMyChannceBtn(
                                    drawCode: codecontroller.text,
                                  )
                                      .animate(
                                        delay: const Duration(milliseconds: 300),
                                      )
                                      .fadeIn(
                                        duration: const Duration(milliseconds: 300),
                                      )
                                      .scaleX(
                                        begin: 1.1,
                                        curve: Curves.easeInOut,
                                        duration: const Duration(milliseconds: 800),
                                      )
                                      .slideY(
                                        begin: 2,
                                        curve: Curves.easeInOut,
                                        duration: const Duration(milliseconds: 900),
                                      ),

                                  SizedBox(
                                    width: 10.w,
                                  ),

                                  SvgPicture.asset(
                                    "${imageAssets}lucky-draw/star_portion.svg", // right side small portion of the star
                                    width: 4.w, height: 2.w,
                                  ).animate().fadeIn(
                                        curve: Curves.ease,
                                        delay: const Duration(milliseconds: 400),
                                        duration: const Duration(milliseconds: 1200),
                                      ), // right side small portion of the star
                                ],
                              ),
                            ),
                            SizedBox(
                              height: getScrenHeight(context) > 700 ? 30.h : 15.h,
                            ),
                            Image.asset(
                              "${imageAssets}lucky-draw/cloud_trimmed.png",
                              fit: BoxFit.contain,
                              width: getScreenWidth(context) - 8.w,
                            ),
                            BottomBtn()
                                .animate(
                                  delay: const Duration(milliseconds: 300),
                                )
                                .fadeIn(
                                  duration: const Duration(milliseconds: 600),
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

class TextInputBox extends StatelessWidget {
  const TextInputBox({
    Key? key,
    required this.codecontroller,
    required this.onFocusChange,
  }) : super(key: key);

  final TextEditingController codecontroller;
  final VoidCallback onFocusChange;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15.w),
        ),
        alignment: Alignment.center,
        child: Focus(
          onFocusChange: (v) {
            onFocusChange();
          },
          child: TextFormField(
            textAlign: TextAlign.center,
            scrollPadding: EdgeInsets.zero,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
              fontFamily: fontFamilyLexend,
            ),
            controller: codecontroller,
            keyboardType: TextInputType.visiblePassword,
            maxLength: 14,
            inputFormatters: [
              FilteringTextInputFormatter.deny(" "),
              FilteringTextInputFormatter.deny("-"),
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
              // FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
              CustomInputFormatter(),
            ],
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.w),
              counterText: "",
              border: InputBorder.none,
              hintText: "0000     0000     0000",
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.3),
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
                fontFamily: fontFamilyLexend,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UnlockMyChannceBtn extends StatelessWidget {
  UnlockMyChannceBtn({
    Key? key,
    required this.drawCode,
  }) : super(key: key);

  final String drawCode;
  final LuckyDrawController luckydrawcontroller = LuckyDrawController();

  void onUnlockChance(BuildContext context) {
    if (drawCode.length != 14) {
      // drawcode has including `-` sign so we compare length is 14
      Fluttertoast.showToast(msg: "Please Enter Valid Draw Code");
    } else {
      luckydrawcontroller.unlockLuckyDraw(luckydrawcode: drawCode).then((value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LuckydrawThankyouScreen(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return InkWell(
        onTap: () {
          luckydrawcontroller.loading.isTrue ? () {} : onUnlockChance(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xff8DE050),
            borderRadius: BorderRadius.circular(15.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: const Offset(0, 3.6),
                blurRadius: 3.6,
              ),
            ],
          ),
          child: Text(
            luckydrawcontroller.loading.isTrue ? "\u0020            Loading...            \u0020" : "UNLOCK MY CHANCE >>",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontFamily: fontFamilyLexend,
            ),
          ),
        ),
      );
    });
  }
}

class BottomBtn extends StatelessWidget {
  BottomBtn({Key? key}) : super(key: key);

  final LuckyDrawController luckyDrawController = Get.put(LuckyDrawController());

  void onDontHaveCode(BuildContext context) {
    luckyDrawController.dontHaveCode().then((value) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            onDontHaveCode(context);
          },
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xffD55DA2),
                borderRadius: BorderRadius.circular(13.w),
              ),
              child: Row(
                children: [
                  Text(
                    "I Don’t Have A Code",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      fontFamily: fontFamilyLexend,
                    ),
                  ),
                  Text(
                    " 🥺",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                      fontFamily: fontFamilyLexend,
                    ),
                  )
                ],
              )),
        ),
        SizedBox(
          width: 10.w,
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xffD55DA2),
              borderRadius: BorderRadius.circular(13.w),
            ),
            child: Row(
              children: [
                Text(
                  "Enter Code Next Time",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    fontFamily: fontFamilyLexend,
                  ),
                ),
                Text(
                  " 👀",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                    fontFamily: fontFamilyLexend,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
