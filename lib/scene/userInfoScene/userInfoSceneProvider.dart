double adjustFontSize(String text, double diameter, double minSize) {
  double fontSize = (diameter / text.length) * 0.85;
  if (fontSize < minSize) {
    fontSize = minSize;
  }
  return fontSize;
}
