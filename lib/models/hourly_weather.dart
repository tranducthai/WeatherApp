class HourlyWeather {
  final double temp;
  final String icon;
  final String? condition;
  final DateTime date;

  HourlyWeather({
    required this.temp,
    required this.icon,
    this.condition,
    required this.date,
  });

  static HourlyWeather fromJson(dynamic json) {
    return HourlyWeather(
      temp: (json['temp']).toDouble(),
      icon: json['icon'],
      condition: json['conditions'],
      date: DateTime.fromMillisecondsSinceEpoch(json['datetimeEpoch'] * 1000),
    );
  }
}
