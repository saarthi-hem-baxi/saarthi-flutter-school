import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/theme/colors.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';

import 'help_screen.dart';

class ForgotpasswordScreen3 extends StatefulWidget {
  const ForgotpasswordScreen3({
    required this.email,
    required this.resetToken,
    this.fromDynamicLink = false,
    required this.schoolId,
    Key? key,
  }) : super(key: key);
  final String email;
  final String resetToken;
  final bool fromDynamicLink;
  final String schoolId;

  @override
  State<ForgotpasswordScreen3> createState() => _ForgotpasswordScreen3State();
}

class _ForgotpasswordScreen3State extends State<ForgotpasswordScreen3> with TickerProviderStateMixin {
  bool _passwordVisible = false;
  bool _passwordVisible2 = false;
  final TextEditingController _passwordController = TextEditingController(text: '');
  final TextEditingController _confirmpasswordController = TextEditingController(text: '');
  final authController = Get.put(AuthController());

  bool isFocusNewPassword = false;
  bool isFocusConfirmPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
                  Text('Enter New Password',
                      textAlign: TextAlign.center,
                      style: textTitle16StylePoppins.merge(const TextStyle(color: colorGrey800, fontSize: 18, fontWeight: FontWeight.w400))),
                ],
              ),
              SizedBox(
                height: 50.h,
              ),
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
                  Expanded(
                    child: Focus(
                      onFocusChange: (v) {
                        isFocusNewPassword = !isFocusNewPassword;
                      },
                      child: TextFormField(
                        obscureText: !_passwordVisible,
                        scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        controller: _passwordController,
                        style: textTitle16StylePoppins.merge(TextStyle(color: colorGrey700, fontWeight: FontWeight.w400, fontSize: 16.sp)),
                        maxLines: 1,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 4.h, top: 2.h),
                            isDense: true,
                            filled: true,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12.0),
                                child: SvgPicture.asset(
                                  _passwordVisible ? '${imageAssets}auth/password_visible.svg' : '${imageAssets}auth/password_hide.svg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            fillColor: Colors.transparent,
                            labelText: "New Password",
                            counterText: "",
                            hintText: "",
                            labelStyle: textTitle16StylePoppins.copyWith(
                              color: colorGrey600,
                              fontWeight: FontWeight.w500,
                              fontSize: isFocusNewPassword || _passwordController.text.isNotEmpty ? 18.sp : 16.sp,
                              fontFamily: isFocusNewPassword || _passwordController.text.isNotEmpty ? fontFamilyMedium : fontFamilyPoppins,
                            ),
                            errorStyle:
                                textTitle16StylePoppins.merge(const TextStyle(color: colorGrey600, fontSize: 12, fontWeight: FontWeight.w500)),
                            hintStyle:
                                textTitle16StylePoppins.merge(const TextStyle(color: colorGrey600, fontSize: 12, fontWeight: FontWeight.w500))),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  )
                ],
              ),
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
                  Expanded(
                    child: Focus(
                      onFocusChange: (v) {
                        isFocusConfirmPassword = !isFocusConfirmPassword;
                      },
                      child: TextFormField(
                        obscureText: !_passwordVisible2,
                        scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        controller: _confirmpasswordController,
                        style: textTitle16StylePoppins.merge(TextStyle(color: colorGrey700, fontWeight: FontWeight.w400, fontSize: 16.sp)),
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 4.h, top: 2.h),
                          isDense: true,
                          filled: true,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _passwordVisible2 = !_passwordVisible2;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              child: SvgPicture.asset(
                                _passwordVisible2 ? '${imageAssets}auth/password_visible.svg' : '${imageAssets}auth/password_hide.svg',
                                fit: BoxFit.contain,
                                width: 10,
                                height: 10,
                              ),
                            ),
                          ),
                          fillColor: Colors.transparent,
                          labelText: "Confirm New Password",
                          counterText: "",
                          hintText: "",
                          labelStyle: textTitle16StylePoppins.copyWith(
                            color: colorGrey600,
                            fontWeight: FontWeight.w500,
                            fontSize: isFocusConfirmPassword || _confirmpasswordController.text.isNotEmpty ? 18.sp : 16.sp,
                            fontFamily: isFocusConfirmPassword || _confirmpasswordController.text.isNotEmpty ? fontFamilyMedium : fontFamilyPoppins,
                          ),
                          errorStyle: textTitle16StylePoppins.merge(const TextStyle(color: colorGrey600, fontSize: 12, fontWeight: FontWeight.w500)),
                          hintStyle: textTitle16StylePoppins.copyWith(
                            color: colorGrey600,
                            fontWeight: FontWeight.w500,
                            fontSize: isFocusConfirmPassword || _confirmpasswordController.text.isNotEmpty ? 18.sp : 16.sp,
                            fontFamily: isFocusConfirmPassword || _confirmpasswordController.text.isNotEmpty ? fontFamilyMedium : fontFamilyPoppins,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10.h),
              Obx(() => authController.loadingForgotPassword.isTrue
                  ? const Center(
                      child: LoadingSpinner(),
                    )
                  : GestureDetector(
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
                        child:
                            Text("Submit", style: textTitle16StylePoppins.merge(const TextStyle(color: Colors.white, fontWeight: FontWeight.w500))),
                      ),
                    ))
            ],
          ),
        )),
      ),
    );
  }

  submitForm(BuildContext context) {
    if (checkPasswordvalidation(password: _passwordController.text.trim(), confirmPassword: _confirmpasswordController.text.trim())) {
      authController.resetPassword(
          context: context,
          email: widget.email,
          password: _passwordController.text.trim(),
          resetToken: widget.resetToken,
          isFromDynamicLink: widget.fromDynamicLink);
    }
  }
}
