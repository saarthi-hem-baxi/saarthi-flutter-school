import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controllers.dart';
import '../../../helpers/const.dart';
import '../../../helpers/utils.dart';
import '../../../model/auth/citylist.dart';
import '../../../model/auth/schoollist.dart';
import '../../../theme/colors.dart';
import '../../../theme/style.dart';
import '../../../widgets/auth/custom_registration_appbar.dart';
import '../../../widgets/auth/registration_city_list_tile.dart';
import '../../../widgets/auth/registration_school_list_tile.dart';
import '../../../widgets/common/custom_network_image.dart';
import '../../../widgets/common/loading_spinner.dart';
import '../../../widgets/common/no_data_found_text.dart';
import 'login_new_screen.dart';
import 'registration_screen_3.dart';

// ignore: must_be_immutable
class RegistrationScreen2 extends StatefulWidget {
  RegistrationScreen2({
    Key? key,
    this.userInputData,
    required this.fromAddSchool,
    this.schoolId = '',
    this.isBackButton = true,
    this.isSingleSchoolUser = false,
    this.isFromLoginAddSchool,
  }) : super(key: key);

  Map? userInputData;
  bool fromAddSchool;
  String schoolId;
  bool isBackButton;
  bool isSingleSchoolUser;
  bool? isFromLoginAddSchool;

  @override
  State<RegistrationScreen2> createState() => _RegistrationScreen2State();
}

class _RegistrationScreen2State extends State<RegistrationScreen2> {
  List<CityListModel> allCityList = <CityListModel>[];
  List<SchoolListModel> allSchoolList = <SchoolListModel>[];
  final authController = Get.put(AuthController());
  final _debouncer = Debouncer();
  bool isCitySelected = false;
  bool isSchoolSelected = false;
  String selectedCityName = "";
  String selectedStateName = "";
  String selectedStateID = "";
  String selectedCityId = "";
  bool findingCity = false;
  bool findingSchool = false;
  SchoolListModel selectedSchoolData = SchoolListModel();
  bool editSchool = true;
  final TextEditingController searchCityController = TextEditingController(text: '');
  final TextEditingController searchSchoolController = TextEditingController(text: '');
  Color citySearchBarBackgroundColor = colorGrey25;
  Color schoolSearchBarBackgroundColor = colorGrey25;

