import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/precap_controller.dart';
import 'package:saarthi_pedagogy_studentapp/globals.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/screen/productvideotour/learn_introvideo_screen.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../helpers/utils.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';

class HeaderCard extends StatefulWidget {
  final String title;
  final bool backEnabled;
  final bool introVideoEnabled;
  final bool isExamScreenHeader;
  final Color textColor;
  final IconData? leadingIcon;
  final VoidCallback onTap;
  final double marginTop;

  const HeaderCard(
      {Key? key,
      required this.title,
      this.backEnabled = false,
      this.introVideoEnabled = true,
      this.isExamScreenHeader = false,
      this.textColor = sectionTitleColor,
      required this.onTap,
      this.leadingIcon,
      this.marginTop = 10})
      : super(key: key);

  @override
  _HeaderCardState createState() => _HeaderCardState();
}

class _HeaderCardState extends State<HeaderCard> {
  final testsController = Get.put(PrecapController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 16.w,
      ),
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.backEnabled
              ? InkWell(
                  onTap: widget.onTap,
                  child: Container(
                    height: 32.h,
                    width: 32.h,
                    margin: EdgeInsets.only(
                      right: 20,
                      top: widget.marginTop,
                    ),
                    decoration: boxDecoration10,
                    child: Icon(
                      widget.leadingIcon ?? Icons.arrow_back_outlined,
                      size: 18,
                      color: sectionTitleColor,
                    ),
                  ),
                )
              : Container(),
          Expanded(
            child: SizedBox(
              width: getScreenWidth(context) - 100,
              child: Text(
                widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: sectionTitleTextStyle.merge(
                  TextStyle(color: widget.textColor),
                ),
              ),
            ),
          ),
          widget.introVideoEnabled
              ? Container()
              : InkWell(
                  onTap: () {
                    videoControl = true;
                    Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (context, animation, anotherAnimation) {
                          return const LearnIntroVideoScreen();
                        },
                        transitionDuration: const Duration(milliseconds: 1000),
                        transitionsBuilder: (context, animation, anotherAnimation, child) {
                          animation = CurvedAnimation(curve: Curves.easeInOutCubicEmphasized, parent: animation);
                          return Align(
                            child: SizeTransition(
                              sizeFactor: animation,
                              child: child,
                              axisAlignment: 0.0,
                            ),
                          );
                        }));
                  },
                  child: Container(
                    height: 30.w,
                    width: 30.w,
                    margin: EdgeInsets.only(right: 10.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.w),
                      border: Border.all(
                        width: 1,
                        color: const Color(0xffF4EFF6),
                      ),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.w),
                        child: SvgPicture.asset(
                          imageAssets + 'ic_introvideo.svg',
                          allowDrawingOutsideViewBox: true,
                          //color: Colors.white,
                          fit: BoxFit.fitHeight,
                        )
                        // Image.asset(imageAssets + 'ic_introvideo.svg'),
                        ),
                  ),
                ),
          widget.isExamScreenHeader
              ? SizedBox(
                  height: 40.h,
                  width: 50.w,
                  child: SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        showLabels: false,
                        showTicks: false,
                        startAngle: 270,
                        endAngle: 270,
                        minimum: 0,
                        maximum: 100,
                        radiusFactor: 0.80,
                        axisLineStyle:
                            const AxisLineStyle(color: Color.fromRGBO(106, 110, 246, 0.2), thicknessUnit: GaugeSizeUnit.factor, thickness: 0.1),
                        pointers: <GaugePointer>[
                          RangePointer(
                              value: testsController.totalKeylerningExamPer.toDouble(),
                              cornerStyle: CornerStyle.bothCurve,
                              enableAnimation: true,
                              animationDuration: 1000,
                              animationType: AnimationType.ease,
                              sizeUnit: GaugeSizeUnit.factor,
                              color: colorSky,
                              width: 0.1),
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                              angle: 0,
                              positionFactor: 0.1,
                              widget: Text(
                                "${testsController.totalKeylerningExamPer.toInt().toString()}%",
                                style: textTitle10RegularStyle,
                              )),
                        ],
                      ),
                    ],
                  ),
                )
              : Container(),
          // Container(child:SfRadialGauge(
          //   axes: <RadialAxis>[RadialAxis()],
          // ),)
        ],
      ),
    );
  }
}
