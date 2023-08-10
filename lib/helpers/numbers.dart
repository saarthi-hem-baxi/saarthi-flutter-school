import 'dart:math';

import 'package:intl/intl.dart';

String displaySecFormat(num sec) {
  num secs = sec.round();
  num hours = (secs / 3600).floor();

  num divisorForMinutes = secs % 3600;
  num minutes = (divisorForMinutes / 60).floor();

  num divisorForSeconds = divisorForMinutes % 60;
  num seconds = divisorForSeconds.ceil();

  String timeString = "";
  num digit = 0;
  if (hours > 0) {
    digit = hours;
    timeString = "Hrs";
  } else if (minutes > 0) {
    digit = minutes;
    timeString = "Mins";
  } else if (seconds > 0) {
    digit = seconds;
    timeString = "Sec";
  }
  return "$digit $timeString";
}

num getValuePercentage({required num value1, required num value2}) {
  if (value1 == 0 || value2 == 0) {
    return 0;
  }
  return ((value1 / value2) * 100);
}

String converNumToString(num number) {
  var _formattedNumber = NumberFormat.compact(
    locale: 'en_IN',
  ).format(number);

  return _formattedNumber;
}

int getRandomToMaxNumber(int maxRange) {
  Random random = Random();
  return random.nextInt(maxRange);
}

String formatedDate(DateTime? date, {String formate = 'dd MMM'}) {
  if (date == null) {
    return "-";
  }
  final DateFormat formatter = DateFormat(formate);
  final String formatted = formatter.format(date);
  return formatted;
}

num convertSecToMinute(num sec) {
  if (sec == 0) {
    return 0;
  }
  return double.parse((sec / 60).toStringAsFixed(2));
}
