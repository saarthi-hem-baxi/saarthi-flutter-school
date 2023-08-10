import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/chapters_model/completion.dart';
import 'package:saarthi_pedagogy_studentapp/model/chapters_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/model/subject_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/screen/roadmap/roadmap.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/measured_size.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';

class ChaptersDataItem extends StatefulWidget {
  final ChaptersDatum data;
  final int index;
  final Datum subjectData;
  final VoidCallback onResume;
  final VoidCallback thenPress;

  const ChaptersDataItem({
    Key? key,
    required this.data,
    required this.index,
    required this.subjectData,
    required this.onResume,
    required this.thenPress,
  }) : super(key: key);

  @override
  State<ChaptersDataItem> createState() => _ChaptersDataItemState();
}

class _ChaptersDataItemState extends State<ChaptersDataItem> {
  Size containerSize = const Size(0, 0);

  Widget getRightIconWidget(Completion? completion) {
    if (completion == null) {
      return const SizedBox();
    } else if (completion.completion == null || completion.completion == 0) {
      return const SizedBox();
    } else if (completion.completion == 100) {
      return Container(
        height: 24.h,
        width: 24.h,
        margin: const EdgeInsets.only(right: 5),
        alignment: AlignmentDirectional.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: purpleGradient,
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.done_outlined,
          ),
          iconSize: 18.h,
          color: Colors.white,
          onPressed: () {},
        ),
      );
    } else if ((completion.completion ?? 0) > 0) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.w),
        margin: EdgeInsets.only(right: 5.w),
        alignment: AlignmentDirectional.center,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
          color: colorOrange,
        ),
        child: Text(
          '${(widget.data.completion?.completion ?? 0).round()}%',
          style: textTitle16WhiteBoldStyle.merge(
            const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoadmapPage(
              subjectData: widget.subjectData,
              chaptersData: widget.data,
            ),
          ),
        ).then((value) => {widget.onResume(), widget.thenPress()})
      },
      child: Container(
        margin: EdgeInsets.only(top: 10.h),
        decoration: boxDecoration10,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              child: widget.data.completion != null
                  ? (widget.data.completion?.completion ?? 0) < 100
                      ? Container(
                          height: containerSize.height,
                          width: ((widget.data.completion?.completion ?? 0) * (getScreenWidth(context) - 32)) / 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.w),
                              bottomLeft: Radius.circular(10.w),
                            ),
                            color: const Color.fromRGBO(255, 196, 128, 100),
                          ),
                        )
                      : null
                  : null,
            ),
            MeasureSize(
              onChange: (v) {
                setState(() {
                  containerSize = v;
                });
              },
              child: Container(
                constraints: BoxConstraints(minHeight: 46.h),
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 26.h,
                      width: 26.h,
                      alignment: AlignmentDirectional.center,
                      margin: EdgeInsets.only(right: 20.w),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(248, 248, 248, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(13.h),
                        ),
                      ),
                      child: Text(
                        '${widget.index + 1}',
                        style: textTitle16WhiteBoldStyle.merge(
                          const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.data.name ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTitle16WhiteBoldStyle.merge(
                          const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    getRightIconWidget(widget.data.completion),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
