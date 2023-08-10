import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/screen/dashboard/learn_o_meter_details.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../controllers/dashboard_controller.dart';
import '../../../model/dashboard/learn_o_meter_modal.dart';
import '../../../theme/colors.dart';
import '../../common/loading_spinner.dart';

class LearnOMeterWidget extends StatelessWidget {
  LearnOMeterWidget({
    Key? key,
  }) : super(key: key);

  final DashboardController _dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _dashboardController.getLearnOMeterData(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Align(
            alignment: Alignment.center,
            child: LoadingSpinner(),
          );
        } else {
          if (snapshot.hasData) {
            LearnOMeterModal learnOMeterData = snapshot.data as LearnOMeterModal;
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LearnOMeterDetails(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                  top: 5.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.w),
                  boxShadow: const [
                    BoxShadow(
                      color: colorDropShadow,
                      blurRadius: 5,
                      spreadRadius: 0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Learn-o-meter",
                          style: textTitle14StyleMediumPoppins,
                        ),
                        Container(
                          padding: EdgeInsets.all(5.w),
                          decoration: BoxDecoration(
                            color: const Color(0xffF1E3FC),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text.rich(
                            TextSpan(
                              text: "${learnOMeterData.gainedValue}/",
                              style: textTitle16StylePoppins.merge(
                                const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff6C10B2),
                                ),
                              ),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: "${learnOMeterData.totalValue}",
                                  style: textTitle12StylePoppins.merge(
                                    const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff6C10B2),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: (learnOMeterData.clarity ?? 0).toStringAsFixed(0),
                            style: textTitle30StylePoppins,
                            children: <InlineSpan>[
                              TextSpan(
                                text: "%",
                                style: textTitle30StylePoppins,
                              )
                            ],
                          ),
                        ),
                        learnOMeterData.diffrenceValue != 0
                            ? Text(
                                "${(learnOMeterData.isValueUp ?? false) ? '+' : '-'} ${learnOMeterData.diffrenceValue}%",
                                style: textTitle12StylePoppins.merge(
                                  TextStyle(
                                    color: (learnOMeterData.isValueUp ?? false) ? colorGreen500 : colorRed500,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                    SizedBox(
                      height: 250,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SfRadialGauge(
                            axes: <RadialAxis>[
                              RadialAxis(
                                minimum: 0,
                                maximum: 100,
                                tickOffset: 5,
                                majorTickStyle: const MajorTickStyle(
                                  color: colorGrey500,
                                  thickness: 2,
                                ),
                                minorTickStyle: MinorTickStyle(
                                  color: colorGrey500.withOpacity(0.5),
                                  thickness: 1,
                                ),
                                minorTicksPerInterval: 9,
                                interval: 10,
                                axisLabelStyle: const GaugeTextStyle(
                                  color: colorGrey60,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: fontFamilyPoppins,
                                ),
                                ranges: <GaugeRange>[
                                  GaugeRange(
                                    startValue: 0,
                                    endValue: 20,
                                    color: Colors.red,
                                    startWidth: 10,
                                    endWidth: 10,
                                  ),
                                  GaugeRange(
                                    startValue: 20,
                                    endValue: 50,
                                    color: Colors.orange,
                                    startWidth: 10,
                                    endWidth: 10,
                                  ),
                                  GaugeRange(
                                    startValue: 50,
                                    endValue: 100,
                                    color: Colors.green,
                                    startWidth: 10,
                                    endWidth: 10,
                                  )
                                ],
                                pointers: <GaugePointer>[
                                  NeedlePointer(
                                    needleLength: 0.95,
                                    needleColor: const Color.fromRGBO(16, 24, 40, 1),
                                    value: (learnOMeterData.clarity ?? 0).toDouble(),
                                    enableAnimation: true,
                                    animationType: AnimationType.linear,
                                    animationDuration: 4000,
                                    needleEndWidth: 10,
                                    knobStyle: const KnobStyle(
                                      knobRadius: 0.07,
                                      color: Color.fromRGBO(102, 112, 133, 1),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Positioned(
                            bottom: 20,
                            child: Text(
                              "Concept\nCleared",
                              style: textTitle12StylePoppins.merge(
                                const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Align(
              alignment: Alignment.center,
              child: LoadingSpinner(),
            );
          }
        }
      }),
    );
  }
}
