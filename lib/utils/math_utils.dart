String summarizeLongInt(num x) {
  if (x > 999 && x < 99999) {
    return "${(x / 1000).toStringAsFixed(1)}K";
  } else if (x > 99999 && x < 999999) {
    return "${(x / 1000).toStringAsFixed(0)}K";
  } else if (x > 999999 && x < 999999999) {
    return "${(x / 1000000).toStringAsFixed(1)}M";
  } else if (x > 999999999) {
    return "${(x / 1000000000).toStringAsFixed(1)}B";
  } else {
    return x.toString();
  }
}
