import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';

class BooksOldCards extends StatefulWidget {
  final String title;
  final bool learn;
  final List<Map<String, Object>> booksData;

  const BooksOldCards({
    Key? key,
    required this.learn,
    required this.title,
    required this.booksData,
  }) : super(key: key);

  @override
  _BooksOldCardsState createState() => _BooksOldCardsState();
}

class _BooksOldCardsState extends State<BooksOldCards> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = ((getScreenWidth(context) - 50) / 3);
    return Container(
      height: 180.sp,
      width:
          containerWidth, //62 is for 32 left right padding and 30 for center items padding
      margin: EdgeInsets.only(left: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10.r),
        ),
        border: Border.all(color: colorRed),
        color: colorRedLight,
      ),
      child: Column(children: [
        Container(
          height: 33.h,
          width: containerWidth,
          margin: EdgeInsets.only(top: 20.h),
          padding: const EdgeInsets.only(left: 4),
          decoration: const BoxDecoration(
            gradient: redGradient,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title,
                  style: textTitle16WhiteBoldStyle
                      .merge(const TextStyle(fontWeight: FontWeight.w700))),
              widget.learn
                  ? Container()
                  : Container(
                      alignment: AlignmentDirectional.centerEnd,
                      margin: const EdgeInsets.only(right: 10),
                      // color: Colors.amber,
                      height: 22,
                      child: Image.asset(imageAssets + 'formula.png'),
                    ),
            ],
          ),
        ),
        Expanded(
          child: widget.learn
              ? Container(
                  alignment: AlignmentDirectional.bottomCenter,
                  margin: EdgeInsets.only(bottom: 10.sp, top: 30.sp),
                  child: Image.asset(imageAssets +
                      (widget.title.toLowerCase() == "maths" ||
                              widget.title.toLowerCase() == "mathematics"
                          ? 'formula.png'
                          : widget.title.toLowerCase() == "english"
                              ? "blockabc.png"
                              : widget.title.toLowerCase() == "science"
                                  ? 'uranus.png'
                                  : 'blockabc.png')),
                )
              : Card(
                  // margin: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
                  margin: const EdgeInsets.only(top: 20, bottom: 10),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: colorDropShadow, width: 0),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: SizedBox(
                      width: containerWidth - 12,
                      // height: 99,
                      // margin: EdgeInsets.all(6),
                      child: Column(
                        children: [
                          Wrap(
                            children: widget.booksData
                                .map(
                                  (value) => Container(
                                    padding: const EdgeInsets.all(6),
                                    width: (containerWidth / 2) - 15,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          value["title"]!.toString(),
                                          style: textTitle7BoldStyle
                                              .merge(TextStyle(
                                                  color: (value["id"]! == 1
                                                      ? colorGreen
                                                      : value["id"]! == 2
                                                          ? colorSky
                                                          : value["id"]! == 3
                                                              ? colorPurple
                                                              : colorOrange))),
                                          maxLines: 1,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 16,
                                              width: 16,
                                              margin: const EdgeInsets.only(
                                                  right: 5, top: 5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                                color: (value["id"]! == 1
                                                    ? colorGreenLight
                                                    : value["id"]! == 2
                                                        ? colorBlueLight
                                                        : value["id"]! == 3
                                                            ? colorPurpleLight
                                                            : colorOrangeLight),
                                              ),
                                              child: SvgPicture.asset(
                                                imageAssets +
                                                    (value["id"]! == 1
                                                        ? 'cw.svg'
                                                        : value["id"]! == 2
                                                            ? 'precap.svg'
                                                            : value["id"]! == 3
                                                                ? 'hw.svg'
                                                                : 'brain.svg'),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            SizedBox(
                                              child: Text(
                                                value["count"]!.toString(),
                                                style: textTitle14BoldStyle
                                                    .merge(const TextStyle(
                                                        color:
                                                            sectionTitleColor)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      )),
                ),
        ),
      ]),
    );
  }
}