  @override
  void initState() {
    super.initState();
    if (widget.schoolId.isNotEmpty) {
      authController.getSchoolDetail(schoolId: widget.schoolId).then((value) {
        editSchool = false;
        selectedCityId = authController.schoolData['address']['city']['_id'];
        selectedCityName = authController.schoolData['address']['city']['name'];
        selectedSchoolData = SchoolListModel(
          schoolListModelId: authController.schoolData['id'],
          id: authController.schoolData['_id'],
          name: authController.schoolData['name'],
          logo: authController.schoolData['logo'],
          logoThumb: authController.schoolData['logoThumb'],
          address: Address(
            city: City(
              cityId: authController.schoolData['address']['city']['_id'],
              id: authController.schoolData['address']['city']['id'],
              name: selectedCityName,
            ),
          ),
        );
        isCitySelected = true;
        isSchoolSelected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    onNext() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegistrationScreen3(
            userInputData: widget.userInputData ?? {},
            schoolId: selectedSchoolData.id ?? '',
            fromAddSchool: widget.fromAddSchool,
            fromRegitrationLink: false,
            isFromLoginAddSchool: widget.isFromLoginAddSchool,
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async => widget.isBackButton,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(
                () {
                  return authController.schoolLoading.isTrue
                      ? const Center(
                          child: LoadingSpinner(),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 8.h,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  widget.isSingleSchoolUser
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 20.h),
                                            SizedBox(
                                              height: 30.h,
                                              width: 100.w,
                                              child: SvgPicture.asset(
                                                '${imageAssets}auth/saarthi_logo.svg',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(height: 40.h),
                                            Center(
                                              child: Text("Specially designed for".toUpperCase(),
                                                  style: textTitle16StylePoppins.merge(const TextStyle(
                                                      color: colorGrey400, fontWeight: FontWeight.w500, fontSize: 12, letterSpacing: 6))),
                                            ),
                                            SizedBox(height: 40.h),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            CustomRegistrationAppBar(
                                              isfromRegistrationLink: false,
                                              progress: 0.5,
                                              isBackButton: widget.isBackButton,
                                            ),
                                            Image.asset(
                                              '${imageAssets}auth/handshake.png',
                                              height: 30.h,
                                              width: 30.w,
                                              fit: BoxFit.contain,
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Text(
                                              "Let's start your registration",
                                              style: textTitle16StylePoppins.copyWith(
                                                color: colorGrey800,
                                                fontSize: 18.sp,
                                                fontFamily: fontFamilyMedium,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.4,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 40.h,
                                            ),
                                            SizedBox(
                                              height: 60.w,
                                              width: 60.w,
                                              child: SvgPicture.asset(
                                                '${imageAssets}auth/school_1.svg',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                          ],
                                        ),

                                  Column(
                                    children: [
                                      widget.isSingleSchoolUser
                                          ? const SizedBox()
                                          : Row(
                                              children: [
                                                SizedBox(
                                                  height: 24.w,
                                                  width: 24.w,
                                                  child: SvgPicture.asset(
                                                    '${imageAssets}auth/building_1.svg',
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                isCitySelected
                                                    ? Expanded(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                '$selectedCityName, $selectedStateName',
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: textTitle16StylePoppins.merge(
                                                                  const TextStyle(
                                                                    color: colorGrey700,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            editSchool
                                                                ? Align(
                                                                    alignment: Alignment.topRight,
                                                                    child: GestureDetector(
                                                                      onTap: () {
                                                                        setState(() {
                                                                          isCitySelected = false;
                                                                          findingCity = false;
                                                                          isSchoolSelected = false;
                                                                          findingSchool = false;
                                                                        });
                                                                      },
                                                                      child: SizedBox(
                                                                        height: 17.h,
                                                                        width: 17.w,
                                                                        child: SvgPicture.asset(
                                                                          '${imageAssets}auth/edit_pencil.svg',
                                                                          fit: BoxFit.contain,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const SizedBox(),
                                                          ],
                                                        ),
                                                      )
                                                    // Start city search bar input
                                                    : Expanded(
                                                        child: SizedBox(
                                                          height: 35.h,
                                                          child: Focus(
                                                            onFocusChange: (hasFocus) {
                                                              if (hasFocus) {
                                                                citySearchBarBackgroundColor = colorGrey50;
                                                              } else {
                                                                citySearchBarBackgroundColor = colorGrey25;
                                                              }
                                                              setState(() {});
                                                            },
                                                            child: TextField(
                                                              controller: searchCityController,
                                                              onChanged: (string) {
                                                                _debouncer.run(
                                                                  () {
                                                                    if (string.isNotEmpty) {
                                                                      filterSearchCityResults(string.trim());
                                                                    } else {
                                                                      setState(() {
                                                                        allCityList.clear();
                                                                      });
                                                                    }
                                                                  },
                                                                );
                                                              },
                                                              autofocus: false,
                                                              style: textTitle16StylePoppins.merge(
                                                                TextStyle(
                                                                  color: colorGrey500,
                                                                  fontSize: 14.sp,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                              cursorColor: colorGrey400,
                                                              decoration: InputDecoration(
                                                                fillColor: citySearchBarBackgroundColor,
                                                                contentPadding: EdgeInsets.all(8.w),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(10.w),
                                                                  borderSide: const BorderSide(
                                                                    color: colorGrey200,
                                                                    width: 1.5,
                                                                  ),
                                                                ),
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(10.w),
                                                                  borderSide: const BorderSide(
                                                                    color: colorGrey500,
                                                                    width: 1.5,
                                                                  ),
                                                                ),
                                                                filled: true,
                                                                border: InputBorder.none,
                                                                hintText: "Search your city...",
                                                                prefixIcon: SizedBox(
                                                                  height: 13.w,
                                                                  width: 13.w,
                                                                  child: SvgPicture.asset(
                                                                    '${imageAssets}auth/search.svg',
                                                                    fit: BoxFit.none,
                                                                  ),
                                                                ),
                                                                suffixIcon: searchCityController.text.isNotEmpty
                                                                    ? InkWell(
                                                                        onTap: () {
                                                                          Future.delayed(Duration.zero, () {
                                                                            searchCityController.clear();
                                                                            isCitySelected = false;
                                                                            findingCity = false;
                                                                            allSchoolList.clear();
                                                                            setState(() {});
                                                                            FocusScope.of(context).unfocus();
                                                                          });
                                                                        },
                                                                        child: const Icon(
                                                                          Icons.close,
                                                                          size: 18,
                                                                          color: colorGrey500,
                                                                        ),
                                                                      )
                                                                    : const SizedBox(),
                                                                hintStyle: textTitle16StylePoppins.copyWith(
                                                                  color: colorGrey500,
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                // end city search bar input
                                              ],
                                            ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                    ],
                                  ),
                                  // start city & state list modal
                                  isCitySelected
                                      ? const SizedBox()
                                      : !findingCity
                                          ? const SizedBox()
                                          : Obx(
                                              () => authController.cityandSchoolloading.isTrue
                                                  ? const Center(
                                                      child: LoadingSpinner(),
                                                    )
                                                  : allCityList.isNotEmpty
                                                      ? Expanded(
                                                          child: SingleChildScrollView(
                                                            child: Container(
                                                              constraints: BoxConstraints(maxHeight: getScrenHeight(context) / 2 - 80.h),
                                                              margin: EdgeInsets.only(left: 35.w),
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(10.w),
                                                                border: Border.all(
                                                                  color: colorGrey300,
                                                                  width: 1.w,
                                                                ),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: const Color(0xff292929).withOpacity(0.1),
                                                                    blurRadius: 6,
                                                                    offset: const Offset(0, 4),
                                                                  )
                                                                ],
                                                              ),
                                                              child: SingleChildScrollView(
                                                                child: Column(
                                                                  children: [
                                                                    ...allCityList.mapIndexed(
                                                                      (index, item) {
                                                                        return RegistrationCityListTile(
                                                                          onTap: () {
                                                                            isCitySelected = true;
                                                                            selectedCityName = item.name ?? '';
                                                                            selectedCityId = item.id ?? '';
                                                                            selectedStateID = item.state?.id ?? '';
                                                                            selectedStateName = item.state?.name ?? '';
                                                                            searchSchoolController.clear();
                                                                            allSchoolList.clear();
                                                                            setState(() {});
                                                                          },
                                                                          title: '${item.name}, ${item.state?.name}',
                                                                          highlightText: searchCityController.text.trim(),
                                                                        );
                                                                      },
                                                                    ).toList(),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : const NoDataFoundText(title: "City Not found!"),
                                            ),
                                  // end city & state list modal
                                  // start display of selected school details
                                  !isCitySelected
                                      ? const SizedBox()
                                      : isSchoolSelected
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                SizedBox(
                                                  height: 40.h,
                                                ),
                                                SizedBox(
                                                  width: 70.w,
                                                  height: 70.h,
                                                  child: (selectedSchoolData.logo?.isNotEmpty ?? false)
                                                      ? CustomNetworkImage(
                                                          imageUrl: selectedSchoolData.logo ?? "",
                                                          fit: BoxFit.contain,
                                                        )
                                                      : SvgPicture.asset(
                                                          '${imageAssets}schoollogo.svg',
                                                          fit: BoxFit.contain,
                                                        ),
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Stack(
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets.all(5),
                                                      width: double.infinity,
                                                      padding: EdgeInsets.all(15.w),
                                                      decoration: BoxDecoration(
                                                        color: colorGrey20,
                                                        borderRadius: BorderRadius.circular(10.w),
                                                        border: Border.all(
                                                          color: colorGrey200,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            (selectedSchoolData.name ?? ''),
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            textAlign: TextAlign.center,
                                                            style: textTitle16StylePoppins.copyWith(
                                                              color: colorGrey800,
                                                              fontSize: 16.sp,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5.h,
                                                          ),
                                                          Text(
                                                            selectedSchoolData.address?.city?.name ?? '',
                                                            style: textTitle16StylePoppins.copyWith(
                                                              color: colorGrey500,
                                                              fontSize: 14.sp,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    editSchool
                                                        ? Positioned(
                                                            top: -1,
                                                            right: 10,
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  isSchoolSelected = false;
                                                                  findingSchool = false;
                                                                });
                                                              },
                                                              child: SizedBox(
                                                                height: 17.w,
                                                                width: 17.w,
                                                                child: SvgPicture.asset(
                                                                  '${imageAssets}auth/edit_pencil.svg',
                                                                  fit: BoxFit.contain,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                  ],
                                                )
                                              ],
                                            )
                                          // end display of selected school details
                                          // Start school search bar input
                                          : SizedBox(
                                              height: 35.h,
                                              child: Focus(
                                                onFocusChange: (hasFocus) {
                                                  if (hasFocus) {
                                                    schoolSearchBarBackgroundColor = colorGrey50;
                                                  } else {
                                                    schoolSearchBarBackgroundColor = colorGrey25;
                                                  }
                                                  setState(() {});
                                                },
                                                child: TextField(
                                                  controller: searchSchoolController,
                                                  onChanged: (string) {
                                                    _debouncer.run(
                                                      () {
                                                        if (string.isNotEmpty) {
                                                          filterSearchSchoolResults(string.trim());
                                                          (string);
                                                        } else {
                                                          setState(() {
                                                            allSchoolList.clear();
                                                          });
                                                        }
                                                      },
                                                    );
                                                  },
                                                  style: textTitle16StylePoppins.merge(
                                                    TextStyle(
                                                      color: colorGrey700,
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  autofocus: false,
                                                  cursorColor: colorGrey400,
                                                  decoration: InputDecoration(
                                                    fillColor: schoolSearchBarBackgroundColor,
                                                    contentPadding: EdgeInsets.all(8.w),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10.w),
                                                      borderSide: const BorderSide(
                                                        color: colorGrey200,
                                                        width: 1.5,
                                                      ),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10.w),
                                                      borderSide: const BorderSide(
                                                        color: colorGrey500,
                                                        width: 1.5,
                                                      ),
                                                    ),
                                                    filled: true,
                                                    counterText: "",
                                                    border: InputBorder.none,
                                                    hintText: "Search your School...",
                                                    prefixIcon: SizedBox(
                                                      height: 13.h,
                                                      width: 13.w,
                                                      child: SvgPicture.asset(
                                                        '${imageAssets}auth/search.svg',
                                                        fit: BoxFit.none,
                                                      ),
                                                    ),
                                                    suffixIcon: searchSchoolController.text.isNotEmpty
                                                        ? InkWell(
                                                            onTap: () {
                                                              Future.delayed(Duration.zero, () {
                                                                searchSchoolController.clear();
                                                                isSchoolSelected = false;
                                                                allSchoolList.clear();
                                                                findingSchool = false;
                                                                setState(() {});
                                                                FocusScope.of(context).unfocus();
                                                              });
                                                            },
                                                            child: const Icon(
                                                              Icons.close,
                                                              size: 18,
                                                              color: colorGrey500,
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                    hintStyle: textTitle16StylePoppins.merge(
                                                      const TextStyle(
                                                        color: colorGrey400,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                  // end school search bar input
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  // start school list modal
                                  isSchoolSelected
                                      ? const SizedBox()
                                      : !findingSchool || !findingCity
                                          ? const SizedBox()
                                          : Obx(
                                              () => authController.cityandSchoolloading.isTrue
                                                  ? const Center(
                                                      child: LoadingSpinner(),
                                                    )
                                                  : allSchoolList.isNotEmpty
                                                      ? Expanded(
                                                          child: SingleChildScrollView(
                                                            child: Container(
                                                              constraints: BoxConstraints(maxHeight: getScrenHeight(context) / 2 - 60.h),
                                                              margin: EdgeInsets.only(bottom: 35.h),
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(10.w),
                                                                border: Border.all(
                                                                  color: colorGrey300,
                                                                  width: 1.w,
                                                                ),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: const Color(0xff292929).withOpacity(0.1),
                                                                    blurRadius: 6,
                                                                    offset: const Offset(0, 4),
                                                                  )
                                                                ],
                                                              ),
                                                              child: SingleChildScrollView(
                                                                child: Column(
                                                                  children: [
                                                                    ...allSchoolList
                                                                        .mapIndexed(
                                                                          (index, item) => RegistrtionSchoolListTile(
                                                                            onTap: () {
                                                                              setState(
                                                                                () {
                                                                                  isSchoolSelected = true;
                                                                                  selectedSchoolData = item;
                                                                                },
                                                                              );
                                                                            },
                                                                            schoolLogoUrl: item.logoThumb ?? "",
                                                                            title: item.name ?? "",
                                                                            highlightText: searchSchoolController.text.trim(),
                                                                          ),
                                                                        )
                                                                        .toList(),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : const NoDataFoundText(title: "School Not found!"),
                                            ),
                                ],
                              ),
                            ),
                            // end school list modal
                            isSchoolSelected
                                ? GestureDetector(
                                    onTap: () {
                                      onNext();
                                    },
                                    child: Container(
                                      constraints: BoxConstraints(maxHeight: 40.h),
                                      padding: EdgeInsets.all(7.w),
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
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        "Next",
                                        style: textTitle16StylePoppins.copyWith(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  )
                                : widget.fromAddSchool
                                    ? const SizedBox()
                                    : Padding(
                                        padding: EdgeInsets.only(bottom: 10.h),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Already growing with Saarthi Pedagogy?",
                                              style: textTitle16StylePoppins.copyWith(
                                                color: colorGrey600,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(width: 5.w),
                                            GestureDetector(
                                              onTap: (() {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => const LoginNewScreen(),
                                                  ),
                                                );
                                              }),
                                              child: Text(
                                                "Login",
                                                style: textTitle16StylePoppins.merge(
                                                  TextStyle(
                                                    color: colorGrey800,
                                                    fontSize: 18.sp,
                                                    fontFamily: fontFamilyMedium,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                            SizedBox(
                              height: 10.h,
                            )
                          ],
                        );
                },
              )),
        ),
      ),
    );
  }

  void filterSearchCityResults(String query) {
    authController.getCities(cityName: query.trim()).then((value) {
      setState(() {
        findingCity = true;
        allCityList = authController.cityListdata;
      });
    });
  }

  void filterSearchSchoolResults(String query) {
    authController.getSchools(cityName: selectedCityId.trim(), schoolName: query.trim(), stateId: selectedStateID).then((value) {
      setState(() {
        findingSchool = true;
        allSchoolList = authController.schoolListData;
      });
    });
  }
}

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      const Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}
