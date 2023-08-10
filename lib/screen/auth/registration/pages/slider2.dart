import 'package:flutter/material.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';

class SliderTwo extends StatefulWidget {
  const SliderTwo({Key? key, required this.page, required this.notifier, this.imgUrl}) : super(key: key);

  final int page;
  final ValueNotifier<double> notifier;
  final String? imgUrl;

  @override
  State<SliderTwo> createState() => _SliderTwoState();
}

class _SliderTwoState extends State<SliderTwo> {
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
          children: [
            widget.imgUrl == null
                ? Align(
                    alignment: const Alignment(0.13, -0.31),
                    child: FractionallySizedBox(
                      widthFactor: 0.551,
                      heightFactor: 0.551,
                      child: SvgPicture.asset(
                        '${imageAssets}slider/bg_s2.svg',
                        height: 150,
                      ),
                    ),
                  )
                : const SizedBox(),
            Align(
              alignment: const Alignment(0.25, -1.1),
              child: FractionallySizedBox(
                widthFactor: 0.78,
                heightFactor: 0.78,
                child: SlidingContainer(
                    offset: 50,
                    child: Image.asset(
                      widget.imgUrl == null ? '${imageAssets}slider/updated2.png' : widget.imgUrl ?? '',
                    )),
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
                        '${imageAssets}slider/s2_3.svg',
                      )),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0.8, 0.25),
              child: Transform(
                transform: Matrix4.identity()..rotateZ(150 * 40.0),
                child: FractionallySizedBox(
                  child: SlidingContainer(
                      offset: 300,
                      child: SvgPicture.asset(
                        '${imageAssets}slider/s2_2.svg',
                        width: 30,
                        height: 30,
                      )),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(-0.65, -0.5),
              child: FractionallySizedBox(
                child: SlidingContainer(
                  offset: -150,
                  child: SvgPicture.asset(
                    '${imageAssets}slider/s2_1.svg',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
