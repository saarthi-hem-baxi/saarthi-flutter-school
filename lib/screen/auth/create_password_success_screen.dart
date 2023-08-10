import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/login_new_screen.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';

class CreatePasswordSuccessScreenPage extends StatefulWidget {
  const CreatePasswordSuccessScreenPage({Key? key}) : super(key: key);

  @override
  State<CreatePasswordSuccessScreenPage> createState() => _CreatePasswordSuccessScreenPageState();
}

class _CreatePasswordSuccessScreenPageState extends State<CreatePasswordSuccessScreenPage> {
  double marginHorizontal = 20;

  double boyGirlToContainerDiff = 80;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorOrangeLight,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: (getScrenHeight(context) / 1.8),
            alignment: Alignment.topCenter,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                gradient: purpleGradient),
            child: SvgPicture.asset(
              imageAssets + 'gradienteffect.svg',
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: 0.h,
            left: 40.w, //27 is the width of brick.svg
            height: 200.h + getStatusBarHeight(context),
            child: SvgPicture.asset(
              imageAssets + 'auth/vibgyor.svg',
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: getStatusBarHeight(context) + 10.h,
            left: 20.w,
            child: SvgPicture.asset(
              imageAssets + 'saarthilogo.svg',
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.contain,
              height: 50.sp,
            ),
          ),
          Positioned(
            bottom: 0,
            child: SvgPicture.asset(
              imageAssets + 'auth/cs_bottom.svg',
              allowDrawingOutsideViewBox: true,
            ),
          ),
          Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            body: Center(
              child: SizedBox(
                height: getScrenHeight(context),
                child: Column(
                  children: [
                    Container(
                      width: getScreenWidth(context) - (marginHorizontal * 2),
                      // height: centerContainerHeight,
                      margin: EdgeInsets.only(top: 100.h + getStatusBarHeight(context)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.sp),
                          bottomRight: Radius.circular(30.sp),
                          topRight: Radius.circular(30.sp),
                          topLeft: Radius.circular((getScrenHeight(context) / 4)),
                        ),
                        boxShadow: const [
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
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Container(
                            alignment: AlignmentDirectional.topEnd,
                            margin: EdgeInsets.only(right: 30.sp, top: 20.sp),
                            child: SvgPicture.asset(
                              imageAssets + 'boy_girl_fly.svg',
                              height: 200.h,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20.h, top: 180.h),
                            padding: EdgeInsets.only(left: 20.h, right: 20.h),
                            alignment: AlignmentDirectional.topStart,
                            child: Column(
                              children: [
                                Container(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Text(
                                    "Password Reset Successfully...!",
                                    style: sectionTitleTextStyle.merge(TextStyle(fontSize: 24.sp)),
                                  ),
                                ),
                                Container(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Text(
                                    "You can use your new password to login to your account.",
                                    style:
                                        textTitle14BoldStyle.merge(TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: colorBodyText)),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const LoginNewScreen(
                                                  isFromPasswordReset: true,
                                                )),
                                        ModalRoute.withName("/Home"))
                                  },
                                  child: Container(
                                    // alignment: AlignmentDirectional.topEnd,
                                    margin: EdgeInsets.only(top: 40.h),
                                    child: Container(
                                      // height: iconSize36,
                                      // width: iconSize36,
                                      height: 38.sp,
                                      width: getScreenWidth(context),
                                      alignment: AlignmentDirectional.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.h),
                                        ),
                                        gradient: redGradient,
                                      ),
                                      child: Text("Login", style: textTitle16WhiteBoldStyle.merge(TextStyle(fontSize: 16.sp))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Positioned.fill(
                    //   child: SvgPicture.asset(
                    //     imageAssets + 'art_orange.svg',
                    //     allowDrawingOutsideViewBox: true,
                    //     fit: BoxFit.fill,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
