import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';

class WeeklyProgressCard extends StatefulWidget {
  final int id;
  final String title;
  final String subtitle;
  final int progress;

  const WeeklyProgressCard(
      {Key? key,
      required this.id,
      required this.title,
      required this.subtitle,
      required this.progress})
      : super(key: key);

  @override
  _WeeklyProgressCardState createState() => _WeeklyProgressCardState();
}

class _WeeklyProgressCardState extends State<WeeklyProgressCard> {
  Widget? indicatorChild;

  @override
  void initState() {
    super.initState();

    if (widget.id > 1) {
      setState(() {
        indicatorChild = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              widget.progress.toString(),
              style: textTitle16WhiteBoldStyle.merge(
                const TextStyle(color: colorWebPanelDarkText),
              ),
            ),
            AutoSizeText(
              "%",
              style: textTitle8BoldStyle.merge(
                const TextStyle(
                    color: colorWebPanelDarkText, fontWeight: FontWeight.w700),
              ),
            )
          ],
        );
      });
    } else {
      setState(() {
        indicatorChild = IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.play_arrow,
          ),
          iconSize: 30,
          color: colorPurple,
          onPressed: () {},
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = ((getScreenWidth(context) - 32) / 2);
    return Card(
      // margin: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
      margin: const EdgeInsets.only(left: 10, bottom: 10),

      shape: RoundedRectangleBorder(
        side: const BorderSide(color: colorDropShadow, width: 1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: (containerWidth - 5),
        // height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: (containerWidth * 0.60) - 8,
              // color: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    widget.title,
                    style: textTitle18WhiteBoldStyle
                        .merge(const TextStyle(color: colorText)),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 18,
                        width: 18,
                        margin: const EdgeInsets.only(right: 5),
                        alignment: AlignmentDirectional.center,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(9),
                          ),
                          gradient: (widget.id == 1
                              ? purpleGradient
                              : widget.id == 2
                                  ? orangeGradient
                                  : widget.id == 3
                                      ? greenGradient
                                      : pinkGradient),
                        ),
                        child: SvgPicture.asset(
                          imageAssets + 'donebutton.svg',
                          // allowDrawingOutsideViewBox: true,
                          height: 14,
                          width: 14,
                        ),

                        // IconButton(
                        //   padding: EdgeInsets.zero,
                        //   icon: const Icon(
                        //     Icons.done_outlined,
                        //   ),
                        //   iconSize: 14,
                        //   color: Colors.white,
                        //   onPressed: () {},
                        // ),
                      ),
                      Flexible(
                        child: AutoSizeText(
                          widget.subtitle.toString(),
                          style: textTitle14BoldStyle.merge(
                            const TextStyle(color: colorText),
                          ),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: containerWidth / 4,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  SizedBox(
                    // width: (ContainerWidth / 6),
                    // height: (ContainerWidth / 6),
                    child: CircularProgressIndicator(
                      value: widget.progress.toDouble() / 100,
                      backgroundColor: (widget.id == 1
                          ? Colors.white
                          : widget.id == 2
                              ? colorOrangeLight
                              : widget.id == 3
                                  ? colorGreenLight
                                  : colorPinkLight),
                      color: (widget.id == 1
                          ? colorPurple
                          : widget.id == 2
                              ? colorOrange
                              : widget.id == 3
                                  ? colorGreen
                                  : colorPink),
                      strokeWidth: 5,
                    ),
                  ),
                  indicatorChild ?? Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
