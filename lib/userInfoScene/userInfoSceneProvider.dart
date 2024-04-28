import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/data/post/post.dart';

double adjustFontSize(String text, double diameter, double minSize) {
  double fontSize = (diameter / text.length) * 0.85;
  if (fontSize < minSize) {
    fontSize = minSize;
  }
  return fontSize;
}
