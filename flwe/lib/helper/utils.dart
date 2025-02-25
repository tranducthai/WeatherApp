import 'package:latlong2/latlong.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/standalone.dart' as tz;
import '../models/weather.dart';
import '../provider/weather_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String uviValueToString(double uvi) {
  if (uvi <= 2) {
    return 'Low';
  } else if (uvi <= 5) {
    return 'Medium';
  } else if (uvi <= 7) {
    return 'High';
  } else if (uvi <= 10) {
    return 'Very High';
  } else if (uvi >= 11) {
    return 'Extreme';
  }
  return 'Unknown';
}

String getWeatherImage(String input) {
  String weather = input.toLowerCase();
  String assetPath = 'assets/images/';
  print('assets/images/$weather.png');
  return 'assets/images/$weather.png';
  }

DateTime getCurrentTimeInZone(String timeZone) {
  tz.initializeTimeZones(); // Khởi tạo dữ liệu múi giờ
  final location = tz.getLocation(timeZone); // Lấy location theo múi giờ
  return tz.TZDateTime.now(location); // Trả về giờ hiện tại
}
bool isFirstCharLetter(String str) {
  if (str.isEmpty) return false;
  int code = str.codeUnitAt(0);
  return (code >= 65 && code <= 90) || (code >= 97 && code <= 122); // A-Z hoặc a-z
}