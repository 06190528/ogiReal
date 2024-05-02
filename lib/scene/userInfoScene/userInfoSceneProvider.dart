import 'dart:math' as math;

double adjustFontSize(
    String text, double height, double width, double minSize) {
  double textLength = text.length.toDouble();
  double fontSize = math.min(height / textLength, width / textLength) * 0.9;

  // 計算されたフォントサイズが最小サイズより小さくならないようにする
  return math.max(fontSize, minSize);
}
