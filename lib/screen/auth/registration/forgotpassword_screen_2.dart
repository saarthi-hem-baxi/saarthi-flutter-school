import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/theme/colors.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';

import 'help_screen.dart';

class ForgotpasswordScreen2 extends StatefulWidget {
  const ForgotpasswordScreen2({
    Key? key,
    required this.email,
    this.fromDynamicLink = false,
    required this.schoolId,
  }) : super(key: key);
  final String email;
  final bool fromDynamicLink;
  final String schoolId;

  @override
  State<ForgotpasswordScreen2> createState() => _ForgotpasswordScreen2State();
}

class _ForgotpasswordScreen2State extends State<ForgotpasswordScreen2> with TickerProviderStateMixin {
  final TextEditingController _otp1Controller = TextEditingController(text: '');
  final TextEditingController _otp2Controller = TextEditingController(text: '');
  final TextEditingController _otp3Controller = TextEditingController(text: '');
  final TextEditingController _otp4Controller = TextEditingController(text: '');

  final focusNodeOTP1 = FocusNode();
  final focusNodeOTP2 = FocusNode();
  final focusNodeOTP3 = FocusNode();
  final focusNodeOTP4 = FocusNode();
  var timerComplete = false;

  AnimationController? _animationController;
  int levelClock = 120;
  final authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: levelClock,
      ),
    );
    _animationController!.forward();
  }

  @override
  void dispose() {
    if (_animationController != null) {
      _animationController!.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 33.h,
          margin: EdgeInsets.only(bottom: 10.h),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HelpScreen(
                    schoolId: widget.schoolId,
                  ),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Having Trouble ?',
                  style: textTitle16StylePoppins.merge(
                    TextStyle(
                      color: const Color(0xff475467),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: fontFamilyPoppins,
                    ),
                  ),
                ),
                Text(' Help !',
                    style: textTitle18StylePoppins.merge(
                      const TextStyle(
                        color: colorGrey800,
                        fontWeight: FontWeight.w500,
                        fontFamily: fontFamilyMedium,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          margin: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => {Navigator.pop(context)},
                  child: Container(
                    height: 32,
                    width: 32,
                    margin: const EdgeInsets.only(right: 20),
                    decoration: const BoxDecoration(
                      color: colorBackground,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_outlined,
                      size: 18,
                      color: colorGrey800,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Column(
                children: [
                  Center(
                    child: Image.asset(
                      '${imageAssets}auth/password.png',
                      width: 30,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text('Verify OTP',
                      textAlign: TextAlign.center,
                      style: textTitle16StylePoppins.merge(const TextStyle(color: colorGrey800, fontSize: 18, fontWeight: FontWeight.w400))),
                ],
              ),
              SizedBox(
                height: 50.h,
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.email,
                      textAlign: TextAlign.center,
                      style: textTitle16StylePoppins.merge(const TextStyle(color: colorBlue700, fontSize: 16, fontWeight: FontWeight.w400))),
                  SizedBox(
                    width: 5.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      height: 22.h,
                      width: 22.w,
                      child: SvgPicture.asset(
                        '${imageAssets}auth/edit_pencil.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 30.h),
                child: Column(
                  children: [
                    SizedBox(
                      height: 36.sp,
                      width: (getScreenWidth(context) / 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(
                            child: Container(
                              width: 36.sp,
                              height: 36.sp,
                              alignment: AlignmentDirectional.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6.sp),
                                ),
                                border: Border.all(color: colorBlue100, width: 1.w),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(1),
                                color: colorBlue25,
                                alignment: AlignmentDirectional.center,
                                child: TextFormField(
                                  style: textTitle20WhiteBoldStyle.merge(
                                    const TextStyle(color: colorWebPanelDarkText),
                                  ),
                                  decoration: const InputDecoration(
                                    counterText: "",
                                    border: InputBorder.none,
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                    fillColor: Colors.white,
                                  ),
                                  maxLength: 1,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(1),
                                  ],
                                  controller: _otp1Controller,
                                  textAlign: TextAlign.center,
                                  textInputAction: TextInputAction.next,
                                  focusNode: focusNodeOTP1,
                                  autofocus: true,
                                  onChanged: (v) {
                                    if (v.length == 1) {
                                      FocusScope.of(context).requestFocus(focusNodeOTP2);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 36.sp,
                            height: 36.sp,
                            alignment: AlignmentDirectional.center,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(6),
                              ),
                              border: Border.all(color: colorBlue100, width: 1.w),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(1),
                              color: colorBlue25,
                              alignment: AlignmentDirectional.center,
                              child: TextFormField(
                                style: textTitle20WhiteBoldStyle.merge(
                                  const TextStyle(color: colorWebPanelDarkText),
                                ),
                                controller: _otp2Controller,
                                decoration: const InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  fillColor: Colors.white,
                                ),
                                maxLength: 1,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(1),
                                ],
                                textAlign: TextAlign.center,
                                textInputAction: TextInputAction.next,
                                focusNode: focusNodeOTP2,
                                onChanged: (v) {
                                  if (v.length == 1) {
                                    FocusScope.of(context).requestFocus(focusNodeOTP3);
                                  } else if (v.isEmpty) {
                                    FocusScope.of(context).requestFocus(focusNodeOTP1);
                                  }
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: 36.sp,
                            height: 36.sp,
                            alignment: AlignmentDirectional.center,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(6),
                              ),
                              border: Border.all(color: colorBlue100, width: 1.w),
                            ),
                            child: Container(
                              // height: 18,
                              // width: 18,
                              margin: const EdgeInsets.all(1),

                              color: colorBlue25,
                              alignment: AlignmentDirectional.center,
                              child: TextFormField(
                                style: textTitle20WhiteBoldStyle.merge(
                                  const TextStyle(color: colorWebPanelDarkText),
                                ),
                                controller: _otp3Controller,
                                decoration: const InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  fillColor: Colors.white,
                                ),
                                maxLength: 1,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(1),
                                ],
                                textAlign: TextAlign.center,
                                focusNode: focusNodeOTP3,
                                textInputAction: TextInputAction.next,
                                onChanged: (v) {
                                  if (v.length == 1) {
                                    FocusScope.of(context).requestFocus(focusNodeOTP4);
                                  } else if (v.isEmpty) {
                                    FocusScope.of(context).requestFocus(focusNodeOTP2);
                                  }
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: 36.sp,
                            height: 36.sp,
                            alignment: AlignmentDirectional.center,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(6),
                              ),
                              border: Border.all(color: colorBlue100, width: 1.w),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(1),
                              color: colorBlue25,
                              alignment: AlignmentDirectional.center,
                              child: TextFormField(
                                style: textTitle20WhiteBoldStyle.merge(
                                  const TextStyle(color: colorWebPanelDarkText),
                                ),
                                controller: _otp4Controller,
                                decoration: const InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  fillColor: Colors.white,
                                ),
                                maxLength: 1,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(1),
                                ],
                                textAlign: TextAlign.center,
                                focusNode: focusNodeOTP4,
                                onChanged: (v) {
                                  if (v.isEmpty) {
                                    FocusScope.of(context).requestFocus(focusNodeOTP3);
                                  } else {
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          !timerComplete
                              ? Row(
                                  children: [
                                    Container(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Text(
                                        "Resend Code in ",
                                        style:
                                            textTitle14BoldStyle.merge(TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: colorBodyText)),
                                      ),
                                    ),
                                    Countdown(
                                      animation: StepTween(
                                        begin: levelClock, // THIS IS A USER ENTERED NUMBER
                                        end: 0,
                                      ).animate(_animationController!),
                                      key: const Key('levelclock'),
                                      callback: (timerValue, secondRem) => {
                                        if (secondRem == 0)
                                          {
                                            _animationController!.stop(),
                                            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                              setState(() {
                                                timerComplete = true;
                                              });
                                            })
                                          }
                                      },
                                    ),
                                  ],
                                )
                              : InkWell(
                                  onTap: () {
                                    if (timerComplete) {
                                      _handleResendOTP();
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: timerComplete ? colorBlue30 : colorDropShadow,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      border: Border.all(
                                        width: 1,
                                        color: colorBlue100,
                                      ),
                                    ),
                                    child: Text(
                                      'Resend OTP',
                                      style: textTitle16StylePoppins.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: fontFamilyMedium,
                                        color: timerComplete ? colorBlue600 : colorBodyText,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() => authController.loadingForgotPassword.isTrue
                  ? const LoadingSpinner()
                  : GestureDetector(
                      onTap: () {
                        submitForm(
                          context,
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 12.h),
                        height: 40.h,
                        width: getScreenWidth(context),
                        padding: const EdgeInsets.all(8),
                        alignment: AlignmentDirectional.center,
                        decoration: const BoxDecoration(
                            gradient: blueDarkGradient1,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(11, 55, 132, 0.2),
                                blurRadius: 10.0,
                              ),
                            ]),
                        child:
                            Text("Verify", style: textTitle16StylePoppins.merge(const TextStyle(color: Colors.white, fontWeight: FontWeight.w500))),
                      ),
                    ))
            ],
          ),
        )),
      ),
    );
  }

  void _handleResendOTP() {
    authController
        .sendOTP(
          context: context,
          email: widget.email,
        )
        .then(
          (value) => resetAll(),
        );
  }

  resetAll() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: levelClock,
      ),
    );

    _animationController!.forward();
    _otp1Controller.text = "";
    _otp2Controller.text = "";
    _otp3Controller.text = "";
    _otp4Controller.text = "";
    timerComplete = false;
    focusNodeOTP1.unfocus();
    Future.delayed(const Duration(seconds: 0), () {
      focusNodeOTP1.requestFocus();
      FocusScope.of(context).requestFocus(focusNodeOTP1);
    });

    setState(() {});
    Fluttertoast.showToast(msg: "Resend code send successfully.");
  }

  submitForm(
    BuildContext context,
  ) {
    if (_otp1Controller.text.trim() == "" ||
        _otp2Controller.text.trim() == "" ||
        _otp3Controller.text.trim() == "" ||
        _otp4Controller.text.trim() == "") {
      Fluttertoast.showToast(msg: "OTP Required");
    } else {
      authController
          .verifyOTP(
        context: context,
        email: widget.email,
        otp: _otp1Controller.text.trim() + _otp2Controller.text.trim() + _otp3Controller.text.trim() + _otp4Controller.text.trim(),
        isFromDynamicLink: widget.fromDynamicLink,
        schoolId: widget.schoolId,
      )
          .then((value) {
        _otp1Controller.text = "";
        _otp2Controller.text = "";
        _otp3Controller.text = "";
        _otp4Controller.text = "";

        focusNodeOTP1.unfocus();
        Future.delayed(const Duration(seconds: 0), () {
          focusNodeOTP1.requestFocus();
          FocusScope.of(context).requestFocus(focusNodeOTP1);
        });
        setState(() {});
      });
    }
  }
}

class Countdown extends AnimatedWidget {
  final Function callback;
  final Animation<int> animation;

  const Countdown({
    required Key key,
    required this.animation,
    required this.callback,
  }) : super(key: key, listenable: animation);

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText = '0${clockTimer.inMinutes.remainder(60)}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    callback(timerText, animation.value);
    return Text(
      timerText,
      style: textTitle14BoldStyle.merge(TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: sectionTitleColor)),
    );
  }
}
