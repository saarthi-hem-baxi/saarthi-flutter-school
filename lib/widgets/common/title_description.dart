import 'package:flutter/material.dart';

class TitleDescription extends StatefulWidget {
  final String title;
  final String desc;
  final TextStyle titleStyle;
  final TextStyle descStyle;

  const TitleDescription(
      {Key? key,
      required this.title,
      required this.desc,
      required this.titleStyle,
      required this.descStyle})
      : super(key: key);

  @override
  _TitleDescriptionState createState() => _TitleDescriptionState();
}

class _TitleDescriptionState extends State<TitleDescription> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: widget.titleStyle,
        ),
        SizedBox(
          child: Text(widget.desc, style: widget.descStyle),
        )
      ],
    );
  }
}
