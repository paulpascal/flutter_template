import 'package:flutter_template/domain/model/base/datetime/date.dart';

class DayWeather {
  final int minTemp;
  final int maxTemp;
  final int temp;
  final Date date;
  final bool isToday;

  DayWeather({
    required this.minTemp,
    required this.maxTemp,
    required this.temp,
    required this.date,
    required this.isToday,
  });
}
