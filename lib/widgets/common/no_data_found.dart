import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';

class NoDataCard extends StatelessWidget {
  const NoDataCard({
    Key? key,
    required this.title,
    required this.description,
    this.headerEnabled = false,
    this.isColoredImage = false,
    this.backgroundColor,
  }) : super(key: key);

  final String title;
  final String description;
  final bool headerEnabled;
  final bool isColoredImage;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.transparent,
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 16, top: 16),
              width: double.infinity,
              child: headerEnabled
                  ? Row(
                      children: [
                        GestureDetector(
                          onTap: () => {Navigator.pop(context)},
                          child: Container(
                            height: 32,
                            width: 32,
                            margin: const EdgeInsets.only(right: 20),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back_outlined,
                              size: 18,
                              color: sectionTitleColor,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container()),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: getScreenWidth(context),
                    height: getScrenHeight(context) / 2.5,
                    margin: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
                    child: isColoredImage == true
                        ? SvgPicture.asset(
                            imageAssets + 'no_data.svg',
                            allowDrawingOutsideViewBox: true,
                            colorBlendMode: BlendMode.luminosity,
                            // fit: BoxFit.f,
                          )
                        : SvgPicture.asset(
                            imageAssets + 'noquestion.svg',
                            allowDrawingOutsideViewBox: true,
                            colorBlendMode: BlendMode.luminosity,
                            // fit: BoxFit.f,
                          ),
                  ),
                  Container(
                    alignment: AlignmentDirectional.center,
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: textTitle20WhiteBoldStyle.merge(const TextStyle(color: sectionTitleColor)),
                    ),
                  ),
                  Container(
                    alignment: AlignmentDirectional.center,
                    margin: const EdgeInsets.only(top: 15),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: textTitle14BoldStyle.merge(const TextStyle(color: colorBodyText)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
