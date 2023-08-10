import 'package:flutter/material.dart';

import '../../theme/style.dart';

class NoDataFoundText extends StatelessWidget {
  final String title;

  const NoDataFoundText({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: textError16WhiteBoldStyle,
    );
  }
}
