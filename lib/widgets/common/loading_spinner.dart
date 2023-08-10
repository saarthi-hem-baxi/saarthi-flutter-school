import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class LoadingSpinner extends StatelessWidget {
  final Color color;
  const LoadingSpinner({
    this.color = colorPink,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return const CupertinoActivityIndicator();
    } else {
      return CircularProgressIndicator(
        color: color,
      );
    }
  }
}
