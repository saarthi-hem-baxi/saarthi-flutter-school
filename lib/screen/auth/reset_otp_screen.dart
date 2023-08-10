import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/login.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/auth/circular_icon_btn.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/auth/label_btn.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';

class ResetOTPScreenPage extends StatefulWidget {
  const ResetOTPScreenPage({Key? key, required this.email, required this.contact, required this.loginType}) : super(key: key);

  final String email;
  final String contact;
  final LoginType loginType;

  @override
  State<ResetOTPScreenPage> createState() => _ResetOTPScreenPageState();
}

class _ResetOTPScreenPageState extends State<ResetOTPScreenPage> with TickerProviderStateMixin {
  double marginHorizontal = 20;

  double boyGirlToContainerDiff = 80;

  final TextEditingController _otp1Controller = TextEditingController(text: '');
  final TextEditingController _otp2Controller = TextEditingController(text: '');
  final TextEditingController _otp3Controller = TextEditingController(text: '');
  final TextEditingController _otp4Controller = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();
  final authController = Get.put(AuthController());

  final focusNodeOTP1 = FocusNode();
  final focusNodeOTP2 = FocusNode();
  final focusNodeOTP3 = FocusNode();
  final focusNodeOTP4 = FocusNode();

  var timerComplete = false;

  AnimationController? _animationController;
  int levelClock = 120;
  String timeText = "";

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

  void _handleResendOTP() {
    if (widget.loginType == LoginType.phone) {
      authController.contactResendOTP(contact: widget.contact).then((v) {
        resetAll();
      });
    } else {
      authController
          .sendOTP(
            context: context,
            email: widget.email,
          )
          .then(
            (value) => resetAll(),
          );
    }
  }

