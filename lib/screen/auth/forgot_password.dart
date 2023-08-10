import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/reset_otp_screen.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/auth/circular_icon.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/auth/circular_icon_btn.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  double marginHorizontal = 20;

  double boyGirlToContainerDiff = 40;
  final TextEditingController _emailController = TextEditingController(text: ''); //'pramesh.kamalia@saarthipedagogy.com');
  final _formKey = GlobalKey<FormState>();
  final authController = Get.put(AuthController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  submitForm(BuildContext context) {
    String emailval = emailValidator(_emailController.text);
    if (emailval != "") {
      Fluttertoast.showToast(msg: emailval);
    } else {
      authController
          .sendOTP(
        context: context,
        email: _emailController.text.trim(),
      )
          .then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetOTPScreenPage(
              contact: '',
              loginType: LoginType.email,
              email: _emailController.text.trim(),
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          color: colorGreenLight,
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
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                child: SvgPicture.asset(
                  imageAssets + 'auth/fp_bottom.svg',
                  allowDrawingOutsideViewBox: true,
                  // fit: BoxFit.fill,
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
                child: Container(
                  height: getScrenHeight(context),
                  // color: colorGreen.withOpacity(0.3),

                  margin: EdgeInsets.only(top: 100.h + getStatusBarHeight(context)),
                  child: Column(
                    children: [
                      Container(
                        width: (getScreenWidth(context) - (marginHorizontal * 2)),
                        // height: centerContainerHeight,
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
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 20.w, top: 20.h),
                              alignment: AlignmentDirectional.topEnd,
                              child: SvgPicture.asset(
                                imageAssets + 'boy_reading.svg',
                                height: 200.h,
                              ),
                            ),
                            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 20.h, top: 180.h),
                                padding: EdgeInsets.only(left: 20.h, right: 20.h),
                                alignment: AlignmentDirectional.topStart,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: AlignmentDirectional.topStart,
                                        child: Text(
                                          "Forgot Password",
                                          style: sectionTitleTextStyle.merge(TextStyle(fontSize: 24.sp)),
                                        ),
                                      ),
                                      Container(
                                        alignment: AlignmentDirectional.topStart,
                                        child: Text(
                                          "Enter your registered email below to receive password reset instruction.",
                                          style: textTitle14BoldStyle
                                              .merge(TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: colorBodyText)),
                                        ),
                                      ),
                                      Container(
                                        height: 52.sp,
                                        margin: const EdgeInsets.only(top: 15),
                                        child: Row(
                                          children: [
                                            const CircularIcon(
                                              icon: Icons.email_outlined,
                                              bgGradient: skyBlueGradient,
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(left: 10),
                                                height: 52.sp,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Email", style: textFormTitleStyle),
                                                    Expanded(
                                                      child: TextFormField(
                                                        style: textFormTitleStyle.merge(
                                                          const TextStyle(color: colorWebPanelDarkText),
                                                        ),
                                                        decoration: InputDecoration(
                                                          floatingLabelBehavior: FloatingLabelBehavior.never,
                                                          fillColor: Colors.white,
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(6),
                                                            borderSide: const BorderSide(),
                                                          ),
                                                          contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                                        ),
                                                        keyboardType: TextInputType.emailAddress,
                                                        controller: _emailController,
                                                        // validator: (value) =>
                                                        //     emailValidator(value),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: AlignmentDirectional.topStart,
                                        child: Container(
                                          height: 22.sp,
                                          width: 110.sp,
                                          decoration: boxDecoration6,
                                          margin: EdgeInsets.only(left: 40.sp, top: 10.sp),
                                          child: GestureDetector(
                                            onTap: () => {Navigator.pop(context)},
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              // crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(left: 5, right: 5),
                                                  child: const Align(
                                                    alignment: AlignmentDirectional.center,
                                                    child: Icon(
                                                      Icons.arrow_back_outlined,
                                                      color: colorPink,
                                                      size: 12,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "Back To Login",
                                                  style: textFormSmallerTitleStyle.merge(const TextStyle(color: colorPink)),
                                                ),
                                              ],
                                            ),
                                          ),
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
                            ]),
                            // Positioned(
                            //   top: (getScreenWidth(context).h / 1.5) - 60,
                            //   width: getScreenWidth(context),
                            //   child:
                            // ),
                          ],
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
}
