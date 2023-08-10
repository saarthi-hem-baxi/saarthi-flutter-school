import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/theme/colors.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key, required this.schoolId}) : super(key: key);
  final String schoolId;

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final AuthController _authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _authController.getSupportExecutiveDetails(schoolId: widget.schoolId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Obx(
        () => _authController.helpPageLoading.isTrue
            ? const Center(
                child: LoadingSpinner(),
              )
            : SingleChildScrollView(
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
                            '${imageAssets}customer_care.png',
                            width: 30,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text('Help',
                            style: textTitle16StylePoppins.merge(const TextStyle(color: colorGrey800, fontSize: 18, fontWeight: FontWeight.w400))),
                      ],
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    (_authController.helpPageContactData.value.executiveName ?? "").trim().isNotEmpty
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
                                  _authController.helpPageContactData.value.executiveName ?? "",
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
                                  style:
                                      textTitle16StylePoppins.merge(const TextStyle(color: colorGrey800, fontSize: 20, fontWeight: FontWeight.w600))),
                              // Text('Support Executive',
                              //     style: textTitle16StylePoppins.merge(const TextStyle(color: colorGrey400, fontSize: 14, fontWeight: FontWeight.w400))),
                            ]),
                          ),
                    SizedBox(
                      height: 20.h,
                    ),
                    InformationListTile(
                      bgColor: colorYellow150,
                      borderColor: colorYellow200,
                      textColor: colorYellow700,
                      iconName: 'email_icon.png',
                      text: _authController.helpPageContactData.value.executiveEmail ?? "",
                      onTap: () {
                        _openMailApp(mailAddress: _authController.helpPageContactData.value.executiveEmail ?? "");
                      },
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    InformationListTile(
                      bgColor: colorBlue50,
                      borderColor: colorBlue100,
                      textColor: colorBlue700,
                      iconName: 'phone_call_icon.png',
                      text: '+91 ${_authController.helpPageContactData.value.executiveContact ?? ""}',
                      onTap: () {
                        _openDialer(contactNumber: '+91 ${_authController.helpPageContactData.value.executiveContact ?? ""}');
                      },
                    ),
                  ],
                ),
              )),
      )),
    );
  }

  Future<void> _openMailApp({required String mailAddress}) async {
    try {
      String url = 'mailto:$mailAddress';
      await launchUrl(Uri.parse(url));
    } catch (e) {
      Fluttertoast.showToast(msg: 'Cannot open mail app');
    }
  }

  Future<void> _openDialer({required String contactNumber}) async {
    String url = Platform.isIOS ? 'tel://$contactNumber' : 'tel:$contactNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Fluttertoast.showToast(msg: 'Cannot open call dialer');
    }
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
              '$imageAssets$iconName',
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
                style: textTitle16StylePoppins.copyWith(color: textColor, fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
      ),
    );
  }
}