  submitForm(
    BuildContext context,
  ) {
    // _animationController!.dispose();
    // if (_formKey.currentState!.validate()) {
    if (_otp1Controller.text.trim() == "" ||
        _otp2Controller.text.trim() == "" ||
        _otp3Controller.text.trim() == "" ||
        _otp4Controller.text.trim() == "") {
      Fluttertoast.showToast(msg: "OTP Required");
    } else {
      String otp = _otp1Controller.text + _otp2Controller.text + _otp3Controller.text + _otp4Controller.text;
      if (widget.loginType == LoginType.phone) {
        authController.verifyLoginOTP(contact: widget.contact, otp: otp).then((value) {
          if (value) {
            showMultiAuthSheet(authController: authController, context: context);
          } else {
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
          }
        });
      } else {
        authController
            .verifyOTP(
          context: context,
          email: widget.email,
          otp: _otp1Controller.text.trim() + _otp2Controller.text.trim() + _otp3Controller.text.trim() + _otp4Controller.text.trim(),
          isFromDynamicLink: false,
          schoolId: '',
        )
            .then((value) {
          if (!value) {
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
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          color: colorPinkLight,
          height: getScrenHeight(context),
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
                bottom: 0,
                child: Container(
                  margin: EdgeInsets.only(left: 12.sp, top: 10.sp),
                  child: SvgPicture.asset(
                    imageAssets + 'auth/resetotp_bottom.svg',
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
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
              Center(
                child: SizedBox(
                  height: getScrenHeight(context),
                  child: Column(
                    children: [
                      Container(
                        width: (getScreenWidth(context) - (marginHorizontal * 2)),
                        // height: centerContainerHeight,
                        margin: EdgeInsets.only(top: 95.h + getStatusBarHeight(context)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30.h),
                            bottomRight: Radius.circular(30.h),
                            topRight: Radius.circular(30.h),
                            topLeft: Radius.circular((getScrenHeight(context) / 4)),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(82, 163, 41, 0.10),
                              offset: Offset(
                                0,
                                2.0,
                              ),
                              blurRadius: 6.0,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Stack(
                            children: [
                              Container(
                                alignment: AlignmentDirectional.topEnd,
                                margin: EdgeInsets.only(right: 30.sp, top: 20.sp),
                                child: SvgPicture.asset(
                                  imageAssets + 'girlwithblock.svg',
                                  // fit: BoxFit.fill,
                                  height: 200.h,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 20.h, top: 180.h),
                                padding: EdgeInsets.only(left: 16.h, right: 16.h),
                                alignment: AlignmentDirectional.topStart,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: AlignmentDirectional.topStart,
                                        child: Text(
                                          widget.loginType == LoginType.phone ? "Enter OTP" : "Enter Reset Password Code",
                                          style: sectionTitleTextStyle.merge(TextStyle(fontSize: 24.sp)),
                                        ),
                                      ),
                                      Container(
                                        alignment: AlignmentDirectional.topStart,
                                        child: Text(
                                          "Please enter the 4 digit code sent to",
                                          style: textTitle14BoldStyle
                                              .merge(TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: colorBodyText)),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                alignment: AlignmentDirectional.center,
                                                width: (getScreenWidth(context) - 170).w,
                                                child: Text(
                                                  widget.loginType == LoginType.phone ? "+91 " + widget.contact : widget.email,
                                                  // minFontSize: 10,
                                                  style: textTitle14BoldStyle.merge(
                                                    const TextStyle(fontWeight: FontWeight.w700, color: colorBodyText),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            LabelButton(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              title: widget.loginType == LoginType.phone ? "Change Mobile Number" : "Change Email",
                                              bgColor: colorPinkLight,
                                              textColor: colorPink,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 30.h, bottom: 10.h),
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
                                                        border: Border.all(color: colorSky, width: 2),
                                                      ),
                                                      child: Container(
                                                        // height: 18,
                                                        // width: 18,
                                                        margin: const EdgeInsets.all(1),

                                                        color: colorSkyLight,
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
                                                          // onFieldSubmitted: (v) {
                                                          //   FocusScope.of(context)
                                                          //       .requestFocus(
                                                          //           focusNodeOTP2);
                                                          // },

                                                          // validator: (value) =>
                                                          //     emptyValidator(
                                                          //         value, "*"),
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
                                                      border: Border.all(color: colorSky, width: 2),
                                                    ),
                                                    child: Container(
                                                      // height: 18,
                                                      // width: 18,
                                                      margin: const EdgeInsets.all(1),

                                                      color: colorSkyLight,
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
                                                        // onFieldSubmitted: (v) {
                                                        //   FocusScope.of(context)
                                                        //       .requestFocus(
                                                        //           focusNodeOTP3);
                                                        // },
                                                        // validator: (value) =>
                                                        //     emptyValidator(
                                                        //         value, "*"),
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
                                                      border: Border.all(color: colorSky, width: 2),
                                                    ),
                                                    child: Container(
                                                      // height: 18,
                                                      // width: 18,
                                                      margin: const EdgeInsets.all(1),

                                                      color: colorSkyLight,
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
                                                        // onFieldSubmitted: (v) {
                                                        //   FocusScope.of(context)
                                                        //       .requestFocus(
                                                        //           focusNodeOTP4);
                                                        // },
                                                        // validator: (value) =>
                                                        //     emptyValidator(
                                                        //         value, "*"),
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
                                                      border: Border.all(color: colorSky, width: 2),
                                                    ),
                                                    child: Container(
                                                      // height: 18,
                                                      // width: 18,
                                                      margin: const EdgeInsets.all(1),

                                                      color: colorSkyLight,
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
                                                          }
                                                        },

                                                        // validator: (value) =>
                                                        //     emptyValidator(
                                                        //         value, "*"),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              // height: 22,

                                              margin: EdgeInsets.only(top: 20.h),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  ...(!timerComplete
                                                      ? [
                                                          Row(
                                                            // mainAxisAlignment:
                                                            //     MainAxisAlignment
                                                            //         .spaceBetween,
                                                            children: [
                                                              Container(
                                                                alignment: AlignmentDirectional.topStart,
                                                                child: Text(
                                                                  "Resend Code in ",
                                                                  style: textTitle14BoldStyle.merge(
                                                                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: colorBodyText)),
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
                                                                          timeText = timerValue;
                                                                          timerComplete = true;
                                                                        });
                                                                      })
                                                                    }
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ]
                                                      : [
                                                          LabelButton(
                                                            onTap: () {
                                                              if (timerComplete) {
                                                                _handleResendOTP();
                                                              }
                                                            },
                                                            title: 'Resend Code',
                                                            bgColor: timerComplete ? colorPinkLight : colorDropShadow,
                                                            textColor: timerComplete ? colorPink : colorBodyText,
                                                          ),
                                                        ]),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: AlignmentDirectional.topEnd,
                                        child: CircularIconButton(
                                          bgGradient: redGradient,
                                          buttonSize: 36.h,
                                          icon: Icons.arrow_forward,
                                          iconSize: 18.h,
                                          onTap: () {
                                            submitForm(context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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

    // (context as _ResetOTPScreenPageState).timeText = timerText;
    return Text(
      timerText,
      style: textTitle14BoldStyle.merge(TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: sectionTitleColor)),
    );
  }
}
