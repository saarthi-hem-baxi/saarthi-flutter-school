// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/login_new_screen.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/auth_controllers.dart';
import '../../helpers/const.dart';
import '../../model/auth/help_page.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({
    Key? key,
    this.isFromRegistrationLink = false,
    this.schoolId = '',
  }) : super(key: key);

  final bool isFromRegistrationLink;
  final String schoolId;

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final AuthController _authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (widget.isFromRegistrationLink) {
        _authController.getSupportExecutiveDetails(
          schoolId: widget.schoolId,
        );
      } else {
        _authController.getHelpPageContactDetails();
      }
    });
  }

  Future<void> _openDialer({required String contactNumber}) async {
    String url = Platform.isIOS ? 'tel://$contactNumber' : 'tel:$contactNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Fluttertoast.showToast(msg: 'Cannot open call dialer');
    }
  }

  Future<void> _openMailApp({required String mailAddress}) async {
    try {
      String url = 'mailto:$mailAddress';
      await launchUrl(Uri.parse(url));
    } catch (e) {
      Fluttertoast.showToast(msg: 'Cannot open mail app');
    }
  }

  void onBack() {
    _authController.logout();
    Get.offAll(() => const LoginNewScreen(
          isFromPasswordReset: false,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (_authController.helpPageLoading.isTrue) {
            return const Align(
              alignment: Alignment.center,
              child: LoadingSpinner(),
            );
          } else {
            HelpPageContactModal data = _authController.helpPageContactData.value;
            return WillPopScope(
              onWillPop: () async {
                onBack();
                return true;
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: onBack,
                        child: Container(
                          width: 32.w,
                          height: 32.w,
                          padding: EdgeInsets.all(5.w),
                          decoration: BoxDecoration(
                            color: colorGrey100,
                            borderRadius: BorderRadius.circular(10.w),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Center(
                        child: Image.asset(
                          '${imageAssets}customer_care.png',
                          width: 30,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Center(
                        child: Text(
                          'Help',
                          style: textTitle18StylePoppins.copyWith(
                            color: colorGrey800,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      (data.executiveName ?? "").trim().isNotEmpty
                          ? Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: const Color(0xffFAFAFA),
                                borderRadius: BorderRadius.circular(10.w),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    data.executiveName ?? "",
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTitle20StylePoppins.copyWith(color: colorGrey800, fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'Contact Person',
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTitle14StylePoppins.copyWith(
                                      color: colorGrey400,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: Color(0xffFAFAFA),
                              ),
                              child: Column(children: [
                                Text('Saarthi Pedagogy Support',
                                    style: textTitle16StylePoppins
                                        .merge(const TextStyle(color: colorGrey800, fontSize: 20, fontWeight: FontWeight.w600))),
                              ]),
                            ),
                      SizedBox(
                        height: 20.h,
                      ),
                      InformationListTile(
                        bgColor: const Color(0xffFFFDF5),
                        borderColor: const Color(0xffFFEDCC),
                        textColor: const Color(0xffBB7124),
                        iconName: 'email_icon.png',
                        text: data.executiveEmail ?? "",
                        onTap: () {
                          _openMailApp(mailAddress: data.executiveEmail ?? "");
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      InformationListTile(
                        bgColor: const Color(0xffF5FCFF),
                        borderColor: const Color(0xffDBEAFF),
                        textColor: const Color(0xff1554D1),
                        iconName: 'phone_call_icon.png',
                        text: '+91 ' + (data.executiveContact ?? ""),
                        onTap: () {
                          _openDialer(contactNumber: '+91 ' + (data.executiveContact ?? ""));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}

class InformationListTile extends StatelessWidget {
  const InformationListTile({
    Key? key,
    required this.bgColor,
    required this.borderColor,
    required this.textColor,
    required this.iconName,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final Color bgColor;
  final Color borderColor;
  final Color textColor;
  final String iconName;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
            width: 1,
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(10.w),
        ),
        child: Row(
          children: [
            Image.asset(
              '${imageAssets}${iconName}',
              width: 26.w,
            ),
            SizedBox(
              width: 16.w,
            ),
            Flexible(
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTitle16StylePoppins.copyWith(
                  color: textColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
