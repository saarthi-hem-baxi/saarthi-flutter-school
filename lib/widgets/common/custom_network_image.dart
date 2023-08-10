import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/theme/colors.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage(
      {Key? key,
      required this.imageUrl,
      this.fit = BoxFit.cover,
      this.strokeWidth = 4,
      this.size = 30,
      this.offset = 0})
      : super(key: key);

  final String imageUrl;
  final BoxFit fit;
  final double size;
  final double offset;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Image.network(imageUrl, fit: fit, loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) return child;
      return Transform.translate(
        offset: Offset(0, offset),
        child: Center(
          child: SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              color: colorPink,
              strokeWidth: strokeWidth,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        ),
      );
    }, errorBuilder:
        (BuildContext context, Object exception, StackTrace? stackTrace) {
      return SvgPicture.asset(imageAssets + 'broken.svg');
    });
  }
}
