import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/globals.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/forgot_password.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/reset_otp_screen.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/auth/circular_icon.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/auth/circular_icon_btn.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/auth/label_btn.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/auth/users.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../home/bottom_footer_navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double marginHorizontal = 20;
  double boyGirlToContainerDiff = 100;

  final authController = Get.put(AuthController());

  final TextEditingController _emailController = TextEditingController(text: '');
  final TextEditingController _passwordController = TextEditingController(text: '');
  final TextEditingController _contactController = TextEditingController(text: '');

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  LoginType _loginType = LoginType.phone;

  submitForm(BuildContext context) {
    String emailval = emailValidator(_emailController.text);
    String passwordVal = emptyValidator(_passwordController.text, "Password Required");

    if (_loginType == LoginType.email) {
      if (emailval != "") {
        Fluttertoast.showToast(msg: emailval);
      } else if (passwordVal != "") {
        Fluttertoast.showToast(msg: passwordVal);
      } else {
        authController
            .loginWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        )
            .then((v) {
          if (v) {
            showMultiAuthSheet(authController: authController, context: context);
          }
        });
      }
    } else {
      if (_contactController.text.trim() == "") {
        Fluttertoast.showToast(msg: "Please enter mobile number");
        return;
      } else if (_contactController.text.trim().length != 10) {
        Fluttertoast.showToast(msg: "Invalid mobile number");
      } else {
        authController
            .loginWithContact(
          contact: _contactController.text.trim(),
        )
            .then((v) {
          if (v) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResetOTPScreenPage(
                  contact: _contactController.text.trim(),
                  email: '',
                  loginType: LoginType.phone,
                ),
              ),
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          color: colorPinkLight,
          height: getScrenHeight(context),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: (getScrenHeight(context) / 1.8),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  gradient: purpleGradient,
                ),
                child: OverflowBox(
                  alignment: Alignment.topCenter,
                  maxWidth: getScreenWidth(context) * 2,
                  maxHeight: getScrenHeight(context),
                  child: SvgPicture.asset(
                    imageAssets + 'gradienteffect.svg',
                    // allowDrawingOutsideViewBox: true,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: -10.h,
                left: 30.w,
                right: 30.w,
                child: SvgPicture.asset(
                  imageAssets + 'auth/login_bottom.svg',
                  allowDrawingOutsideViewBox: true,
                  fit: BoxFit.fitHeight,
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
                ),
              ),
              Center(
                child: SizedBox(
                    height: getScrenHeight(context),
                    child: Column(
                      children: [
                        Container(
                          width: getScreenWidth(context) - (marginHorizontal * 2),
                          margin: EdgeInsets.only(top: 100.h + getStatusBarHeight(context)),
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
                                color: Color.fromRGBO(213, 25, 25, 0.10),
                                offset: Offset(
                                  0,
                                  2,
                                ),
                                blurRadius: 6.0,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Container(
                                alignment: AlignmentDirectional.topEnd,
                                margin: EdgeInsets.only(
                                  right: 20.w,
                                  top: 20.h,
                                ),
                                child: SvgPicture.asset(
                                  imageAssets + 'boygirlgradient.svg',
                                  height: 200.h,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 20.h, top: 160.h),
                                padding: EdgeInsets.only(left: 20.h, right: 20.h),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: AlignmentDirectional.topStart,
                                        child: Text(
                                          "Login",
                                          style: sectionTitleTextStyle.merge(TextStyle(fontSize: 24.sp)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      SizedBox(
                                        height: 20,
                                        child: Row(
                                          children: [
                                            Row(
                                              children: [
                                                Theme(
                                                  data: ThemeData(unselectedWidgetColor: colorPink),
                                                  child: Radio(
                                                    value: LoginType.phone,
                                                    groupValue: _loginType,
                                                    onChanged: (value) {
                                                      FocusScope.of(context).unfocus();
                                                      _loginType = value as LoginType;
                                                      setState(() {});
                                                    },
                                                    activeColor: colorPink,
                                                  ),
                                                ),
                                                Text(
                                                  "With Mobile Number",
                                                  style: textTitle14BoldStyle.merge(const TextStyle(color: colorPink, fontWeight: FontWeight.w600)),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Theme(
                                                  data: ThemeData(unselectedWidgetColor: colorPink),
                                                  child: Radio(
                                                    value: LoginType.email,
                                                    groupValue: _loginType,
                                                    onChanged: (value) {
                                                      FocusScope.of(context).unfocus();
                                                      _loginType = value as LoginType;
                                                      setState(() {});
                                                    },
                                                    activeColor: colorPink,
                                                  ),
                                                ),
                                                Text(
                                                  "With Email",
                                                  style: textTitle14BoldStyle.merge(const TextStyle(color: colorPink, fontWeight: FontWeight.w600)),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      _loginType == LoginType.phone
                                          ? Container(
                                              height: 40.h > 45 ? 50 : 55.h,
                                              margin: EdgeInsets.only(top: 10.h),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  const CircularIcon(
                                                    icon: Icons.phone_android,
                                                    bgGradient: skyBlueGradient,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                        left: 10.w,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Mobile Number",
                                                            style: textFormTitleStyle,
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Stack(
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(6.w),
                                                                          bottomLeft: Radius.circular(6.w),
                                                                        ),
                                                                        child: Container(
                                                                          width: 32.w,
                                                                          alignment: Alignment.center,
                                                                          decoration: const BoxDecoration(
                                                                            color: Color.fromRGBO(230, 230, 230, 1),
                                                                            border: Border(
                                                                              right: BorderSide(width: 1, color: colorFormFieldBorder),
                                                                            ),
                                                                          ),
                                                                          child: Text(
                                                                            "+91",
                                                                            style: textTitle14BoldStyle.merge(const TextStyle(color: Colors.black)),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      TextFormField(
                                                                        style: textFormTitleStyle.merge(
                                                                          const TextStyle(
                                                                            color: colorWebPanelDarkText,
                                                                          ),
                                                                        ),
                                                                        maxLines: 1,
                                                                        decoration: InputDecoration(
                                                                          counterText: "",
                                                                          floatingLabelBehavior: FloatingLabelBehavior.never,
                                                                          fillColor: Colors.white,
                                                                          border: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(6.sp),
                                                                            borderSide: const BorderSide(),
                                                                          ),
                                                                          contentPadding: EdgeInsets.only(left: 35.w, right: 5.w, top: 0, bottom: 0),
                                                                        ),
                                                                        maxLength: 10,
                                                                        keyboardType: TextInputType.number,
                                                                        inputFormatters: <TextInputFormatter>[
                                                                          FilteringTextInputFormatter.digitsOnly,
                                                                          LengthLimitingTextInputFormatter(10),
                                                                        ],
                                                                        //
                                                                        controller: _contactController,
                                                                        textInputAction: TextInputAction.done,
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
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      _loginType == LoginType.email
                                          ? Container(
                                              height: 52.sp,
                                              margin: EdgeInsets.only(top: 15.sp),
                                              child: Row(
                                                children: [
                                                  const CircularIcon(
                                                    icon: Icons.email_outlined,
                                                    bgGradient: skyBlueGradient,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(left: 10.sp),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Email", style: textFormTitleStyle),
                                                          Expanded(
                                                            child: TextFormField(
                                                              style: textFormTitleStyle.merge(
                                                                const TextStyle(color: colorWebPanelDarkText),
                                                              ),
                                                              maxLines: 1,
                                                              decoration: InputDecoration(
                                                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                                                fillColor: Colors.white,
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(6.sp),
                                                                  borderSide: const BorderSide(),
                                                                ),
                                                                contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                                              ),
                                                              onFieldSubmitted: (v) {
                                                                FocusScope.of(context).requestFocus(
                                                                  _passwordFocusNode,
                                                                );
                                                              },
                                                              focusNode: _emailFocusNode,
                                                              controller: _emailController,
                                                              keyboardType: TextInputType.emailAddress,
                                                              textInputAction: TextInputAction.next,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      _loginType == LoginType.email
                                          ? Container(
                                              height: 52.sp,
                                              margin: const EdgeInsets.only(top: 5),
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
                                                              controller: _passwordController,
                                                              focusNode: _passwordFocusNode,
                                                              keyboardType: TextInputType.text,
                                                              textInputAction: TextInputAction.done,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      _loginType == LoginType.email
                                          ? Container(
                                              alignment: AlignmentDirectional.topStart,
                                              margin: EdgeInsets.only(left: 40.sp, top: 10.sp),
                                              child: LabelButton(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => const ForgotPasswordPage(),
                                                    ),
                                                  );
                                                },
                                                title: 'Forgot Password ?',
                                                bgColor: colorPinkLight,
                                                textColor: colorPink,
                                              ),
                                            )
                                          : Container(),
                                      _loginType == LoginType.phone
                                          ? SizedBox(
                                              height: 10.h,
                                            )
                                          : Container(),
                                      Container(
                                        alignment: AlignmentDirectional.topEnd,
                                        child: Obx(
                                          () {
                                            return authController.loading.isTrue
                                                ? const LoadingSpinner()
                                                : CircularIconButton(
                                                    bgGradient: redGradient,
                                                    buttonSize: 36.h,
                                                    icon: Icons.arrow_forward,
                                                    iconSize: 18.h,
                                                    onTap: () {
                                                      submitForm(context);
                                                    },
                                                  );
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
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SchoolListTile extends StatelessWidget {
  const SchoolListTile({Key? key, required this.currentUserId, required this.user, required this.onTap, this.onProfileTap}) : super(key: key);

  final User user;
  final String currentUserId;
  final VoidCallback onTap;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: currentUserId == user.id ? colorPink : Colors.white, width: currentUserId == user.id ? 1 : 0),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: const [
            BoxShadow(
              color: colorDropShadow,
              offset: Offset(0.0, 2.0),
              blurRadius: 5,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(0.0, 0.0),
              blurRadius: 0.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
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
                    style: textTitle14BoldStyle.merge(TextStyle(color: colorPink, fontSize: 20.sp)),
                  ),
                  Text(
                    user.school?.name ?? "",
                    style: textTitle14BoldStyle.merge(const TextStyle(color: Colors.black, fontWeight: FontWeight.normal)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Class ${user.userClass?.name} ${user.section?.name}',
                        style: textTitle14BoldStyle.merge(const TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
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
                          : Container()
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
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
      // });
    });
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(14.w), topRight: Radius.circular(14.w)),
          ),
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
                      Text(
                        "Select User Profile",
                        style: textTitle14BoldStyle.merge(const TextStyle(color: Colors.black)),
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
