import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/login.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/common/custom_network_image.dart';

class RegistrationPage4 extends StatefulWidget {
  const RegistrationPage4({Key? key, required this.userInputData})
      : super(key: key);

  final Map userInputData;

  @override
  State<RegistrationPage4> createState() => _RegistrationPage4State();
}

class _RegistrationPage4State extends State<RegistrationPage4> {
  double marginHorizontal = 20;
  double boyGirlToContainerDiff = 80;

  void _onLoginTap() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false);
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
              gradient: purpleGradient,
            ),
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
            top: getStatusBarHeight(context) + 10,
            right: getScreenWidth(context) / 20,
            child: Container(
              width: 41.w,
              height: 41.w,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.w)),
              padding: EdgeInsets.all(5.w),
              child: (widget.userInputData['schoolLogo'] ?? "") != ""
                  ? CustomNetworkImage(
                      imageUrl: widget.userInputData['schoolLogo'] ?? "",
                      fit: BoxFit.contain,
                    )
                  : SvgPicture.asset(
                      imageAssets + 'schoollogo.svg',
                      // allowDrawingOutsideViewBox: true,
                      fit: BoxFit.cover,
                    ),
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
                      margin: EdgeInsets.only(
                          top: 100.h + getStatusBarHeight(context)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.sp),
                          bottomRight: Radius.circular(30.sp),
                          topRight: Radius.circular(30.sp),
                          topLeft:
                              Radius.circular((getScrenHeight(context) / 4)),
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
                          Positioned(
                            top: 10.h,
                            right: 20.w,
                            child: Container(
                              width: getScreenWidth(context) - 150.w,
                              alignment: AlignmentDirectional.topEnd,
                              child: Text(
                                widget.userInputData['schoolName'],
                                textAlign: TextAlign.right,
                                style: textError16WhiteBoldStyle.merge(
                                  const TextStyle(
                                    color: colorPink,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: AlignmentDirectional.topEnd,
                            margin: EdgeInsets.only(right: 30.sp, top: 50.sp),
                            child: SvgPicture.asset(
                              imageAssets + 'boy_girl_fly.svg',
                              height: 200.h,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20.h, top: 200.h),
                            padding: EdgeInsets.only(left: 20.h, right: 20.h),
                            alignment: AlignmentDirectional.topStart,
                            child: Column(
                              children: [
                                Container(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Text(
                                    "Thanks for Registration",
                                    style: sectionTitleTextStyle
                                        .merge(TextStyle(fontSize: 24.sp)),
                                  ),
                                ),
                                Container(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Text(
                                    "Your account has been created successfully, please login with email or mobile number to add fun to learning.",
                                    style: textTitle14BoldStyle.merge(TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.normal,
                                        color: colorBodyText)),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _onLoginTap,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 40.h),
                                    child: Container(
                                      height: 38.sp,
                                      width: getScreenWidth(context),
                                      alignment: AlignmentDirectional.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.h),
                                        ),
                                        gradient: redGradient,
                                      ),
                                      child: Text("Login",
                                          style:
                                              textTitle16WhiteBoldStyle.merge(
                                                  TextStyle(fontSize: 16.sp))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
