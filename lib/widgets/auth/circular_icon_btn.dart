// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class CircularIconButton extends StatelessWidget {
  CircularIconButton({
    Key? key,
    required this.onTap,
    required this.bgGradient,
    required this.icon,
    required this.buttonSize,
    this.iconColor = Colors.white,
    required this.iconSize,
  }) : super(key: key);

  final VoidCallback onTap;
  // ignore: prefer_typing_uninitialized_variables
  final buttonSize;
  final IconData icon;
  // ignore: prefer_typing_uninitialized_variables
  final iconSize;
  final Color iconColor;
  LinearGradient bgGradient = tealGradient;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: buttonSize,
        width: buttonSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: bgGradient,
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
      ),
    );
  }
}
