import 'package:flutter/material.dart';

class TextStyling extends StatelessWidget {
  final String text;
  final List<String> highlightText;
  final bool caseSensitive;
  final TextStyle? textStyle;
  final TextStyle? highlightTextStyle;
  final List<TextStyle> multiTextStyles;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final bool softWrap;
  final TextDirection? textDirection;
  final Locale? locale;
  final double textScaleFactor;
  final int? maxLines;
  final TextWidthBasis textWidthBasis;
  final StrutStyle? strutStyle;

  TextStyling({
    Key? key,
    required this.text,
    required List<String> highlightText,
    this.caseSensitive = true,
    this.textStyle,
    this.highlightTextStyle,
    this.multiTextStyles = const [],
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.clip,
    this.softWrap = true,
    this.textDirection,
    this.locale,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.textWidthBasis = TextWidthBasis.parent,
    this.strutStyle,
  })  : assert(highlightText.isNotEmpty),
        assert(maxLines == null || maxLines > 0),
        assert(
          highlightTextStyle == null || multiTextStyles.isEmpty,
          'Cannot provide both highlightTextStyle and multiTextStyles',
        ),
        highlightText = highlightText.map((e) => caseSensitive ? e : e.toLowerCase()).toList(),
        super(key: key) {
    if (multiTextStyles.isNotEmpty) {
      assert(multiTextStyles.length == highlightText.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(textDirection != null || debugCheckHasDirectionality(context));

    // Define used TextStyle for non-highlighted text.
    final defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle? effectiveTextStyle = textStyle;
    if (textStyle == null || textStyle!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(textStyle);
    }

    // Define used TextStyle for highlighted text.
    final _highlightTextStyles =
        highlightTextStyle != null ? List<TextStyle>.generate(highlightText.length, (_) => highlightTextStyle!) : multiTextStyles;

    final pattern = RegExp(highlightText.join("|"), caseSensitive: caseSensitive);

    final _texts = <TextSpan>[];
    var i = 0, j = 0;
    while ((j = text.indexOf(pattern, i)) != -1) {
      if (j > i) _texts.add(TextSpan(text: text.substring(i, j)));
      final currentText = text.substring(j);
      late final String what;
      for (final e in highlightText) {
        if (currentText.startsWith(RegExp(e, caseSensitive: caseSensitive))) {
          what = e;
          break;
        }
      }
      _texts.add(
        TextSpan(
          text: text.substring(j, j + what.length),
          style: _highlightTextStyles[highlightText.indexOf(what)],
        ),
      );
      i = j + what.length;
    }
    if (i < text.length) _texts.add(TextSpan(text: text.substring(i)));

    return RichText(
      strutStyle: strutStyle,
      textAlign: textAlign,
      overflow: overflow,
      softWrap: softWrap,
      textDirection: textDirection ?? Directionality.of(context),
      locale: locale ?? Localizations.localeOf(context),
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      textWidthBasis: textWidthBasis,
      text: TextSpan(children: _texts, style: effectiveTextStyle),
    );
  }
}
