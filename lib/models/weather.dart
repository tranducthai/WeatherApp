import 'package:flutter/cupertino.dart';

class Weather  {
  final double temp;
  final double tempMax;
  final double tempMin;
  final double lat;
  final double long;
  final double feelsLike;
  final double pressure;
  final String description;
  final String conditions;
  final double humidity;
  final double windSpeed;
  String city;
  String country;
  final double cloudcover;
  final double visibility;
  final double precip;
  final double uvindex;
  final String icon;
  final String timezone;

  Weather({
    required this.temp,
    required this.tempMax,
    required this.tempMin,
    required this.lat,
    required this.long,
    required this.feelsLike,
    required this.pressure,
    required this.description,
    required this.conditions,
    required this.humidity,
    required this.windSpeed,
    required this.city,
    required this.country,
    required this.cloudcover,
    required this.visibility,
    required this.precip,
    required this.uvindex,
    required this.icon,
    required this.timezone,
  });

  /// Constructor rỗng để tạo đối tượng Weather mặc định
  factory Weather.empty() {
    return Weather(
      temp: 0.0,
      tempMax: 0.0,
      tempMin: 0.0,
      lat: 0.0,
      long: 0.0,
      feelsLike: 0.0,
      pressure: 0.0,
      description: '',
      conditions: '',
      humidity: 0.0,
      windSpeed: 0.0,
      city: 'Unknown',
      country: 'Unknown',
      cloudcover: 0.0,
      visibility: 0.0,
      precip: 0.0,
      uvindex: 0.0,
      icon: '',
      timezone: '',
    );
  }

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temp: (json['days'][0]['temp']).toDouble(),
      tempMax: (json['days'][0]['tempmax']).toDouble(),
      tempMin: (json['days'][0]['tempmin']).toDouble(),
      lat: json['latitude'],
      long: json['longitude'],
      feelsLike: (json['days'][0]['feelslike']).toDouble(),
      pressure: json['days'][0]['pressure'],
      conditions: json['days'][0]['conditions'],
      description: json['days'][0]['description'],
      humidity: json['days'][0]['humidity'],
      windSpeed: (json['days'][0]['windspeed']).toDouble(),
      cloudcover: (json['days'][0]['cloudcover']).toDouble(),
      city: json['address'] ,
      country: json['resolvedAddress'],
      visibility: json['days'][0]['visibility'].toDouble(),
      precip: json['days'][0]['precip'],
      uvindex: json['days'][0]['uvindex'].toDouble(),
      icon: json['days'][0]['icon'],
      timezone: json['timezone'],
    );
  }
}
