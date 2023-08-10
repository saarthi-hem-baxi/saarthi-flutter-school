import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';

class TopicConceptListTile extends StatelessWidget {
  const TopicConceptListTile({
    Key? key,
    required this.type,
    required this.name,
  }) : super(key: key);

  final String type;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.h, top: 10.h),
      decoration: const BoxDecoration(color: colorgray249, borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTitle12BoldStyle.merge(const TextStyle(color: colorBodyText, fontWeight: FontWeight.w700)),
              ),
            ),
            type != "topic"
                ? Container(
                    width: 25.w,
                    height: 25.w,
                    margin: EdgeInsets.only(left: 5.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorOrangeLight,
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                    child: Text(
                      "C",
                      style: textTitle16WhiteBoldStyle.merge(const TextStyle(color: colorOrange)),
                    ),
                  )
                : SizedBox(
                    height: 25.w,
                  ),
          ],
        ),
      ),
    );
  }
}
