import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/auth/circular_icon.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({
    Key? key,
    required this.title,
    required this.controller,
    required this.iconGradient,
    required this.focusNode,
    this.nextFocusNode,
  }) : super(key: key);

  final String title;
  final TextEditingController controller;
  final LinearGradient iconGradient;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.sp,
      margin: EdgeInsets.only(top: 15.sp),
      child: Row(
        children: [
          CircularIcon(
            icon: Icons.email_outlined,
            bgGradient: iconGradient,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textFormTitleStyle),
                  Expanded(
                    child: TextFormField(
                      style: textFormTitleStyle.merge(
                        const TextStyle(color: colorWebPanelDarkText),
                      ),
                      maxLines: 1,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.sp),
                          borderSide: const BorderSide(),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 0),
                      ),
                      focusNode: focusNode,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(
                          nextFocusNode ?? FocusNode(),
                        );
                      },
                      keyboardType: TextInputType.emailAddress,
                      controller: controller,
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
