import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/auth/teaching.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration_3.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration_4.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/auth/circular_icon_btn.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/no_data_found_text.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/common/custom_network_image.dart';

class RegistrationPage2 extends StatefulWidget {
  const RegistrationPage2({Key? key, required this.userInputData}) : super(key: key);
  final Map userInputData;

  @override
  State<RegistrationPage2> createState() => _RegistrationPage2State();
}

class _RegistrationPage2State extends State<RegistrationPage2> {
  double marginHorizontal = 20;
  double boyGirlToContainerDiff = 40;
  final _formKey = GlobalKey<FormState>();
  final authController = Get.put(AuthController());

  String _selectedClassId = '';
  String _selectedSectionId = '';

  List<Sections> _sections = [];

  @override
  void initState() {
    super.initState();
    authController.getTeachingData(schoolId: widget.userInputData['schoolId']).then((v) {
      if (authController.teachingData.isNotEmpty) {
        _selectedClassId = authController.teachingData.first.id ?? "";
        _sections = authController.teachingData.first.sections ?? [];
        _selectedSectionId = _sections.first.id ?? "";
      }
      setState(() {});
    });
  }

  submitForm(BuildContext context) {
    if (_selectedClassId.isEmpty || _selectedSectionId.isEmpty) {
      Fluttertoast.showToast(msg: "Please select class and section");
    } else {
      widget.userInputData['class'] = _selectedClassId;
      widget.userInputData['section'] = _selectedSectionId;

      authController.checkStudentDuplication(schoolId: widget.userInputData['schoolId'], data: widget.userInputData).then((v) {
        if (v) {
          if (widget.userInputData['email'] == "") {
            authController.studentRegistration(data: widget.userInputData).then((value) {
              if (value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistrationPage4(
                      userInputData: widget.userInputData,
                    ),
                  ),
                );
              }
            });
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage3(userInputData: widget.userInputData)));
          }
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
              Obx(
                () => Center(
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
                                    imageAssets + 'auth/select_academic.svg',
                                    height: 200.h,
                                  ),
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          alignment: AlignmentDirectional.topStart,
                                          child: Text(
                                            "Class/Section",
                                            style: sectionTitleTextStyle.merge(TextStyle(fontSize: 24.sp)),
                                          ),
                                        ),
                                        authController.teachingLoading.isTrue
                                            ? const Center(child: LoadingSpinner())
                                            : authController.teachingData.isEmpty
                                                ? Container(
                                                    margin: EdgeInsets.only(top: 20.h),
                                                    child: const NoDataFoundText(
                                                      title: "No Class found!",
                                                    ),
                                                  )
                                                : Container(
                                                    margin: const EdgeInsets.only(top: 15),
                                                    child: Container(
                                                      margin: const EdgeInsets.only(left: 10),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Class*", style: textFormTitleStyle),
                                                          DropdownButtonFormField(
                                                            decoration: InputDecoration(
                                                              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
                                                              contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                                                            ),
                                                            isExpanded: true,
                                                            isDense: true,
                                                            value: authController.teachingData.first.id,
                                                            items: authController.teachingData.map<DropdownMenuItem<String>>((value) {
                                                              return DropdownMenuItem(
                                                                value: value.id,
                                                                child: Text(
                                                                  value.name ?? "",
                                                                  style: textTitle14BoldStyle
                                                                      .merge(const TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
                                                                ),
                                                              );
                                                            }).toList(),
                                                            onChanged: (v) {
                                                              _selectedClassId = v.toString();
                                                              _sections = authController.teachingData
                                                                      .where((p0) => p0.id == v.toString())
                                                                      .toList()
                                                                      .first
                                                                      .sections ??
                                                                  [];
                                                              _selectedSectionId = _sections.first.id ?? "";
                                                              setState(() {});
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        authController.teachingLoading.isTrue
                                            ? Container()
                                            : Container(
                                                margin: const EdgeInsets.only(top: 15),
                                                child: Container(
                                                  margin: const EdgeInsets.only(left: 10),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      authController.teachingData.isEmpty ? Container() : Text("Section*", style: textFormTitleStyle),
                                                      Wrap(
                                                        runAlignment: WrapAlignment.start,
                                                        alignment: WrapAlignment.start,
                                                        children: _sections
                                                            .map(
                                                              (e) => Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 24.w,
                                                                    width: 24.w,
                                                                    child: Theme(
                                                                      data: ThemeData(unselectedWidgetColor: colorSky),
                                                                      child: Radio<String>(
                                                                        value: e.id ?? "",
                                                                        groupValue: _selectedSectionId,
                                                                        activeColor: colorSky,
                                                                        onChanged: (v) {
                                                                          _selectedSectionId = v.toString();
                                                                          setState(() {});
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5.w,
                                                                  ),
                                                                  Text(
                                                                    e.name ?? "",
                                                                    style: textTitle16WhiteRegularStyle.merge(const TextStyle(color: Colors.black)),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10.w,
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                            .toList(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Container(
                                          decoration: boxDecoration6,
                                          margin: EdgeInsets.only(left: 15.sp, top: 10.sp),
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
                                                  "Back To Registration",
                                                  style: textFormSmallerTitleStyle.merge(const TextStyle(color: colorPink)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Obx(
                                          () => Container(
                                            alignment: AlignmentDirectional.topEnd,
                                            child: authController.duplicationLoading.isTrue || authController.registerLoading.isTrue
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
                                        ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
