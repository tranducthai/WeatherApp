import 'package:flutter/cupertino.dart';

class DailyWeather with ChangeNotifier {
  final double temp;
  final double tempMin;
  final double tempMax;
  final double tempMorning;
  final double tempDay;
  final double tempEvening;
  final double tempNight;
  final String icon;
  final String conditions;
  final DateTime date;
  final String precip;
  final double uvi;
  final double cloudcover;
  final double humidity;

  DailyWeather({
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.tempMorning,
    required this.tempDay,
    required this.tempEvening,
    required this.tempNight,
    required this.icon,
    required this.conditions,
    required this.date,
    required this.precip,
    required this.uvi,
    required this.cloudcover,
    required this.humidity,
  });

  static DailyWeather fromDailyJson(dynamic json) {
    return DailyWeather(
      temp: (json['temp']).toDouble(),
      tempMin: (json['tempmin']).toDouble(),
      tempMax: (json['tempmax']).toDouble(),
      tempMorning: (json['hours'][5]['temp']).toDouble(),
      tempDay: (json['hours'][11]['temp']).toDouble(),
      tempEvening: (json['hours'][18]['temp']).toDouble(),
      tempNight: (json['hours'][23]['temp']).toDouble(),
      icon: json['icon'],
      conditions: json['conditions'],
      date: DateTime.fromMillisecondsSinceEpoch(json['datetimeEpoch'] * 1000, isUtc: true),
      precip: ((json['precip']).toDouble() * 100).toStringAsFixed(0),
      cloudcover: json['cloudcover'],
      humidity: json['humidity'],
      uvi: (json['uvindex']).toDouble(),
    );
  }
}
