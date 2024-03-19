import 'package:flutter/material.dart';

extension StringExtension on String {
  double width(
    BuildContext context, {
    required TextStyle style,
  }) {
    final TextPainter _painter = TextPainter(
      text: TextSpan(
        style: style,
        text: this,
      ),
      textDirection: Directionality.of(context),
    );
    _painter.layout();

    return _painter.size.width;
  }
}
