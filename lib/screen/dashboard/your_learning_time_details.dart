import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/numbers.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/common/header.dart';

class YourLearningTimeDetailPage extends StatelessWidget {
  YourLearningTimeDetailPage({Key? key}) : super(key: key);
  final List d = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScreenBg1Purple,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderCard(
              backEnabled: true,
              onTap: () {
                Navigator.pop(context);
              },
              title: "Your Learning Time",
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "Subjects",
                        style: textTitle16WhiteBoldStyle.merge(
                          const TextStyle(color: colorHeaderTextColor),
                        ),
                      ),
                      Text(
                        "(Time in minutes)",
                        style: textTitle12StylePoppins.merge(
                          const TextStyle(color: colorGrey400),
                        ),
                      ),
                      ...d.map((e) {
                        int index = d.indexOf(e);
                        return _YourLearningTimeCard(
                          index: index + 1,
                          chapterName: "Gujarati",
                          yourTime: getRandomToMaxNumber(95),
                          classAvgTime: getRandomToMaxNumber(95),
                          classTopperTime: getRandomToMaxNumber(95),
                          saarthiAvgTime: getRandomToMaxNumber(95),
                          saarthiTopperTime: getRandomToMaxNumber(95),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _YourLearningTimeCard extends StatelessWidget {
  const _YourLearningTimeCard({
    Key? key,
    required this.index,
    required this.chapterName,
    required this.yourTime,
    required this.classAvgTime,
    required this.classTopperTime,
    required this.saarthiAvgTime,
    required this.saarthiTopperTime,
  }) : super(key: key);

  final int index;
  final String chapterName;
  final num yourTime;
  final num classAvgTime;
  final num classTopperTime;
  final num saarthiAvgTime;
  final num saarthiTopperTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              children: [
                Text(
                  "$index.",
                  style: textTitle14StylePoppins.merge(
                    const TextStyle(
                      color: colorGrey600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  chapterName,
                  style: textTitle14StylePoppins.merge(
                    const TextStyle(
                      color: colorGrey600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 0,
          ),
          Column(
            children: [
              Container(
                height: 25.h,
                margin: EdgeInsets.only(bottom: 1.h),
                color: colorSky50,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Your",
                        style: textTitle14StylePoppins.merge(
                          const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: colorSky800,
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Text(
                            "Time",
                            style: textTitle12StylePoppins.merge(
                              const TextStyle(color: colorYellow600),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            yourTime.toString(),
                            style: textTitle16StylePoppins.merge(
                              const TextStyle(color: colorGrey600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(
                      color: colorSky50,
                    ),
                    const Expanded(
                      flex: 4,
                      child: SizedBox(),
                    )
                  ],
                ),
              ),
              Container(
                height: 25.h,
                margin: EdgeInsets.symmetric(vertical: 1.h),
                color: colorYellow50,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Class",
                        style: textTitle14StylePoppins.merge(
                          const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: colorYellow600,
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Text(
                            "Avg time",
                            style: textTitle12StylePoppins.merge(
                              const TextStyle(color: colorYellow600),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            classAvgTime.toString(),
                            style: textTitle16StylePoppins.merge(
                              const TextStyle(color: colorGrey600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(),
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Text(
                            "Topper time",
                            style: textTitle12StylePoppins.merge(
                              const TextStyle(color: colorYellow600),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            classTopperTime.toString(),
                            style: textTitle16StylePoppins.merge(
                              const TextStyle(color: colorGrey600),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 25.h,
                margin: EdgeInsets.only(top: 1.h),
                decoration: BoxDecoration(
                  color: colorGreen50,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.w), bottomRight: Radius.circular(12.w)),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Saarthi",
                        style: textTitle14StylePoppins.merge(
                          const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: colorGreen600,
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Text(
                            "Avg time",
                            style: textTitle12StylePoppins.merge(
                              const TextStyle(color: colorGreen600),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            saarthiAvgTime.toString(),
                            style: textTitle16StylePoppins.merge(
                              const TextStyle(color: colorGrey600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(),
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Text(
                            "Topper time",
                            style: textTitle12StylePoppins.merge(
                              const TextStyle(color: colorGreen600),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            saarthiTopperTime.toString(),
                            style: textTitle16StylePoppins.merge(
                              const TextStyle(color: colorGrey600),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
