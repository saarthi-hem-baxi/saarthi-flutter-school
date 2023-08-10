import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/forgotpassword_screen_1.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/help_screen.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/registration_screen_3.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/reset_otp_screen.dart';
import 'package:saarthi_pedagogy_studentapp/theme/colors.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';

import 'package:saarthi_pedagogy_studentapp/widgets/common/custom_network_image.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';

class RegistrationWithLinkScreen extends StatefulWidget {
  const RegistrationWithLinkScreen({Key? key, required this.schoolId, this.isFromPasswordReset = false}) : super(key: key);
  final String schoolId;
  final bool isFromPasswordReset;

  @override
  State<RegistrationWithLinkScreen> createState() => _RegistrationWithLinkScreenState();
}

class _RegistrationWithLinkScreenState extends State<RegistrationWithLinkScreen> with TickerProviderStateMixin {
  final TextEditingController _emailorMobileController = TextEditingController(text: '');
  final TextEditingController _otpController = TextEditingController(text: '');
  final TextEditingController _passwordController = TextEditingController(text: '');
  bool isUserEmail = false;
  final authController = Get.put(AuthController());

  AnimationController? _animationController;
  int levelClock = 120;
  var timerComplete = false;
  bool _passwordVisible = false;
  double opacity = 0.0;
  bool isNumberChanged = false;

  bool isFocusEmailMobile = false;
  bool isFocusPassword = false;

