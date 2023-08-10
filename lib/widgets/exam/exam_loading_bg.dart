import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../helpers/const.dart';
import '../common/loading_spinner.dart';

class ExamLoadingBG extends StatelessWidget {
  const ExamLoadingBG({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SvgPicture.asset(
              imageAssets + 'exam_new.svg',
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            left: -100,
            child: Transform.rotate(
              angle: 0,
              child: Container(
                height: 250,
                width: 250,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Color.fromRGBO(97, 0, 224, 0.2), Color.fromRGBO(97, 0, 224, 0)],
                    tileMode: TileMode.mirror,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(125),
                    bottomRight: Radius.circular(125),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: -150,
            bottom: 20,
            child: Transform.rotate(
              angle: 0,
              child: Container(
                height: 250,
                width: 250,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Color.fromRGBO(247, 110, 178, 0.2),
                      Color.fromRGBO(247, 110, 178, 0),
                    ],
                    tileMode: TileMode.mirror,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(125),
                    bottomLeft: Radius.circular(125),
                  ),
                ),
              ),
            ),
          ),
          const Center(
            child: LoadingSpinner(),
          )
        ],
      ),
    );
  }
}
