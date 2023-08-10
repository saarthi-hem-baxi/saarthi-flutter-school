import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/login_new_screen.dart';

import '../../helpers/const.dart';
import '../../helpers/utils.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import 'help_page.dart';

class LicenceExpiredPopUp {
  static showPopUp({bool isFromRegistrationLink = false, String schoolId = ''}) {
    Get.dialog(
      LicenceExpiredPopUpWidget(
        isFromRegistrationLink: isFromRegistrationLink,
        schoolId: schoolId,
      ),
      barrierDismissible: false,
    );
  }
}

class LicenceExpiredPopUpWidget extends StatefulWidget {
  const LicenceExpiredPopUpWidget({Key? key, required this.isFromRegistrationLink, required this.schoolId}) : super(key: key);

  final bool isFromRegistrationLink;
  final String schoolId;

  @override
  State<LicenceExpiredPopUpWidget> createState() => _LicenceExpiredPopUpWidgetState();
}

class _LicenceExpiredPopUpWidgetState extends State<LicenceExpiredPopUpWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();

  final AuthController _authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
    _authController.isOpenSubscriptionPopup.value = false;
  }

  void navigateToHelpPage() {
    Navigator.pop(context); // hide current page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HelpPage(
          isFromRegistrationLink: widget.isFromRegistrationLink,
          schoolId: widget.schoolId,
        ),
      ),
    );
  }

  void onClose() {
    Navigator.pop(context);
    _authController.logout();
    Get.offAll(() => const LoginNewScreen());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: SizedBox(
            height: getScrenHeight(context) - 32.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _animationController,
                  builder: ((context, child) {
                    return Positioned(
                      top: -50,
                      child: Transform.rotate(
                        angle: _animationController.value * 2 * math.pi,
                        child: SvgPicture.asset('${imageAssets}light_rays.svg'),
                      ),
                    );
                  }),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ClipRRect(
                        child: Container(
                          margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 124),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14.w),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(14.w), topRight: Radius.circular(14.w)),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xff3958C6), Color(0xff213373)],
                                    begin: FractionalOffset.topCenter,
                                    end: FractionalOffset.bottomCenter,
                                  ),
                                ),
                                child: SvgPicture.asset('${imageAssets}sarthi_hanging_logo.svg', height: 140.h),
                              ),
                              Padding(
                                padding: EdgeInsets.all(16.w),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      'Thank you for choosing Saarthi\nPedagogy as your learning companion!',
                                      textAlign: TextAlign.center,
                                      style: textTitle16StylePoppins.copyWith(
                                        color: colorGrey800,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.h,
                                    ),
                                    Text(
                                      'Unfortunately, your trial subscription has ended.\nContact your school administration\nfor further support.',
                                      textAlign: TextAlign.center,
                                      style: textTitle14StylePoppins.copyWith(
                                        color: colorGrey700,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Image.asset(
                                      '${imageAssets}animted_message_icon.gif',
                                      width: 100,
                                      height: 100,
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    InkWell(
                                      onTap: navigateToHelpPage,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                        decoration: BoxDecoration(
                                          color: colorBlue50,
                                          border: Border.all(width: 1, color: colorBlue300),
                                          borderRadius: BorderRadius.circular(10.w),
                                        ),
                                        child: Text(
                                          'Talk to Support now',
                                          style: textTitle14StylePoppins.copyWith(color: colorBlue600, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        '${imageAssets}childern_group.svg',
                        width: 350,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: InkWell(
                    onTap: onClose,
                    child: Container(
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                        color: colorGrey100,
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      child: const Icon(
                        Icons.close,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
