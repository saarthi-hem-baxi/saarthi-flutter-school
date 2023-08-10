import 'package:flutter/material.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';

class SliderOne extends StatefulWidget {
  const SliderOne({
    Key? key,
    required this.page,
    required this.notifier,
    this.imgUrl,
  }) : super(key: key);
  final int page;
  final ValueNotifier<double> notifier;
  final String? imgUrl;

  @override
  State<SliderOne> createState() => _SliderOneState();
}

class _SliderOneState extends State<SliderOne> {
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
                    alignment: const Alignment(0.01, -0.41),
                    child: FractionallySizedBox(
                      widthFactor: 0.57,
                      heightFactor: 0.57,
                      child: SvgPicture.asset(
                        '${imageAssets}slider/bg_s1.svg',
                        height: 150,
                      ),
                    ),
                  )
                : const SizedBox(),
            Align(
              alignment: const Alignment(0.35, -1.12),
              child: FractionallySizedBox(
                widthFactor: 0.78,
                heightFactor: 0.82,
                child: SlidingContainer(
                  offset: 20,
                  child: Image.asset(
                    widget.imgUrl == null ? '${imageAssets}slider/updated1.png' : widget.imgUrl ?? '',
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(-0.65, 0.2),
              child: FractionallySizedBox(
                child: SlidingContainer(
                  offset: 150,
                  child: SvgPicture.asset(
                    '${imageAssets}slider/book.svg',
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
            ),
            // Align(
            //   alignment: const Alignment(1, 0.15),
            //   child: Transform(
            //     transform: Matrix4.identity()..rotateZ(150 * 45.0),
            //     child: FractionallySizedBox(
            //       child: SlidingContainer(
            //           offset: 300,
            //           child: SvgPicture.asset(
            //             '${imageAssets}slider/s1_2.svg',
            //           )),
            //     ),
            //   ),
            // ),
            Align(
              alignment: const Alignment(-0.65, -0.7),
              child: Transform(
                transform: Matrix4.identity()
                  ..rotateX(135)
                  ..rotateZ(40),
                child: FractionallySizedBox(
                  child: SlidingContainer(
                      offset: -150,
                      child: SvgPicture.asset(
                        '${imageAssets}slider/s1_2.svg',
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
