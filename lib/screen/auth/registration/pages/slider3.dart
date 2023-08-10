import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';

class SliderThree extends StatefulWidget {
  const SliderThree({Key? key, required this.page, required this.notifier, this.imgUrl}) : super(key: key);

  final int page;
  final ValueNotifier<double> notifier;
  final String? imgUrl;

  @override
  State<SliderThree> createState() => _SliderThreeState();
}

class _SliderThreeState extends State<SliderThree> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlidingPage(
      page: widget.page,
      notifier: widget.notifier,
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            widget.imgUrl == null
                ? Align(
                    alignment: const Alignment(0.1, -0.32),
                    child: FractionallySizedBox(
                      widthFactor: 0.52,
                      heightFactor: 0.52,
                      child: SvgPicture.asset(
                        '${imageAssets}slider/bg_s1.svg',
                        height: 150,
                      ),
                    ),
                  )
                : const SizedBox(),
            Align(
              alignment: const Alignment(0.195, -1.0),
              child: FractionallySizedBox(
                widthFactor: 0.758,
                heightFactor: 0.758,
                child: FadeIn(
                  child: SlidingContainer(
                      offset: 50,
                      child: Image.asset(
                        widget.imgUrl == null ? '${imageAssets}slider/updated3.png' : widget.imgUrl ?? '',
                      )),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0.9, 0.2),
              child: FractionallySizedBox(
                child: SlidingContainer(
                  offset: 150,
                  child: SvgPicture.asset(
                    '${imageAssets}slider/magnet.svg',
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(-0.6, 0.2),
              child: Transform(
                transform: Matrix4.identity()..rotateZ(150 * 70.0),
                child: FractionallySizedBox(
                  child: SlidingContainer(
                      offset: 300,
                      child: SvgPicture.asset(
                        '${imageAssets}slider/s3_1.svg',
                        width: 10.w,
                        height: 10.w,
                        color: const Color(0xffFD445C),
                      )),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0.9, -0.7),
              child: Transform(
                transform: Matrix4.identity()..rotateZ(150 * 85.0),
                child: FractionallySizedBox(
                  child: SlidingContainer(
                      offset: -150,
                      child: SvgPicture.asset(
                        '${imageAssets}slider/s3_2.svg',
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
