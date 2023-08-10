import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/auth/users.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/gradient_circle.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/header.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';

class ProfileScreenPage extends StatefulWidget {
  const ProfileScreenPage({Key? key, required this.currentUser}) : super(key: key);

  final User currentUser;

  @override
  State<ProfileScreenPage> createState() => _ProfileScreenPageState();
}

class _ProfileScreenPageState extends State<ProfileScreenPage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScreenBg1Purple,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned(
              left: -150,
              child: GradientCircle(
                gradient: circlePurpleGradient,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(125),
                  bottomRight: Radius.circular(125),
                ),
              ),
            ),
            const Positioned(
              right: -220,
              bottom: -40,
              child: GradientCircle(
                gradient: circleOrangeGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(125),
                  bottomLeft: Radius.circular(125),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: -15.w,
              child: Transform.rotate(
                angle: 0,
                child: SvgPicture.asset(
                  imageAssets + 'auth/vibgyor.svg',
                  // allowDrawingOutsideViewBox: true,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: (getScrenHeight(context) / 2) - 100,
              height: 200,
              child: SvgPicture.asset(
                imageAssets + 'profile/profile_center.svg',
                // allowDrawingOutsideViewBox: true,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 80.h,
              right: 0,
              child: SvgPicture.asset(
                imageAssets + 'profile/book.svg',
                // allowDrawingOutsideViewBox: true,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: getScrenHeight(context),
              child: Column(
                children: [
                  HeaderCard(
                    title: "Profile",
                    backEnabled: true,
                    onTap: () => {Navigator.pop(context)},
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                    decoration: boxDecoration14,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 60.w,
                          height: 60.w,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
                          child: (widget.currentUser.thumb != null && widget.currentUser.thumb!.isNotEmpty)
                              ? CircleAvatar(backgroundImage: NetworkImage(widget.currentUser.thumb ?? ""))
                              : Icon(
                                  Icons.account_circle_rounded,
                                  size: 50.w,
                                  color: colorText163Gray,
                                ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // widget.currentUser.firstName ?? "",
                                widget.currentUser.name == null
                                    ? ('${widget.currentUser.firstName} ${widget.currentUser.lastName}')
                                    : ('${widget.currentUser.name}'),

                                style: textTitle20WhiteBoldStyle.merge(const TextStyle(color: colorPink)),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 2.h),
                                child: Text(
                                  'Class ${widget.currentUser.userClass?.name} ${widget.currentUser.section?.name}',
                                  style: textTitle14BoldStyle.merge(const TextStyle(color: colorWebPanelDarkText)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            width: 60.w,
                            height: 60.w,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
                            child: Column(
                              children: [
                                Text(
                                  widget.currentUser.rollNo ?? "-",
                                  style: textTitle18WhiteBoldStyle.merge(
                                    const TextStyle(color: colorWebPanelDarkText),
                                  ),
                                  maxLines: 1,
                                ),
                                Text(
                                  "Roll No",
                                  style: textTitle12BoldStyle.merge(
                                    const TextStyle(color: colorBodyText),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Container(
                    alignment: AlignmentDirectional.centerStart,
                    margin: EdgeInsets.only(top: 16.h, left: 16.h, right: 16.h),
                    child: Text(
                      "Academic Details",
                      style: textTitle18WhiteBoldStyle.merge(
                        const TextStyle(color: sectionTitleColor),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 16.h, right: 16.h, top: 10.h),
                    decoration: boxDecoration14,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 60.w,
                          height: 60.w,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
                          child: (widget.currentUser.school?.logoThumb != null && (widget.currentUser.school?.logoThumb ?? "").isNotEmpty)
                              ? CircleAvatar(backgroundImage: NetworkImage(widget.currentUser.school?.logoThumb ?? ""))
                              : Icon(
                                  Icons.account_circle_rounded,
                                  size: 50.w,
                                  color: colorText163Gray,
                                ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.currentUser.school?.name ?? "",
                                style: textTitle14BoldStyle.merge(const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w700)),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 2.h),
                                child: Text(
                                  '${(widget.currentUser.school?.board?.shortName ?? "").isNotEmpty ? widget.currentUser.school?.board?.shortName ?? "" : "-"} | ${(widget.currentUser.school?.medium?.name ?? "").isNotEmpty ? widget.currentUser.school?.medium?.name ?? "" : "-"}',
                                  style: textTitle14BoldStyle.merge(const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: AlignmentDirectional.centerStart,
                    margin: EdgeInsets.only(top: 20.h, left: 16.h, right: 16.h),
                    child: Text(
                      "Personal Details",
                      style: textTitle18WhiteBoldStyle.merge(
                        const TextStyle(color: sectionTitleColor),
                      ),
                    ),
                  ),
                  Container(
                    width: getScreenWidth(context),
                    padding: const EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 16.h, right: 16.h, top: 10.h),
                    decoration: boxDecoration14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: textTitle14BoldStyle.merge(const TextStyle(color: colorWebPanelDarkText)),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 2.h),
                          child: Text(
                            (widget.currentUser.email ?? "").isNotEmpty ? widget.currentUser.email ?? "" : "-",
                            style: textTitle14BoldStyle.merge(const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal)),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          "Mobile Number",
                          style: textTitle14BoldStyle.merge(const TextStyle(color: colorWebPanelDarkText)),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 2.h),
                          child: Text(
                            (widget.currentUser.contact ?? "").isNotEmpty ? "+91 ${widget.currentUser.contact ?? ""}" : "-",
                            style: textTitle14BoldStyle.merge(const TextStyle(color: colorBodyText, fontWeight: FontWeight.normal)),
                          ),
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
    );
  }
}
