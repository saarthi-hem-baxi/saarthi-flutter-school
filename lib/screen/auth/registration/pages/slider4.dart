import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';

class SliderFour extends StatefulWidget {
  const SliderFour({Key? key, required this.page, required this.notifier, this.imgUrl}) : super(key: key);

  final int page;
  final ValueNotifier<double> notifier;
  final String? imgUrl;

  @override
  State<SliderFour> createState() => _SliderFourState();
}

class _SliderFourState extends State<SliderFour> {
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
                      widthFactor: 0.519,
                      heightFactor: 0.519,
                      child: SvgPicture.asset(
                        '${imageAssets}slider/bg_s1.svg',
                        height: 150,
                      ),
                    ),
                  )
                : const SizedBox(),
            Align(
              alignment: const Alignment(0.34, -0.95),
              child: FractionallySizedBox(
                widthFactor: 0.75,
                heightFactor: 0.75,
                child: FadeIn(
                  child: SlidingContainer(
                      offset: 50,
                      child: Image.asset(
                        widget.imgUrl == null ? '${imageAssets}slider/updated4.png' : widget.imgUrl ?? '',
                      )),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(-0.65, 0.2),
              child: FractionallySizedBox(
                child: SlidingContainer(
                  offset: 150,
                  child: SvgPicture.asset(
                    '${imageAssets}slider/s4_1.svg',
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0.8, -0.5),
              child: Transform(
                transform: Matrix4.identity()..rotateZ(150 * 85.0),
                child: FractionallySizedBox(
                  child: SlidingContainer(
                      offset: -150,
                      child: SvgPicture.asset(
                        '${imageAssets}slider/s4_2.svg',
                      )),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(-0.5, -0.7),
              child: Transform(
                transform: Matrix4.identity()..rotateZ(150 * 85.0),
                child: FractionallySizedBox(
                  child: SlidingContainer(
                      offset: -150,
                      child: SvgPicture.asset(
                        '${imageAssets}slider/s4_4.svg',
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