  bool isShowNextBtn = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      authController.getSchoolDetail(
        schoolId: widget.schoolId,
        isFromRegistrationLink: true,
      );
    });
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: levelClock,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        showSucessfullToast();
      });
    });
  }

  @override
  void dispose() {
    if (_animationController != null) {
      _animationController!.dispose();
    }

    super.dispose();
  }

  void changeOpacity(var currentopacity) {
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        opacity = currentopacity;
        if (opacity == 1.0) {
          isShowNextBtn = false;
        }
      });
    });
  }

  void onEmailMobileNumberSubmit(String value) {
    final isMobileNumber = RegExp(r'^[0-9]+$').hasMatch(value.trim());
    if (isMobileNumber) {
      if (value.length != 10) {
        isUserEmail = false;
        authController.loginType = LoginType.phone;
        Fluttertoast.showToast(msg: "Mobile Number is incorrect");
        changeOpacity(0.0);
      } else {
        isUserEmail = false;
        authController.loginType = LoginType.phone;
        if (value.isEmpty) {
          changeOpacity(0.0);
          levelClock = 120;
        } else {
          _otpController.text = '';
          changeOpacity(1.0);
          if (isNumberChanged) {
            isNumberChanged = false;
            sendOtp();
            resetAll();
          }
        }
      }
    } else {
      String emailval = emailValidator(_emailorMobileController.text);
      if (emailval.isNotEmpty) {
        Fluttertoast.showToast(msg: "Invalid email address");
        changeOpacity(0.0);
      } else {
        isUserEmail = true;
        authController.loginType = LoginType.email;
        if (value.isEmpty) {
          changeOpacity(0.0);
        } else {
          _passwordController.text = '';
          changeOpacity(1.0);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            child: Obx(
              () => authController.schoolLoading.isTrue
                  ? const Center(
                      child: LoadingSpinner(),
                    )
                  : Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),
                            SizedBox(
                              height: 30.h,
                              width: 100.w,
                              child: SvgPicture.asset(
                                '${imageAssets}auth/saarthi_logo.svg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Center(
                              child: Text(
                                "Specially designed for".toUpperCase(),
                                style: textTitle16StylePoppins.merge(
                                  const TextStyle(
                                    color: colorGrey400,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    letterSpacing: 6,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Center(
                              child: Container(
                                // width: 100.w,
                                height: 80.h,
                                padding: EdgeInsets.all(5.w),
                                child: (authController.schoolData['logoThumb'] ?? "") != ""
                                    ? CustomNetworkImage(
                                        imageUrl: authController.schoolData['logoThumb'] ?? "",
                                        fit: BoxFit.contain,
                                      )
                                    : SvgPicture.asset(
                                        '${imageAssets}schoollogo.svg',
                                        // allowDrawingOutsideViewBox: true,
                                        fit: BoxFit.contain,
                                      ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Center(
                              child: Text(authController.schoolData['name'] ?? "",
                                  textAlign: TextAlign.center,
                                  style:
                                      textTitle16StylePoppins.merge(const TextStyle(color: colorGrey800, fontWeight: FontWeight.w500, fontSize: 16))),
                            ),
                            SizedBox(height: 40.h),
                          ],
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 30.h,
                                      width: 30.w,
                                      child: SvgPicture.asset(
                                        '${imageAssets}auth/user.svg',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Focus(
                                        onFocusChange: (v) {
                                          setState(() {
                                            isFocusEmailMobile = !isFocusEmailMobile;
                                          });
                                        },
                                        child: TextFormField(
                                          controller: _emailorMobileController,
                                          style: textTitle16StylePoppins
                                              .merge(const TextStyle(color: colorGrey700, fontWeight: FontWeight.w400, fontSize: 16)),
                                          maxLines: 1,
                                          onChanged: (text) {
                                            if (text.isEmpty) {
                                              changeOpacity(0.0);
                                              isShowNextBtn = false;
                                            } else {
                                              if (opacity != 1.0) {
                                                isShowNextBtn = true;
                                              }
                                            }
                                            isNumberChanged = true;
                                            setState(() {});
                                          },
                                          onFieldSubmitted: (value) {
                                            //put content
                                            onEmailMobileNumberSubmit(value);
                                          },
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(bottom: 6.h, top: 2.h),
                                              isDense: true,
                                              filled: true,
                                              fillColor: Colors.transparent,
                                              labelText: "Mobile Number / Email",
                                              counterText: "",
                                              hintText: "",
                                              labelStyle: textTitle18StylePoppins.copyWith(
                                                color: colorGrey600,
                                                fontWeight: FontWeight.w500,
                                                fontSize: isFocusEmailMobile || _emailorMobileController.text.isNotEmpty ? 18.sp : 16.sp,
                                                fontFamily: isFocusEmailMobile || _emailorMobileController.text.isNotEmpty
                                                    ? fontFamilyMedium
                                                    : fontFamilyPoppins,
                                              ),
                                              errorStyle: textTitle16StylePoppins
                                                  .merge(const TextStyle(color: colorGrey600, fontSize: 12, fontWeight: FontWeight.w500)),
                                              hintStyle: textTitle14StylePoppins
                                                  .merge(const TextStyle(color: colorGrey600, fontSize: 12, fontWeight: FontWeight.w500))),
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.done,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                opacity == 1.0
                                    ? AnimatedOpacity(
                                        opacity: opacity,
                                        duration: const Duration(milliseconds: 200),
                                        child: Column(
                                          children: [
                                            SizedBox(height: 10.h),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: 30.h,
                                                  width: 30.w,
                                                  child: SvgPicture.asset(
                                                    '${imageAssets}auth/unlock.svg',
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                                authController.loginType == LoginType.email
                                                    ? Expanded(
                                                        child: Focus(
                                                          onFocusChange: (v) {
                                                            setState(() {
                                                              isFocusPassword = !isFocusPassword;
                                                            });
                                                          },
                                                          child: TextFormField(
                                                            obscureText: !_passwordVisible,
                                                            scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                            controller: _passwordController,
                                                            style: textTitle16StylePoppins.merge(
                                                                const TextStyle(color: colorGrey700, fontWeight: FontWeight.w400, fontSize: 16)),
                                                            maxLines: 1,
                                                            decoration: InputDecoration(
                                                                contentPadding: EdgeInsets.only(bottom: 6.0, top: 2.h),
                                                                isDense: true,
                                                                suffixIcon: GestureDetector(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        _passwordVisible = !_passwordVisible;
                                                                      });
                                                                    },
                                                                    child: Container(
                                                                      padding: const EdgeInsets.all(12.0),
                                                                      child: SvgPicture.asset(
                                                                        _passwordVisible
                                                                            ? '${imageAssets}auth/password_visible.svg'
                                                                            : '${imageAssets}auth/password_hide.svg',
                                                                        fit: BoxFit.contain,
                                                                      ),
                                                                    )),
                                                                suffixStyle: const TextStyle(backgroundColor: Colors.green),
                                                                filled: true,
                                                                fillColor: Colors.transparent,
                                                                labelText: "Password",
                                                                counterText: "",
                                                                hintText: "",
                                                                labelStyle: textTitle16StylePoppins.copyWith(
                                                                  color: colorGrey600,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: isFocusPassword || _passwordController.text.isNotEmpty ? 18.sp : 16.sp,
                                                                  fontFamily: isFocusPassword || _passwordController.text.isNotEmpty
                                                                      ? fontFamilyMedium
                                                                      : fontFamilyPoppins,
                                                                ),
                                                                errorStyle: textTitle16StylePoppins.merge(
                                                                    const TextStyle(color: colorGrey600, fontSize: 12, fontWeight: FontWeight.w500)),
                                                                hintStyle: textTitle16StylePoppins.merge(
                                                                    const TextStyle(color: colorGrey600, fontSize: 12, fontWeight: FontWeight.w500))),
                                                            keyboardType: TextInputType.text,
                                                            textInputAction: TextInputAction.done,
                                                          ),
                                                        ),
                                                      )
                                                    : Expanded(
                                                        child: Focus(
                                                          onFocusChange: (v) {
                                                            setState(() {
                                                              isFocusPassword = !isFocusPassword;
                                                            });
                                                          },
                                                          child: TextFormField(
                                                            controller: _otpController,
                                                            style: textTitle16StylePoppins.merge(
                                                                const TextStyle(color: colorGrey700, fontWeight: FontWeight.w400, fontSize: 16)),
                                                            maxLines: 1,
                                                            maxLength: 4,
                                                            onChanged: (text) {
                                                              if (text.length >= 4) {
                                                                FocusScope.of(context).requestFocus(FocusNode());
                                                              }
                                                            },
                                                            decoration: InputDecoration(
                                                                contentPadding: EdgeInsets.only(bottom: 6.h, top: 2.h),
                                                                isDense: true,
                                                                filled: true,
                                                                fillColor: Colors.transparent,
                                                                labelText: "OTP",
                                                                counterText: "",
                                                                hintText: "",
                                                                labelStyle: textTitle16StylePoppins.copyWith(
                                                                  color: colorGrey600,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: isFocusPassword || _otpController.text.isNotEmpty ? 18.sp : 16.sp,
                                                                  fontFamily: isFocusPassword || _otpController.text.isNotEmpty
                                                                      ? fontFamilyMedium
                                                                      : fontFamilyPoppins,
                                                                ),
                                                                errorStyle: textTitle16StylePoppins.merge(
                                                                    const TextStyle(color: colorGrey600, fontSize: 12, fontWeight: FontWeight.w500)),
                                                                hintStyle: textTitle16StylePoppins.merge(
                                                                    const TextStyle(color: colorGrey600, fontSize: 12, fontWeight: FontWeight.w500))),
                                                            keyboardType: TextInputType.number,
                                                            textInputAction: TextInputAction.done,
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                            SizedBox(height: 10.h),
                                            authController.loginType == LoginType.email
                                                ? Container(
                                                    margin: const EdgeInsets.only(top: 10),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        InkWell(
                                                          onTap: _onForgotPassword,
                                                          child: Container(
                                                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
                                                            decoration: BoxDecoration(
                                                              color: colorBlue30,
                                                              borderRadius: const BorderRadius.all(
                                                                Radius.circular(10),
                                                              ),
                                                              border: Border.all(width: 1, color: colorBlue100),
                                                            ),
                                                            child: Text(
                                                              'Forgot Password ?',
                                                              style: textTitle16StylePoppins.copyWith(
                                                                color: colorBlue600,
                                                                fontWeight: FontWeight.w500,
                                                                fontFamily: fontFamilyMedium,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    margin: const EdgeInsets.only(top: 10),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        !timerComplete
                                                            ? Row(
                                                                children: [
                                                                  Container(
                                                                    alignment: AlignmentDirectional.topStart,
                                                                    child: Text(
                                                                      "Resend Code in ",
                                                                      style: textTitle14BoldStyle
                                                                          .merge(const TextStyle(fontWeight: FontWeight.w700, color: colorBodyText)),
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
                                                                onTap: _onResendCode,
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
                                                                    )),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                            GestureDetector(
                                              onTap: () {
                                                submitForm(context);
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
                                                child: Text(
                                                  "Get Started",
                                                  style: textTitle16StylePoppins.merge(
                                                    const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                isShowNextBtn
                                    ? InkWell(
                                        onTap: () {
                                          onEmailMobileNumberSubmit(_emailorMobileController.text);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(vertical: 10.h),
                                          height: 40.h,
                                          width: getScreenWidth(context),
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
                                          child: Text(
                                            "Next",
                                            style: textTitle16StylePoppins.merge(
                                              const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HelpScreen(schoolId: widget.schoolId),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Having Trouble ?',
                                  style: textTitle16StylePoppins
                                      .merge(const TextStyle(color: colorgreyDark, fontSize: 14, fontWeight: FontWeight.w400))),
                              Text(' Help !',
                                  style:
                                      textTitle16StylePoppins.merge(const TextStyle(color: colorGrey800, fontSize: 18, fontWeight: FontWeight.w500))),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
            )),
      ),
    );
  }

  void sendOtp() {
    authController.registerWithContact(contact: _emailorMobileController.text.trim(), schoolId: widget.schoolId);
  }

  _onResendCode() {
    if (timerComplete) {
      if (authController.loginType == LoginType.phone) {
        authController.contactResendOTP(contact: _emailorMobileController.text.trim().toString()).then((value) {
          resetAll();
        });
      }
    }
  }

  _onForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForgotpasswordScreen1(
          email: _emailorMobileController.text.toString(),
          fromDynamicLink: true,
          schoolId: widget.schoolId,
        ),
      ),
    );
  }

  resetAll() {
    timerComplete = false;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: levelClock,
      ),
    );

    _animationController!.forward();
    _otpController.text = "";

    setState(() {});
  }

  submitForm(BuildContext context) {
    FocusScope.of(context).unfocus();
    String emailval = emailValidator(_emailorMobileController.text);

    if (authController.loginType == LoginType.email) {
      bool passwordVal = checkPasswordvalidation(password: _passwordController.text, confirmPassword: _passwordController.text);

      if (emailval != "") {
        Fluttertoast.showToast(msg: emailval);
      } else if (passwordVal) {
        authController
            .loginWithEmailDynamicLink(
                email: _emailorMobileController.text.trim(), password: _passwordController.text.trim(), schoolId: widget.schoolId)
            .then((v) {
          if (v) {
            var data = {
              "email": _emailorMobileController.text.toString(),
              "password": _passwordController.text.toString(),
              "tempStudentId": authController.tempUserId.toString()
            };
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegistrationScreen3(
                  userInputData: data,
                  fromAddSchool: false,
                  schoolId: widget.schoolId,
                  fromRegitrationLink: true,
                ),
              ),
            );
          }
        });
      }
    } else {
      authController.verifyLoginOTP(contact: _emailorMobileController.text, otp: _otpController.text).then((value) {
        if (value) {
          String otpVal = emptyValidator(_otpController.text, "OTP Required");
          if (otpVal != "") {
            Fluttertoast.showToast(msg: otpVal);
          } else {
            Map data = {
              "contact": _emailorMobileController.text,
              "loginOTP": int.parse(_otpController.text.toString()),
              "tempStudentId": authController.tempUserId.toString()
            };
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegistrationScreen3(
                  userInputData: data,
                  fromAddSchool: false,
                  schoolId: widget.schoolId,
                  fromRegitrationLink: true,
                ),
              ),
            );
          }
        }
      });
    }
  }

  void showSucessfullToast() {
    FToast fToast;
    fToast = FToast();
    fToast.init(context);
    Widget toast = Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: colorGreen100,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20.h,
            width: 20.w,
            child: SvgPicture.asset(
              '${imageAssets}toast_right.svg',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            width: 6.w,
          ),
          Text("Your password has been reset successfully.",
              style: textTitle14StylePoppins.merge(const TextStyle(color: colorGrey600, fontWeight: FontWeight.w400))),
        ],
      ),
    );
    if (widget.isFromPasswordReset) {
      fToast.showToast(
          child: toast,
          gravity: ToastGravity.SNACKBAR,
          toastDuration: const Duration(seconds: 2),
          positionedToastBuilder: (context, child) {
            return Positioned(
              child: child,
              right: 16,
              bottom: 40,
              left: 16.0,
            );
          });
    }
  }
}
