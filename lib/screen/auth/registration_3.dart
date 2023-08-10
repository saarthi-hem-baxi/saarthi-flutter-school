import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration_4.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/auth/circular_icon_btn.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/auth/circular_icon.dart';
import '../../widgets/common/custom_network_image.dart';

class RegistrationPage3 extends StatefulWidget {
  const RegistrationPage3({Key? key, required this.userInputData}) : super(key: key);
  final Map userInputData;

  @override
  State<RegistrationPage3> createState() => _RegistrationPage3State();
}

class _RegistrationPage3State extends State<RegistrationPage3> {
  double marginHorizontal = 20;

  final _formKey = GlobalKey<FormState>();

  final authController = Get.put(AuthController());
  final TextEditingController _passwordController = TextEditingController(text: '');
  final TextEditingController _confirmPasswordController = TextEditingController(text: '');

  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  submitForm(BuildContext context) {
    String _password = _passwordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();

    if (checkPasswordvalidation(password: _password, confirmPassword: _confirmPassword)) {
      var _dataMap = {
        ...widget.userInputData,
        "password": _passwordController.text,
      };

      authController.studentRegistration(data: _dataMap).then((value) {
        if (value) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegistrationPage4(
                userInputData: _dataMap,
              ),
            ),
          );
        }
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
              Positioned(
                top: getStatusBarHeight(context) + 10,
                right: getScreenWidth(context) / 20,
                child: Container(
                  width: 41.w,
                  height: 41.w,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6.w)),
                  padding: EdgeInsets.all(5.w),
                  child: Obx(
                    () => authController.schoolLoading.isTrue
                        ? const LoadingSpinner()
                        : (authController.schoolData['logoThumb'] ?? "") != ""
                            ? CustomNetworkImage(
                                imageUrl: authController.schoolData['logoThumb'] ?? "",
                                fit: BoxFit.contain,
                              )
                            : SvgPicture.asset(
                                imageAssets + 'schoollogo.svg',
                                // allowDrawingOutsideViewBox: true,
                                fit: BoxFit.cover,
                              ),
                  ),
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
                            Positioned(
                              top: 10.h,
                              right: 20.w,
                              child: Container(
                                width: getScreenWidth(context) - 150.w,
                                alignment: AlignmentDirectional.topEnd,
                                child: Obx(() => Text(
                                      authController.schoolLoading.isTrue ? "Loading..." : authController.schoolData['name'] ?? "",
                                      textAlign: TextAlign.right,
                                      style: textError16WhiteBoldStyle.merge(
                                        const TextStyle(
                                          color: colorPink,
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                            Positioned(
                              right: 0.w,
                              top: 20.h,
                              child: Container(
                                margin: EdgeInsets.only(right: 20.w, top: 20.h),
                                alignment: AlignmentDirectional.topEnd,
                                child: SvgPicture.asset(
                                  imageAssets + 'auth/create_password.svg',
                                  fit: BoxFit.cover,
                                  height: 150.h,
                                ),
                              ),
                            ),
                            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 20.h, top: 200.h),
                                padding: EdgeInsets.only(left: 20.h, right: 20.h),
                                alignment: AlignmentDirectional.topStart,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: AlignmentDirectional.topStart,
                                        child: Text(
                                          "Password",
                                          style: sectionTitleTextStyle.merge(TextStyle(fontSize: 24.sp)),
                                        ),
                                      ),
                                      Container(
                                        height: 52.sp,
                                        margin: const EdgeInsets.only(top: 5),
                                        child: Row(
                                          children: [
                                            const CircularIcon(
                                              icon: Icons.lock_outline,
                                              bgGradient: blueGradient,
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
                                                          isDense: true,
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(6),
                                                            borderSide: const BorderSide(),
                                                          ),
                                                          contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                                                            iconSize: 16.sp,
                                                          ),
                                                          suffixStyle: const TextStyle(backgroundColor: Colors.green),
                                                          suffixIconColor: colorBlue,
                                                        ),
                                                        onFieldSubmitted: (v) {
                                                          FocusScope.of(context).requestFocus(
                                                            _confirmPasswordFocusNode,
                                                          );
                                                        },
                                                        textInputAction: TextInputAction.next,
                                                        keyboardType: TextInputType.text,
                                                        controller: _passwordController,
                                                        focusNode: _passwordFocusNode,
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
                                        margin: const EdgeInsets.only(top: 5),
                                        child: Row(
                                          children: [
                                            const CircularIcon(
                                              icon: Icons.lock_outline,
                                              bgGradient: blueGradient,
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
                                                        obscureText: !_confirmPasswordVisible,
                                                        obscuringCharacter: '*',
                                                        decoration: InputDecoration(
                                                          isDense: true,
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(6),
                                                            borderSide: const BorderSide(),
                                                          ),
                                                          contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                          suffixIcon: IconButton(
                                                            icon: Icon(
                                                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                                            ),
                                                            onPressed: () => {
                                                              setState(() {
                                                                _confirmPasswordVisible = !_confirmPasswordVisible;
                                                              })
                                                            },
                                                            color: colorBlue,
                                                            iconSize: 16.sp,
                                                          ),
                                                          suffixStyle: const TextStyle(backgroundColor: Colors.green),
                                                          suffixIconColor: colorBlue,
                                                        ),
                                                        onFieldSubmitted: (v) {
                                                          FocusScope.of(context).unfocus();
                                                        },
                                                        keyboardType: TextInputType.text,
                                                        controller: _confirmPasswordController,
                                                        focusNode: _confirmPasswordFocusNode,
                                                        textInputAction: TextInputAction.done,
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
                                        height: 10.h,
                                      ),
                                      Container(
                                        decoration: boxDecoration6,
                                        margin: EdgeInsets.only(left: 50.w),
                                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                        child: GestureDetector(
                                          onTap: () => {Navigator.pop(context)},
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
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
                                                "Back To Class/Section",
                                                style: textFormSmallerTitleStyle.merge(const TextStyle(color: colorPink)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () => Container(
                                          alignment: AlignmentDirectional.topEnd,
                                          child: authController.registerLoading.isTrue
                                              ? const LoadingSpinner()
                                              : CircularIconButton(
                                                  bgGradient: redGradient,
                                                  buttonSize: 36.h,
                                                  icon: Icons.arrow_forward,
                                                  iconSize: 18.h,
                                                  onTap: () {
                                                    submitForm(context);
                                                  },
                                                ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]),
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
