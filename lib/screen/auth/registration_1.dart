import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration_2.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/auth/circular_icon_btn.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/auth/email_input.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/auth/label_btn.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/auth/numeric_input.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/auth/text_input.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/auth/circular_icon.dart';
import '../../widgets/common/custom_network_image.dart';
import '../../widgets/common/loading_spinner.dart';
import 'login.dart';

class RegistrationPage1 extends StatefulWidget {
  const RegistrationPage1({Key? key, required this.schoolId}) : super(key: key);

  final String schoolId;

  @override
  State<RegistrationPage1> createState() => _RegistrationPage1State();
}

class _RegistrationPage1State extends State<RegistrationPage1> {
  double marginHorizontal = 20;
  double boyGirlToContainerDiff = 100;

  final authController = Get.put(AuthController());

  final TextEditingController _firstNameController =
      TextEditingController(text: '');
  final TextEditingController _lastNameController =
      TextEditingController(text: '');
  final TextEditingController _emailController =
      TextEditingController(text: '');
  final TextEditingController _rollNumberController =
      TextEditingController(text: '');
  final TextEditingController _contactController =
      TextEditingController(text: '');

  final _formKey = GlobalKey<FormState>();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _rollNumberFocusNode = FocusNode();
  final _contactFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      authController.getSchoolDetail(schoolId: widget.schoolId);
    });
  }

  _onLoginTap() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  submitForm(BuildContext context) {
    String emailval = emailValidator(_emailController.text);

    if (_firstNameController.text == "") {
      Fluttertoast.showToast(msg: "First name is required");
    } else if (_lastNameController.text == "") {
      Fluttertoast.showToast(msg: "Last name is required");
    } else if (_emailController.text.isEmpty &&
        _contactController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter email or contact number");
    } else if (_emailController.text.isNotEmpty && emailval != "") {
      Fluttertoast.showToast(msg: "Invalid email address");
    } else if (_contactController.text.isNotEmpty &&
        (!isNumeric(_contactController.text) ||
            _contactController.text.length != 10)) {
      Fluttertoast.showToast(msg: "Invalid contact number");
    } else {
      onPopUpShow();
    }
  }

  onPopUpShow() {
    var data = {
      "schoolId": authController.schoolData['_id'] ?? "",
      "schoolName": authController.schoolData['name'] ?? "",
      "schoolLogo": authController.schoolData['logoThumb'] ?? "",
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "rollNumber": _rollNumberController.text.trim(),
      "email": _emailController.text.trim(),
      "contact": _contactController.text.trim()
    };

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dc) {
        return ConfirmationDialogBox(
          emailController: _emailController,
          contactController: _contactController,
          data: data,
        );
      },
    );
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
              Positioned(
                top: getStatusBarHeight(context) + 10,
                right: getScreenWidth(context) / 20,
                child: Container(
                  width: 41.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.w)),
                  padding: EdgeInsets.all(5.w),
                  child: Obx(
                    () => authController.schoolLoading.isTrue
                        ? const LoadingSpinner()
                        : (authController.schoolData['logoThumb'] ?? "") != ""
                            ? CustomNetworkImage(
                                imageUrl:
                                    authController.schoolData['logoThumb'] ??
                                        "",
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
                child: SizedBox(
                  height: getScrenHeight(context),
                  child: Column(
                    children: [
                      Container(
                        width: getScreenWidth(context) - (marginHorizontal * 2),
                        margin: EdgeInsets.only(
                            top: 70.h + getStatusBarHeight(context)),
                        // height: centerContainerHeight,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30.h),
                            bottomRight: Radius.circular(30.h),
                            topRight: Radius.circular(30.h),
                            topLeft:
                                Radius.circular((getScrenHeight(context) / 4)),
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
                            Positioned(
                              top: 30.h,
                              right: 10.w,
                              child: Container(
                                width: getScreenWidth(context) - 150.w,
                                alignment: AlignmentDirectional.topEnd,
                                child: Obx(() => Text(
                                      authController.schoolLoading.isTrue
                                          ? "Loading..."
                                          : authController.schoolData['name'] ??
                                              "",
                                      textAlign: TextAlign.right,
                                      style: textError16WhiteBoldStyle.merge(
                                        const TextStyle(
                                          color: colorPink,
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 20.h, top: 100.h),
                              padding: EdgeInsets.only(left: 20.h, right: 20.h),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Text(
                                        "Registration",
                                        style: sectionTitleTextStyle
                                            .merge(TextStyle(fontSize: 24.sp)),
                                      ),
                                    ),
                                    CustomTextInput(
                                      title: "First Name*",
                                      icon: Icons.person_outline,
                                      controller: _firstNameController,
                                      iconGradient: skyBlueGradient,
                                      focusNode: _firstNameFocusNode,
                                      nextFocusNode: _lastNameFocusNode,
                                    ),
                                    CustomTextInput(
                                      title: "Last Name*",
                                      icon: Icons.person_outline,
                                      controller: _lastNameController,
                                      iconGradient: skyBlueGradient,
                                      focusNode: _lastNameFocusNode,
                                      nextFocusNode: _rollNumberFocusNode,
                                    ),
                                    NumericInput(
                                      title: "Roll No.",
                                      icon: Icons.contact_page_outlined,
                                      controller: _rollNumberController,
                                      iconGradient: skyBlueGradient,
                                      focusNode: _rollNumberFocusNode,
                                      nextFocusNode: _emailFocusNode,
                                    ),
                                    EmailInput(
                                      title: "Email",
                                      controller: _emailController,
                                      iconGradient: skyBlueGradient,
                                      focusNode: _emailFocusNode,
                                      nextFocusNode: _rollNumberFocusNode,
                                    ),
                                    Container(
                                      height: 40.h > 45 ? 50 : 55.h,
                                      margin: EdgeInsets.only(top: 10.h),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const CircularIcon(
                                            icon: Icons.phone,
                                            bgGradient: skyBlueGradient,
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                left: 10.w,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          6.w),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          6.w),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  width: 32.w,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            230,
                                                                            230,
                                                                            230,
                                                                            1),
                                                                    border:
                                                                        Border(
                                                                      right: BorderSide(
                                                                          width:
                                                                              1,
                                                                          color:
                                                                              colorFormFieldBorder),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    "+91",
                                                                    style: textTitle14BoldStyle.merge(
                                                                        const TextStyle(
                                                                            color:
                                                                                Colors.black)),
                                                                  ),
                                                                ),
                                                              ),
                                                              TextFormField(
                                                                style:
                                                                    textFormTitleStyle
                                                                        .merge(
                                                                  const TextStyle(
                                                                    color:
                                                                        colorWebPanelDarkText,
                                                                  ),
                                                                ),
                                                                maxLines: 1,
                                                                decoration:
                                                                    InputDecoration(
                                                                  counterText:
                                                                      "",
                                                                  floatingLabelBehavior:
                                                                      FloatingLabelBehavior
                                                                          .never,
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            6.sp),
                                                                    borderSide:
                                                                        const BorderSide(),
                                                                  ),
                                                                  contentPadding:
                                                                      EdgeInsets.only(
                                                                          left: 35
                                                                              .w,
                                                                          right: 5
                                                                              .w,
                                                                          top:
                                                                              0,
                                                                          bottom:
                                                                              0),
                                                                ),
                                                                maxLength: 10,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                inputFormatters: <
                                                                    TextInputFormatter>[
                                                                  FilteringTextInputFormatter
                                                                      .digitsOnly
                                                                ], // Only numbers can be entered
                                                                controller:
                                                                    _contactController,
                                                                focusNode:
                                                                    _contactFocusNode,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .done,
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
                                    ),
                                    SizedBox(height: 10.h),
                                    Container(
                                      margin: EdgeInsets.only(left: 50.w),
                                      child: Text(
                                        "Either Email or Mobile Number any 1 field is required.",
                                        style: textTitle12RegularStyle.merge(
                                            const TextStyle(
                                                color: colorBodyText)),
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Already have an account ?",
                                          style: textTitle12RegularStyle.merge(
                                              const TextStyle(
                                                  color: colorBodyText)),
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        LabelButton(
                                          onTap: _onLoginTap,
                                          title: 'Login',
                                          bgColor: colorPinkLight,
                                          textColor: colorPink,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
        ),
      ),
    );
  }
}

class ConfirmationDialogBox extends StatefulWidget {
  const ConfirmationDialogBox(
      {Key? key,
      required this.emailController,
      required this.contactController,
      required this.data})
      : super(key: key);

  final TextEditingController emailController;
  final TextEditingController contactController;
  final Map data;

  @override
  State<ConfirmationDialogBox> createState() => _ConfirmationDialogBoxState();
}

class _ConfirmationDialogBoxState extends State<ConfirmationDialogBox> {
  bool _isCheckedEmail = false;
  bool _isCheckedContact = false;

  _onSubmit() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationPage2(
          userInputData: widget.data,
        ),
      ),
    );
  }

  bool _checkSubmitBtnVisibility() {
    if (widget.emailController.text.trim().isNotEmpty &&
        widget.contactController.text.trim().isNotEmpty) {
      return _isCheckedContact && _isCheckedEmail;
    } else if (widget.emailController.text.trim().isNotEmpty) {
      return _isCheckedEmail;
    } else if (widget.contactController.text.trim().isNotEmpty) {
      return _isCheckedContact;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.w)),
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        width: getScreenWidth(context) - 16.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: colorScreenBg1Purple,
                  borderRadius: BorderRadius.circular(10.w)),
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 10.h,
              ),
              width: double.infinity,
              child: Text(
                'Verify Details',
                style: textTitle16WhiteBoldStyle.merge(
                  const TextStyle(
                    color: colorHeaderTextColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Text(
                    "Please verify that the details you entered are correct.",
                    style: textTitle12RegularStyle
                        .merge(const TextStyle(color: colorBodyText)),
                  ),
                  SizedBox(height: 10.h),
                  widget.emailController.text.isNotEmpty
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Theme(
                              data: ThemeData(unselectedWidgetColor: colorSky),
                              child: Checkbox(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                value: _isCheckedEmail,
                                activeColor: colorSky,
                                onChanged: (v) {
                                  _isCheckedEmail = !_isCheckedEmail;

                                  setState(() {});
                                },
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Email",
                                    style: textTitle12RegularStyle.merge(
                                        const TextStyle(color: colorBodyText)),
                                  ),
                                  Text(
                                    widget.emailController.text,
                                    style: textTitle20WhiteBoldStyle.merge(
                                      const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      : Container(),
                  SizedBox(height: 10.h),
                  widget.contactController.text.isNotEmpty
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Theme(
                              data: ThemeData(unselectedWidgetColor: colorSky),
                              child: Checkbox(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                value: _isCheckedContact,
                                activeColor: colorSky,
                                onChanged: (v) {
                                  _isCheckedContact = !_isCheckedContact;
                                  setState(() {});
                                },
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Mobile Number",
                                  style: textTitle12RegularStyle.merge(
                                      const TextStyle(color: colorBodyText)),
                                ),
                                Text(
                                  "+91" + widget.contactController.text,
                                  style: textTitle20WhiteBoldStyle.merge(
                                    const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      : Container(),
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: colorRedLight,
                              borderRadius: BorderRadius.circular(5.w),
                            ),
                            child: Text(
                              "Change Details",
                              style: textTitle16WhiteBoldStyle.merge(
                                  const TextStyle(
                                      color: colorRed,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        GestureDetector(
                          onTap: () {
                            if (_checkSubmitBtnVisibility()) {
                              _onSubmit();
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              gradient: redGradient,
                              borderRadius: BorderRadius.circular(5.w),
                            ),
                            child: Opacity(
                              opacity: _checkSubmitBtnVisibility() ? 1 : 0.5,
                              child: Text(
                                "Next",
                                style: textTitle16WhiteBoldStyle
                                    .merge(const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
