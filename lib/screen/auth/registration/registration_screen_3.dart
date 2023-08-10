// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/globals.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/model/auth/users.dart';
import 'package:saarthi_pedagogy_studentapp/screen/home/bottom_footer_navigation.dart';
import 'package:saarthi_pedagogy_studentapp/theme/colors.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/auth/custom_registration_appbar.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/utils.dart';
import '../../../model/auth/teaching.dart';
import '../../../widgets/common/no_data_found_text.dart';

String _selectedClassId = '';
String _selectedSectionId = '';

class RegistrationScreen3 extends StatefulWidget {
  RegistrationScreen3({
    Key? key,
    required this.userInputData,
    required this.schoolId,
    required this.fromAddSchool,
    required this.fromRegitrationLink,
    this.isBackButton = true,
    this.isFromLoginAddSchool,
  }) : super(key: key);

  Map userInputData;
  String schoolId;
  bool fromAddSchool;
  bool fromRegitrationLink;
  bool isBackButton;
  bool? isFromLoginAddSchool;

  @override
  State<RegistrationScreen3> createState() => _RegistrationScreen3State();
}

class _RegistrationScreen3State extends State<RegistrationScreen3> {
  final authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _selectedClassId = '';
    _selectedSectionId = '';
    authController.isClassSelected.value = false;
    authController.getTeachingDataClassSection(schoolId: widget.schoolId);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => widget.isBackButton,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: SafeArea(
              child: Container(
            margin: EdgeInsets.symmetric(
              vertical: 8.h,
            ),
            child: Obx(
              () => Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: CustomRegistrationAppBar(
                        isfromRegistrationLink: widget.fromRegitrationLink, progress: 1.0, isBackButton: widget.isBackButton),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  '${imageAssets}auth/board.png',
                                  height: 30.h,
                                  width: 30.w,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text("Select your class/section",
                                    style: textTitle16StylePoppins
                                        .merge(const TextStyle(color: colorGrey800, fontSize: 18, fontWeight: FontWeight.w400))),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                          ],
                        ),
                        Expanded(
                            child: authController.teachingLoading.isTrue
                                ? const Center(
                                    child: LoadingSpinner(),
                                  )
                                : const SingleChildScrollView(child: ListWidget()))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (authController.isClassSelected.isTrue) {
                          openBottomSheet();
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      height: 40.h,
                      width: getScreenWidth(context),
                      alignment: AlignmentDirectional.center,
                      decoration: BoxDecoration(
                          gradient: authController.isClassSelected.isTrue ? blueDarkGradient1 : grayGradient,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: [
                            authController.isClassSelected.isTrue
                                ? const BoxShadow(
                                    color: Color.fromRGBO(11, 55, 132, 0.2),
                                    blurRadius: 10.0,
                                  )
                                : const BoxShadow(),
                          ]),
                      child: Text("Next", style: textTitle16StylePoppins.merge(const TextStyle(color: Colors.white, fontWeight: FontWeight.w500))),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ));
  }

  openBottomSheet() {
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.w), topRight: Radius.circular(20.w)),
      ),
      context: context,
      builder: (_) => MyBottomSheetConfirmation(
        userInputData: widget.userInputData,
        schoolId: widget.schoolId,
        fromAddSchool: widget.fromAddSchool,
        isFromLoginAddSchool: widget.isFromLoginAddSchool,
      ),
    );
  }
}

