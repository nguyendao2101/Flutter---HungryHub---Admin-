// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class TruncatedText extends StatelessWidget {
  final String text;
  final double maxWidth;
  final TextStyle? style;

  const TruncatedText({
    Key? key,
    required this.text,
    required this.maxWidth,
    this.style,
  }) : super(key: key);

  String _getTruncatedText(String text, double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: double.infinity);

    if (textPainter.size.width > maxWidth) {
      String truncatedText = text;
      while (truncatedText.isNotEmpty) {
        truncatedText = truncatedText.substring(0, truncatedText.length - 1);
        textPainter.text = TextSpan(
          text: "$truncatedText...",
          style: style,
        );
        textPainter.layout(maxWidth: double.infinity);
        if (textPainter.size.width <= maxWidth) {
          break;
        }
      }
      return "$truncatedText...";
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _getTruncatedText(text, maxWidth),
      style: style,
      overflow: TextOverflow.ellipsis,
    );
  }
}
