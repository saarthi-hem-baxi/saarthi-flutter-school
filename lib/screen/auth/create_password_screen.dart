import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/auth/circular_icon.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/auth/circular_icon_btn.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';

class CreatePasswordScreenPage extends StatefulWidget {
  final String email;
  final String resetToken;

  const CreatePasswordScreenPage({
    Key? key,
    required this.email,
    required this.resetToken,
  }) : super(key: key);

  @override
  State<CreatePasswordScreenPage> createState() => _CreatePasswordScreenPageState();
}

class _CreatePasswordScreenPageState extends State<CreatePasswordScreenPage> {
  double marginHorizontal = 20;

  // double centerContainerHeight = 400;
  double boyGirlToContainerDiff = 100;

  bool _passwordVisible = false;
  bool _passwordConfirmVisible = false;

  final TextEditingController _confirmPasswordController = TextEditingController(text: '');
  final TextEditingController _passwordController = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();
  final authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
  }

  submitForm(BuildContext context) {
    if (checkPasswordvalidation(password: _passwordController.text.trim(), confirmPassword: _confirmPasswordController.text.trim())) {
      authController.resetPassword(
          context: context, email: widget.email, password: _passwordController.text.trim(), resetToken: widget.resetToken, isFromDynamicLink: false);
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
                height: (getScrenHeight(context).h / 1.8),
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
                  imageAssets + 'auth/cp_bottom.svg',
                  allowDrawingOutsideViewBox: true,
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: getScrenHeight(context),
                    child: Column(
                      children: [
                        Container(
                          width: getScreenWidth(context) - (marginHorizontal * 2),
                          // height: centerContainerHeight + 20,
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
                                  margin: const EdgeInsets.only(right: 30, top: 20),
                                  child: SvgPicture.asset(
                                    imageAssets + 'boy_report_bag_basketball.svg',
                                    fit: BoxFit.contain,
                                    height: 200.h,
                                    width: getScreenWidth(context).h / 1.5,
                                  ),
                                ),
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
                                            "Create New Password",
                                            style: sectionTitleTextStyle.merge(TextStyle(fontSize: 24.sp)),
                                          ),
                                        ),
                                        Container(
                                          height: 52.sp,
                                          margin: const EdgeInsets.only(top: 20),
                                          child: Row(
                                            children: [
                                              const CircularIcon(
                                                icon: Icons.lock_outline,
                                                bgGradient: skyBlueGradient,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(left: 10.sp),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Password", style: textFormTitleStyle),
                                                      Expanded(
                                                        child: TextFormField(
                                                          style: textFormTitleStyle.merge(
                                                            const TextStyle(color: colorWebPanelDarkText),
                                                          ),
                                                          maxLines: 1,
                                                          obscureText: !_passwordVisible,
                                                          obscuringCharacter: '*',
                                                          decoration: InputDecoration(
                                                              labelText: "",
                                                              fillColor: Colors.white,
                                                              contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(6),
                                                                borderSide: const BorderSide(),
                                                              ),
                                                              suffixIcon: IconButton(
                                                                icon: Icon(
                                                                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                                                ),
                                                                onPressed: () => {
                                                                  setState(() {
                                                                    _passwordVisible = !_passwordVisible;
                                                                  })
                                                                },
                                                                color: colorBlue,
                                                                iconSize: 16,
                                                              ),
                                                              suffixIconColor: colorBlue),
                                                          controller: _passwordController,
                                                          // validator: (value) =>
                                                          //     emptyValidator(value,
                                                          //         "Password is required"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        Container(
                                          margin: EdgeInsets.only(left: 50.w),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "\u2022 At least 8 characters.",
                                                style: textTitle12RegularStyle.merge(const TextStyle(color: colorBodyText)),
                                              ),
                                              Text(
                                                "\u2022 Combination of both uppercase and lowercase letters.",
                                                style: textTitle12RegularStyle.merge(const TextStyle(color: colorBodyText)),
                                              ),
                                              Text(
                                                "\u2022 Combination of letters and numbers.",
                                                style: textTitle12RegularStyle.merge(const TextStyle(color: colorBodyText)),
                                              ),
                                              Text(
                                                "\u2022 At least one special character (! @ #  % ^ & * , \$).",
                                                style: textTitle12RegularStyle.merge(const TextStyle(color: colorBodyText)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        Container(
                                          height: 52.sp,
                                          margin: const EdgeInsets.only(top: 10),
                                          child: Row(
                                            children: [
                                              const CircularIcon(
                                                icon: Icons.lock_outline,
                                                bgGradient: skyBlueGradient,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(left: 10.sp),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Confirm Password", style: textFormTitleStyle),
                                                      Expanded(
                                                        child: TextFormField(
                                                          style: textFormTitleStyle.merge(
                                                            const TextStyle(color: colorWebPanelDarkText),
                                                          ),
                                                          maxLines: 1,
                                                          obscureText: !_passwordConfirmVisible,
                                                          obscuringCharacter: '*',
                                                          decoration: InputDecoration(
                                                              labelText: "",
                                                              fillColor: Colors.white,
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(6),
                                                                borderSide: const BorderSide(),
                                                              ),
                                                              contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                              suffixIcon: IconButton(
                                                                icon: Icon(
                                                                  _passwordConfirmVisible ? Icons.visibility : Icons.visibility_off,
                                                                ),
                                                                onPressed: () => {
                                                                  setState(() {
                                                                    _passwordConfirmVisible = !_passwordConfirmVisible;
                                                                  })
                                                                },
                                                                color: colorBlue,
                                                                iconSize: 16,
                                                              ),
                                                              suffixIconColor: colorBlue),
                                                          controller: _confirmPasswordController,
                                                          // validator: (value) =>
                                                          //     emptyValidator(value,
                                                          //         "Confirm Password Required"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 50.w),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "\u2022 Password and Confirm Password must be same.",
                                                style: textTitle12RegularStyle.merge(const TextStyle(color: colorBodyText)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Container(
                                          alignment: AlignmentDirectional.topEnd,
                                          margin: const EdgeInsets.only(top: 20),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
