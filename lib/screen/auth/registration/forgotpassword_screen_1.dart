import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/forgotpassword_screen_2.dart';
import 'package:saarthi_pedagogy_studentapp/theme/colors.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';

import 'help_screen.dart';

class ForgotpasswordScreen1 extends StatefulWidget {
  const ForgotpasswordScreen1({
    required this.email,
    this.fromDynamicLink = false,
    Key? key,
    required this.schoolId,
  }) : super(key: key);
  final String email;
  final bool fromDynamicLink;
  final String schoolId;

  @override
  State<ForgotpasswordScreen1> createState() => _ForgotpasswordScreen1State();
}

class _ForgotpasswordScreen1State extends State<ForgotpasswordScreen1> {
  final TextEditingController _emailController = TextEditingController(text: '');
  final authController = Get.put(AuthController());

  bool isFocusEmail = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email.toString();
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
                      '${imageAssets}auth/lock.png',
                      width: 30,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text('Enter your email address to reset your \n password',
                      textAlign: TextAlign.center,
                      style: textTitle16StylePoppins.merge(const TextStyle(color: colorGrey800, fontSize: 18, fontWeight: FontWeight.w400))),
                ],
              ),
              SizedBox(
                height: 50.h,
              ),
              Row(
                children: [
                  SizedBox(
                    height: 30.h,
                    width: 30.w,
                    child: SvgPicture.asset(
                      '${imageAssets}auth/email.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextFormField(
                      scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      controller: _emailController,
                      style: textTitle16StylePoppins.merge(const TextStyle(color: colorGrey700, fontWeight: FontWeight.w400, fontSize: 16)),
                      maxLines: 1,
                      onChanged: (text) {},
                      onFieldSubmitted: (value) {},
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 6.h, top: 2.h),
                          isDense: true,
                          filled: true,
                          fillColor: Colors.transparent,
                          labelText: "Email",
                          counterText: "",
                          hintText: "",
                          labelStyle: textTitle18StylePoppins.copyWith(
                            color: colorGrey600,
                            fontWeight: FontWeight.w500,
                            fontSize: isFocusEmail || _emailController.text.isNotEmpty ? 18.sp : 16.sp,
                            fontFamily: isFocusEmail || _emailController.text.isNotEmpty ? fontFamilyMedium : fontFamilyPoppins,
                          ),
                          errorStyle: textTitle16StylePoppins.merge(const TextStyle(color: colorGrey600, fontSize: 12, fontWeight: FontWeight.w500)),
                          hintStyle: textTitle16StylePoppins.merge(const TextStyle(color: colorGrey600, fontSize: 12, fontWeight: FontWeight.w500))),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Obx(() => authController.loadingForgotPassword.isTrue
                  ? const LoadingSpinner()
                  : GestureDetector(
                      onTap: () {
                        String emailval = emailValidator(_emailController.text);
                        if (emailval != "") {
                          Fluttertoast.showToast(msg: emailval);
                        } else {
                          submitForm(context);
                        }
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
                            Text("Sent OTP", style: textTitle16StylePoppins.merge(const TextStyle(color: Colors.white, fontWeight: FontWeight.w500))),
                      ),
                    ))
            ],
          ),
        )),
      ),
    );
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
        if (value) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ForgotpasswordScreen2(
                email: _emailController.text,
                fromDynamicLink: widget.fromDynamicLink,
                schoolId: widget.schoolId,
              ),
            ),
          );
        }
      });
    }
  }
}