class ListWidget extends StatefulWidget {
  const ListWidget({Key? key}) : super(key: key);

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  final authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
  }

  //here we check next class's section is present or not
  bool isNeedToShowBottomBorder({required TeachingModal currentClass, required int index}) {
    if (authController.teachingClassSectionData.last == currentClass) {
      return false;
    } else {
      return (authController.teachingClassSectionData[index + 1].sections ?? []).isNotEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => authController.teachingClassSectionData.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...authController.teachingClassSectionData.mapIndexed(
                  (index, item) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                        child: Wrap(
                          spacing: 10.w,
                          runSpacing: 14.h,
                          direction: Axis.horizontal,
                          children: (item.sections ?? []).mapIndexed((index, sectionItem) {
                            return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    for (TeachingModal teachingModelItem in authController.teachingClassSectionData) {
                                      for (Sections sectionItem in (teachingModelItem.sections ?? [])) {
                                        sectionItem.isChecked = false;
                                      }
                                    }
                                    if (sectionItem.isChecked ?? false) {
                                      sectionItem.isChecked = false;
                                    } else {
                                      setState(
                                        () {
                                          authController.isClassSelected.value = true;
                                          _selectedClassId = item.id ?? '';
                                          _selectedSectionId = sectionItem.id ?? '';
                                          sectionItem.isChecked = true;
                                        },
                                      );
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: (sectionItem.isChecked ?? false) ? colorGreen50 : colorGrey50,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: (sectionItem.isChecked ?? false) ? colorGDTealLight : colorGrey200,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                                  child: Text(
                                    '${item.name}-${sectionItem.name}',
                                    style: (sectionItem.isChecked ?? false)
                                        ? textTitle16StylePoppins
                                            .merge(const TextStyle(fontWeight: FontWeight.w400, color: colorDarkGreen, fontSize: 14))
                                        : textTitle16StylePoppins
                                            .merge(const TextStyle(fontWeight: FontWeight.w400, color: colorgreyDark, fontSize: 14)),
                                  ),
                                ));
                          }).toList(),
                        ),
                      ),
                      isNeedToShowBottomBorder(currentClass: item, index: index)
                          ? Container(
                              width: double.infinity,
                              height: 3,
                              decoration: const BoxDecoration(
                                color: Color(0xffF5F5F5),
                                border: Border(
                                  top: BorderSide(
                                    width: 1,
                                    color: Color(0xffE1E1E1),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                )
              ],
            )
          : const NoDataFoundText(title: "No teaching data found!"),
    );
  }
}

class MyBottomSheetConfirmation extends StatefulWidget {
  MyBottomSheetConfirmation({
    Key? key,
    required this.userInputData,
    required this.schoolId,
    required this.fromAddSchool,
    this.isFromLoginAddSchool,
  }) : super(key: key);
  Map userInputData;
  String schoolId;
  bool fromAddSchool;
  bool? isFromLoginAddSchool;

  @override
  _MyBottomSheetConfirmationState createState() => _MyBottomSheetConfirmationState();
}

class _MyBottomSheetConfirmationState extends State<MyBottomSheetConfirmation> {
  bool isSelectMale = false;
  bool isSelectFemale = false;
  final TextEditingController _fullNameController = TextEditingController(text: '');
  final authController = Get.put(AuthController());

  bool isFocusOnFullName = false;

