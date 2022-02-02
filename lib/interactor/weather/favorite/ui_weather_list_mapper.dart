import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter_template/domain/datetime/date_in_millis_use_case.dart';
import 'package:flutter_template/domain/entity/weather/weather.dart';
import 'package:flutter_template/foundation/mapper/mapper.dart';
import 'package:flutter_template/interactor/weather/favorite/ui_day_weather_mapper.dart';
import 'package:flutter_template/presentation/entity/base/ui_list_item.dart';
import 'package:flutter_template/presentation/entity/weather/ui_day_weather_heading.dart';
import 'package:flutter_template/presentation/entity/weather/ui_weather.dart';
import 'package:flutter_template/presentation/intl/strings.dart';

abstract class UIWeatherListMapper
    extends Mapper<List<Weather>, List<UIListItem>> {}

class UIWeatherListMapperImpl extends UIWeatherListMapper {
  final DateInMillisUseCase dateInMillisUseCase;
  final UIDayWeatherMapper dayWeatherMapper;

  UIWeatherListMapperImpl(
      {required this.dayWeatherMapper, required this.dateInMillisUseCase});

  @override
  List<UIListItem> map(List<Weather> from) {
    final weatherList = from;
    return (weatherList..sort((a, b) => a.title.compareTo(b.title)))
        .map((weather) {
      final currentWeather = weather.dayWeatherList.firstWhere(
        (dayWeather) => dayWeather.isToday,
        orElse: () => weather.dayWeatherList.first,
      );

      final dayWeatherList = <UIListItem>[];

      dayWeatherList.add(
        UIDayWeatherHeading(
          text: Strings.forecast.tr(),
        ),
      );

      final sortedWeatherList = weather.dayWeatherList
        ..where((dayWeather) => !dayWeather.isToday)
        ..sort(
          (a, b) => dateInMillisUseCase(a.date)
              .compareTo(dateInMillisUseCase(b.date)),
        );

      dayWeatherList.addAll(
        sortedWeatherList.map(
          (dayWeather) => dayWeatherMapper.map(
            dayWeather,
            weather.woeid,
          ),
        ),
      );

      return UIWeather(
        cityId: weather.woeid,
        title: weather.title,
        currentTemp: "${currentWeather.temp} °C",
        minMaxTemp: "${currentWeather.minTemp} - ${currentWeather.maxTemp} °C",
        dayWeatherList: dayWeatherList,
      );
    }).toList();
  }
}
