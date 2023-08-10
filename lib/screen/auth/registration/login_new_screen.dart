import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/globals.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/forgotpassword_screen_1.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/help_screen.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/pages/slider1.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/pages/slider2.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/pages/slider3.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/pages/slider4.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/registration_screen_2.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/reset_otp_screen.dart';
import 'package:saarthi_pedagogy_studentapp/screen/home/bottom_footer_navigation.dart';
import 'package:saarthi_pedagogy_studentapp/theme/colors.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';

import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../model/auth/users.dart';

class LoginNewScreen extends StatefulWidget {
  const LoginNewScreen({
    this.isFromPasswordReset = false,
    Key? key,
  }) : super(key: key);
  final bool isFromPasswordReset;

  @override
  State<LoginNewScreen> createState() => _LoginNewScreenState();
}

class _LoginNewScreenState extends State<LoginNewScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  double marginHorizontal = 20;
  double boyGirlToContainerDiff = 100;
  final TextEditingController _emailorMobileController = TextEditingController(text: '');
  final TextEditingController _passwordController = TextEditingController(text: '');
  final TextEditingController _otpController = TextEditingController(text: '');
  double opacity = 0.0;
  bool isUserEmail = false;
  final authController = Get.put(AuthController());
  final ValueNotifier<double> notifier = ValueNotifier(0);
  int pageCount = 3;
  final PageController _pageController = PageController();
  double currentPage = 0;
  List<String> sliderText = [
    'Leading pre-knowledge\nanalysis system',
    'Anytime, anywhere,\npractice kit',
    'Textbook and learning videos\ncontent access 24 x 7',
    'Personalised guided\nhomework tests'
  ];
  bool isChange = true;
  bool isReverse = false;
  bool _passwordVisible = false;
  List<Widget> _pageList = [];
  late Timer _timer;
  AnimationController? _animationController;
  int levelClock = 120;
  var timerComplete = false;
  bool isNumberChanged = false;
  final ScrollController _scrollController = ScrollController();

  bool isFocusOnLoginEmailPhone = false;
  bool isFocusOnLoginOTPPassword = false;

  bool isShowNextBtn = false;

  @override
  void initState() {
    _pageController.addListener(_onScroll);
    _pageList = [
      SliderOne(page: 0, notifier: notifier),
      SliderTwo(page: 1, notifier: notifier),
      SliderThree(page: 2, notifier: notifier),
      SliderFour(page: 3, notifier: notifier)
    ];
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (currentPage < _pageList.length - 1 && !isReverse) {
        isReverse = false;
        currentPage++;
        setState(() {});
      } else {
        if (currentPage == 0) {
          isReverse = false;
        } else {
          isReverse = true;
          currentPage--;
        }

        setState(() {});
      }
      _pageController.animateToPage(
        currentPage.toInt(),
        duration: const Duration(seconds: 2),
        curve: Curves.ease,
      );
    });
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: levelClock,
      ),
    );
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        showSucessfullToast();
      });
    });
  }

  updateTextUI(bool isTrue) {
    Future.delayed(const Duration(milliseconds: 900), () {
      setState(() {
        isChange = true;
      });
    });
  }

  @override
  void dispose() {
    if (_animationController != null) {
      _animationController!.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    return false;
  }

  void changeOpacity(double currentOpacity) {
    Future.delayed(const Duration(milliseconds: 100), () {
      opacity = currentOpacity;
      if (opacity == 1.0) {
        isShowNextBtn = false;
      }
      setState(() {});
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
    isShowNextBtn = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (WidgetsBinding.instance.window.viewInsets.bottom == 0.0 && _scrollController.hasClients) {
      _scrollController.animateTo(
          //go to top of scroll
          0, //scroll offset to go
          duration: const Duration(milliseconds: 500), //duration of scroll
          curve: Curves.linear //scroll type
          );
    }
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: MediaQuery.of(context).viewInsets.bottom == 0 ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 50),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.w),
                        Expanded(
                          child: Stack(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 1.95,
                                child: Stack(
                                  children: [
                                    PageView.builder(
                                      controller: _pageController,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: ((context, index) => _pageList[index % 4]),
                                      onPageChanged: (v) {
                                        currentPage = v.toDouble();
                                      },
                                    ),
                                    Align(
                                      alignment: const Alignment(0, 0.7),
                                      child: AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 800),
                                        transitionBuilder: (Widget child, Animation<double> animation) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                        child: Text(
                                          sliderText[currentPage.toInt() % 4],
                                          key: ValueKey<String>(
                                            sliderText[currentPage.toInt() % 4],
                                          ),
                                          textAlign: TextAlign.center,
                                          style: textTitle18WhiteBoldStyle.merge(
                                            const TextStyle(
                                              fontFamily: fontFamilyMedium,
                                              color: Color(0xff1D2939),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: const Alignment(0, 0.8),
                                      child: SmoothPageIndicator(
                                        controller: _pageController,
                                        count: _pageList.length,
                                        effect: const ExpandingDotsEffect(
                                          dotHeight: 4,
                                          dotWidth: 6,
                                          spacing: 4,
                                          activeDotColor: Color(0xFF98A2B3),
                                          dotColor: Color(0xFFD0D5DD),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Obx(
                            () => Align(
                              alignment: Alignment.center,
                              child: authController.loading.isTrue
                                  ? const LoadingSpinner()
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: 26.w,
                                              width: 26.w,
                                              child: SvgPicture.asset(
                                                '${imageAssets}auth/user.svg',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Expanded(
                                              child: Focus(
                                                onFocusChange: (v) {
                                                  isFocusOnLoginEmailPhone = !isFocusOnLoginEmailPhone;
                                                  setState(() {});
                                                },
                                                child: TextFormField(
                                                  scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                                                  },
                                                  onFieldSubmitted: (value) {
                                                    onEmailMobileNumberSubmit(value);
                                                  },
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(
                                                      bottom: 6.h,
                                                      top: 2.h,
                                                    ),
                                                    isDense: true,
                                                    filled: true,
                                                    fillColor: Colors.transparent,
                                                    labelText: "Mobile Number / Email",
                                                    counterText: "",
                                                    hintText: "",
                                                    labelStyle: textTitle16StylePoppins.copyWith(
                                                      color: colorGrey600,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: isFocusOnLoginEmailPhone || _emailorMobileController.text.isNotEmpty ? 18.sp : 16.sp,
                                                      fontFamily: isFocusOnLoginEmailPhone || _emailorMobileController.text.isNotEmpty
                                                          ? fontFamilyMedium
                                                          : fontFamilyPoppins,
                                                    ),
                                                    enabledBorder: const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0xffD0D5DD),
                                                      ),
                                                    ),
                                                    focusedBorder: const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0xffD0D5DD),
                                                      ),
                                                    ),
                                                  ),
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
                                                          height: 26.h,
                                                          width: 26.w,
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
                                                                    isFocusOnLoginOTPPassword = !isFocusOnLoginOTPPassword;
                                                                    setState(() {});
                                                                  },
                                                                  child: TextFormField(
                                                                    obscureText: !_passwordVisible,
                                                                    scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                    controller: _passwordController,
                                                                    style: textTitle16StylePoppins.merge(const TextStyle(
                                                                        color: colorGrey700, fontWeight: FontWeight.w400, fontSize: 16)),
                                                                    maxLines: 1,
                                                                    decoration: InputDecoration(
                                                                      contentPadding: EdgeInsets.only(bottom: 6.h, top: 2.h),
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
                                                                        ),
                                                                      ),
                                                                      suffixStyle: const TextStyle(backgroundColor: Colors.green),
                                                                      filled: true,
                                                                      fillColor: Colors.transparent,
                                                                      labelText: "Password",
                                                                      counterText: "",
                                                                      hintText: "",
                                                                      enabledBorder: const UnderlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: Color(0xffD0D5DD),
                                                                        ),
                                                                      ),
                                                                      focusedBorder: const UnderlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: Color(0xffD0D5DD),
                                                                        ),
                                                                      ),
                                                                      labelStyle: textTitle16StylePoppins.copyWith(
                                                                        color: colorGrey600,
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: isFocusOnLoginOTPPassword || _passwordController.text.isNotEmpty
                                                                            ? 18.sp
                                                                            : 16.sp,
                                                                        fontFamily: isFocusOnLoginOTPPassword || _passwordController.text.isNotEmpty
                                                                            ? fontFamilyMedium
                                                                            : fontFamilyPoppins,
                                                                      ),
                                                                    ),
                                                                    keyboardType: TextInputType.text,
                                                                    textInputAction: TextInputAction.done,
                                                                  ),
                                                                ),
                                                              )
                                                            : Expanded(
                                                                child: Focus(
                                                                  onFocusChange: (v) {
                                                                    isFocusOnLoginOTPPassword = !isFocusOnLoginOTPPassword;
                                                                    setState(() {});
                                                                  },
                                                                  child: TextFormField(
                                                                    scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                    controller: _otpController,
                                                                    style: textTitle16StylePoppins.merge(const TextStyle(
                                                                        color: colorGrey700, fontWeight: FontWeight.w400, fontSize: 16)),
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
                                                                      enabledBorder: const UnderlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: Color(0xffD0D5DD),
                                                                        ),
                                                                      ),
                                                                      focusedBorder: const UnderlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: Color(0xffD0D5DD),
                                                                        ),
                                                                      ),
                                                                      labelStyle: textTitle16StylePoppins.copyWith(
                                                                        color: colorGrey600,
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: isFocusOnLoginOTPPassword || _otpController.text.isNotEmpty
                                                                            ? 18.sp
                                                                            : 16.sp,
                                                                        fontFamily: isFocusOnLoginOTPPassword || _otpController.text.isNotEmpty
                                                                            ? fontFamilyMedium
                                                                            : fontFamilyPoppins,
                                                                      ),
                                                                    ),
                                                                    keyboardType: TextInputType.number,
                                                                    textInputAction: TextInputAction.done,
                                                                  ),
                                                                ),
                                                              ),
                                                      ],
                                                    ),
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
                                                                              style: textTitle14BoldStyle.merge(
                                                                                  const TextStyle(fontWeight: FontWeight.w700, color: colorBodyText)),
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
                                                                                      // timeText = timerValue;
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
                                                                            )

                                                                            //  LabelButton(
                                                                            //   onTap: _onResendCode,
                                                                            //   title: 'Resend OTP',
                                                                            //   bgColor: timerComplete ? colorBlue30 : colorDropShadow,
                                                                            //   textColor: timerComplete ? colorBlue600 : colorBodyText,
                                                                            // ),
                                                                            ),
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpScreen(schoolId: ''),
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
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  void sendOtp() {
    authController.loginWithContact(
      contact: _emailorMobileController.text.trim(),
    );
  }

  void _onScroll() {
    notifier.value = _pageController.page ?? 0;
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
          schoolId: '',
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
            .loginWithEmail(
          email: _emailorMobileController.text.trim(),
          password: _passwordController.text.trim(),
        )
            .then((v) {
          if (v) {
            if (authController.tempUserId.isEmpty) {
              showMultiAuthSheet(authController: authController, context: context);
            } else {
              var data = {
                "email": _emailorMobileController.text.toString(),
                "password": _passwordController.text.toString(),
                "tempStudentId": authController.tempUserId.toString()
              };
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegistrationScreen2(
                    userInputData: data,
                    fromAddSchool: false,
                  ),
                ),
              );
            }
          }
        });
      }
    } else {
      String otpVal = emptyValidator(_otpController.text, "OTP Required");
      if (otpVal != "") {
        Fluttertoast.showToast(msg: otpVal);
      } else {
        authController.verifyLoginOTP(contact: _emailorMobileController.text, otp: _otpController.text).then((value) {
          if (value) {
            if (authController.tempUserId.isEmpty) {
              showMultiAuthSheet(authController: authController, context: context);
            } else {
              Map data = {
                "contact": _emailorMobileController.text,
                "loginOTP": int.parse(_otpController.text.toString()),
                "tempStudentId": authController.tempUserId.toString()
              };
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegistrationScreen2(
                    userInputData: data,
                    fromAddSchool: false,
                  ),
                ),
              );
            }
          }
        });
      }
    }
  }

  showMultiAuthSheet({required AuthController authController, required BuildContext context}) {
    _onLoginSucess() async {
      SharedPreferences pref = await SharedPreferences.getInstance();

      pref.setString(userTokenKey, authController.userModal.value.token!);
      if (authController.userModal.value.users?.length == 1) {
        await pref.setString(loginUserDataKey, jsonEncode(authController.userModal.value.users?[0] ?? []));
      }
      await pref.setString(users, jsonEncode(authController.userModal.value.users));
      pref.setBool(loginKey, true);
      _callTotalTimeSpent(authController, context);
    }

    _onSchoolSelect({required User user}) {
      Navigator.pop(context);
      authController
          .updateSession(
        studentUserId: user.id ?? "",
      )
          .then((v) {
        _onLoginSucess();
      });
    }

    if (authController.userModal.value.users != null) {
      if (authController.userModal.value.users!.length > 1) {
        List<User> users = authController.userModal.value.users ?? [];
        showModalBottomSheet(
            backgroundColor: Colors.white,
            context: context,
            builder: (context) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                "Select User Profile",
                                style: textTitle14BoldStyle.merge(
                                    TextStyle(color: colorDarkText, fontFamily: fontFamilyPoppins, fontWeight: FontWeight.w500, fontSize: 14.sp)),
                              ),
                            ),
                            const AddSchoolButton()
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        ...users.mapIndexed((int index, item) {
                          return SchoolListTile(
                            user: authController.userModal.value.users?[index] ?? User(),
                            onTap: () {
                              _onSchoolSelect(user: authController.userModal.value.users?[index] ?? User());
                            },
                            currentUserId: '',
                            isLastItem: index == users.length - 1,
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              );
            });
      } else {
        _onLoginSucess();
      }
    }
  }

  _callTotalTimeSpent(AuthController authController, BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    isTourOnScreenEnabled = pref.getBool(isTourOnScreenEnabledkey);

    if (isTourOnScreenEnabled == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const BottomFooterNavigation()),
        (route) => false,
      );
    } else {
      authController.totalTime().then((value) async {
        pref.setBool(isTourOnLearnScreenkey, authController.totalTimeSpent.value.data?.screenData?.lEARN ?? false);
        pref.setBool(isTourOnSubjectScreenkey, authController.totalTimeSpent.value.data?.screenData?.sUBJECT ?? false);
        pref.setBool(isTourOnChapterScreenkey, authController.totalTimeSpent.value.data?.screenData?.cHAPTERLIST ?? false);
        pref.setBool(isTourOnRoadMapLearnScreenkey, authController.totalTimeSpent.value.data?.screenData?.rOADMAPLEARN ?? false);
        pref.setBool(isTourOnRoadMapHomeworkScreenkey, authController.totalTimeSpent.value.data?.screenData?.rOADMAPHOMEWORK ?? false);
        if (authController.totalTimeSpent.value.data?.minutesReached == true) {
          pref.setBool(isTourOnScreenEnabledkey, true);
        } else {
          pref.setBool(isTourOnScreenEnabledkey, false);
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomFooterNavigation()),
          (route) => false,
        );
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
              overflow: TextOverflow.ellipsis,
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

class AddSchoolButton extends StatelessWidget {
  const AddSchoolButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegistrationScreen2(
              fromAddSchool: false,
              userInputData: const {},
              isFromLoginAddSchool: true,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(5.w),
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          color: colorBlue600,
          borderRadius: BorderRadius.all(
            Radius.circular(6.w),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 2.w,
            ),
            const Icon(
              Icons.add,
              color: Colors.white,
              size: 18,
            ),
            SizedBox(
              width: 3.w,
            ),
            Text(
              "Add Student",
              style: textTitle12StylePoppins.merge(
                const TextStyle(
                  letterSpacing: 0.9,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SchoolListTile extends StatelessWidget {
  const SchoolListTile({
    Key? key,
    required this.currentUserId,
    required this.user,
    required this.onTap,
    this.onProfileTap,
    required this.isLastItem,
  }) : super(key: key);

  final User user;
  final String currentUserId;
  final VoidCallback onTap;
  final VoidCallback? onProfileTap;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            margin: EdgeInsets.symmetric(vertical: 5.h),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
                  child: (user.thumb != null && user.thumb!.isNotEmpty)
                      ? CircleAvatar(backgroundImage: NetworkImage(user.thumb ?? ""))
                      : Icon(
                          Icons.account_circle_rounded,
                          size: 50.w,
                          color: colorText163Gray,
                        ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // user.firstName ?? "",
                        user.name == null ? ('${user.firstName} ${user.lastName}') : ('${user.name}'),
                        style: textTitle14BoldStyle.merge(
                          TextStyle(
                            color: colorBlue600,
                            fontFamily: fontFamilyMedium,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                      Text(
                        user.school?.name ?? "",
                        style: textTitle14BoldStyle
                            .merge(TextStyle(color: colorDarkText, fontFamily: fontFamilyPoppins, fontWeight: FontWeight.w400, fontSize: 14.sp)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Class ${user.userClass?.name} ${user.section?.name}',
                            style: textTitle14BoldStyle
                                .merge(TextStyle(color: colorDarkText, fontFamily: fontFamilyPoppins, fontWeight: FontWeight.w600, fontSize: 14.sp)),
                          ),
                          currentUserId == user.id
                              ? GestureDetector(
                                  onTap: onProfileTap ?? () {},
                                  child: Container(
                                    alignment: AlignmentDirectional.topStart,
                                    child: Container(
                                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6)), gradient: pinkGradient),
                                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Center(
                                            child: Text(
                                              "View Profile",
                                              style: textFormSmallerTitleStyle.merge(
                                                const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          const Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 14.h,
                                  width: 20.w,
                                  child: SvgPicture.asset(
                                    '${imageAssets}right_arrow.svg',
                                    fit: BoxFit.contain,
                                  ),
                                )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          isLastItem
              ? const SizedBox()
              : const Divider(
                  color: colorGrey300,
                  height: 1,
                )
        ],
      ),
    );
  }
}

class ViewPagerIndicator extends StatefulWidget {
  const ViewPagerIndicator({
    Key? key,
    required this.index,
    required this.controllerIndex,
  }) : super(key: key);

  final int index;
  final double controllerIndex;

  @override
  State<ViewPagerIndicator> createState() => _ViewPagerIndicatorState();
}

class _ViewPagerIndicatorState extends State<ViewPagerIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.index == widget.controllerIndex ? 16 : 6,
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: 1.5),
      decoration: BoxDecoration(
        color: widget.index == widget.controllerIndex ? Colors.grey[600] : Colors.grey[400],
        borderRadius: BorderRadius.circular(40),
      ),
    );
  }
}

/// An indicator showing the currently selected page of a PageController
class DotsIndicator extends AnimatedWidget {
  const DotsIndicator({
    Key? key,
    required this.controller,
    required this.itemCount,
    required this.onPageSelected,
    this.color = Colors.transparent,
  }) : super(key: key, listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 8.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  Widget _buildDot(int index, int selectedIdex) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return Center(
      child: Material(
        color: color,
        // type: MaterialType.circle,
        child: Container(
          width: _kDotSize * zoom,
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          decoration: BoxDecoration(
            color: selectedIdex == index ? Colors.grey[600] : Colors.grey[400],
            borderRadius: BorderRadius.circular(40),
          ),
          height: 4,
          child: InkWell(
            onTap: () {
              onPageSelected(index);
              selectedIdex = index;
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int selectedIdex = 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(
        itemCount,
        ((index) => _buildDot(index, selectedIdex)),
      ),
    );
  }
}