  void onAddSchool() {
    if (_fullNameController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please Enter Full Name");
      return;
    } else if (isSelectMale == false && isSelectFemale == false) {
      Fluttertoast.showToast(msg: "Please Select Gender");
    } else {
      Map dataMap = {
        "name": _fullNameController.text.trim().toString(),
        "gender": isSelectMale
            ? 'male'
            : isSelectFemale
                ? 'female'
                : '',
        "class": _selectedClassId,
        "section": _selectedSectionId
      };

      authController.studentAddSchool(data: dataMap, schoolId: widget.schoolId, isFromLoginAddSchool: widget.isFromLoginAddSchool).then((value) {
        if (value) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const BottomFooterNavigation(
                      selectedIndex: 3,
                    )),
            (route) => false,
          );
        }
      });
    }
  }

  void onSubmit() {
    if (_fullNameController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please Enter Full Name");
      return;
    } else if (isSelectMale == false && isSelectFemale == false) {
      Fluttertoast.showToast(msg: "Please Select Gender");
    } else {
      Map dataMap;
      if (authController.loginType == LoginType.phone) {
        dataMap = {
          "name": _fullNameController.text.trim().toString(),
          "contact": widget.userInputData['contact'],
          "loginOTP": widget.userInputData['loginOTP'],
          "tempStudentId": widget.userInputData['tempStudentId'],
          "gender": isSelectMale
              ? 'male'
              : isSelectFemale
                  ? 'female'
                  : '',
          "class": _selectedClassId,
          "section": _selectedSectionId
        };
      } else {
        dataMap = {
          "name": _fullNameController.text.trim().toString(),
          "email": widget.userInputData['email'],
          "password": widget.userInputData['password'],
          "tempStudentId": widget.userInputData['tempStudentId'],
          "gender": isSelectMale
              ? 'male'
              : isSelectFemale
                  ? 'female'
                  : '',
          "class": _selectedClassId,
          "section": _selectedSectionId
        };
      }
      authController.studentRegistrationNew(data: dataMap, schoolId: widget.schoolId).then((value) {
        if (value) {
          if (authController.loginType == LoginType.phone) {
            authController.verifyLoginOTP(contact: dataMap['contact'].toString(), otp: dataMap['loginOTP'].toString()).then((value) {
              if (value) {
                showMultiAuthSheet(authController: authController, context: context);
              }
            });
          } else if (authController.loginType == LoginType.email) {
            authController
                .loginWithEmail(
              email: dataMap['email'].toString().trim(),
              password: dataMap['password'].toString().trim(),
            )
                .then((value) {
              if (value) {
                showMultiAuthSheet(authController: authController, context: context);
              }
            });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 16.w,
            top: 16.h,
            bottom: 16.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.w),
              topRight: Radius.circular(20.w),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colorGrey100,
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: SizedBox(
                          height: 10.h,
                          width: 10.w,
                          child: SvgPicture.asset(
                            '${imageAssets}auth/close_ic_1.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "Select Gender",
                        style: textTitle16StylePoppins.merge(
                          TextStyle(
                            color: colorGrey400,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: fontFamilyPoppins,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSelectMale = true;
                                isSelectFemale = false;
                              });
                            },
                            child: Container(
                              width: 60.w,
                              height: 60.w,
                              padding: EdgeInsets.fromLTRB(2.w, 8.h, 2.w, 0.h),
                              decoration: BoxDecoration(
                                color: colorPink20,
                                shape: BoxShape.circle,
                                border:
                                    isSelectMale ? Border.all(color: colorPurpleDarkLight, width: 2.w) : Border.all(color: colorPink100, width: 1.w),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(300.0),
                                child: SvgPicture.asset(
                                  '${imageAssets}auth/boy.svg',
                                  // fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSelectMale = false;
                                isSelectFemale = true;
                              });
                            },
                            child: Container(
                              width: 60.w,
                              height: 60.w,
                              padding: EdgeInsets.fromLTRB(2.w, 8.h, 2.w, 0.h),
                              decoration: BoxDecoration(
                                color: colorPink20,
                                shape: BoxShape.circle,
                                border: isSelectFemale ? Border.all(color: colorBlue300, width: 2.w) : Border.all(color: colorBlue70, width: 1.w),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(300.0),
                                child: SvgPicture.asset(
                                  '${imageAssets}auth/girl.svg',
                                  // fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Focus(
                        onFocusChange: (v) {
                          isFocusOnFullName = !isFocusOnFullName;
                          setState(() {});
                        },
                        child: TextFormField(
                          controller: _fullNameController,
                          style: textTitle16StylePoppins.merge(const TextStyle(color: colorGrey700, fontWeight: FontWeight.w400, fontSize: 16)),
                          maxLines: 1,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 6.h, top: 2.h),
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Full name",
                            counterText: "",
                            hintText: "",
                            labelStyle: textTitle16StylePoppins.copyWith(
                              color: const Color(0xff98A2B3),
                              fontWeight: FontWeight.w400,
                              fontSize: isFocusOnFullName || _fullNameController.text.isNotEmpty ? 18.sp : 16.sp,
                              fontFamily: isFocusOnFullName || _fullNameController.text.isNotEmpty ? fontFamilyMedium : fontFamilyPoppins,
                            ),
                            hintStyle: textTitle14RegularStyle.merge(
                              const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: fontFamilyMedium,
                              ),
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
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              GestureDetector(
                onTap: () {
                  if (widget.fromAddSchool || widget.isFromLoginAddSchool == true) {
                    onAddSchool();
                  } else {
                    onSubmit();
                  }
                },
                child: Container(
                  height: 40.h,
                  margin: EdgeInsets.only(bottom: 16.h),
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
                  child: Text("Submit", style: textTitle16StylePoppins.merge(const TextStyle(color: Colors.white, fontWeight: FontWeight.w500))),
                ),
              ),
            ],
          ),
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
                        user.name == null ? ('${user.firstName} ${user.lastName}') : ('${user.name}'),
                        style: textTitle14BoldStyle
                            .merge(TextStyle(color: colorBlue600, fontFamily: fontFamilyPoppins, fontWeight: FontWeight.w500, fontSize: 20.sp)),
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
          isDismissible: false,
          builder: (context) {
            return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Select User Profile",
                          style: textTitle14BoldStyle
                              .merge(TextStyle(color: colorDarkText, fontFamily: fontFamilyPoppins, fontWeight: FontWeight.w500, fontSize: 14.sp)),
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
              ),
            );
          });
    } else {
      _onLoginSucess();
    }
  }
}
