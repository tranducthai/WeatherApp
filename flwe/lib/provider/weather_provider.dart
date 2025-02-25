import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../models/geocode.dart';
import '../models/daily_weather.dart';
import '../models/hourly_weather.dart';
import '../models/weather.dart';
import '../helper/utils.dart';

class WeatherProvider with ChangeNotifier {
  String apiKey = 'e7704bc895b4a8d2dfd4a29d404285b6';
  Weather weather = Weather.empty();
  //late AdditionalWeatherData additionalWeatherData;
  LatLng? currentLocation;
  List<HourlyWeather> hourlyWeather = [];
  List<DailyWeather> dailyWeather = [];
  bool isLoading = false;
  bool isRequestError = false;
  bool isSearchError = false;
  bool isLocationserviceEnabled = false;
  LocationPermission? locationPermission;
  bool isCelsius = true;

  String get measurementUnit => isCelsius ? '°C' : '°F';

  Future<Position?> requestLocation(BuildContext context) async {
    isLocationserviceEnabled = await Geolocator.isLocationServiceEnabled();
    notifyListeners();

    if (!isLocationserviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location service disabled')),
      );
      return Future.error('Location services are disabled.');
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      isLoading = false;
      notifyListeners();
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Permission denied'),
        ));
        return Future.error('Location permissions are denied');
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Location permissions are permanently denied, Please enable manually from app settings',
        ),
      ));
      return Future.error('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> getWeatherData(
    BuildContext context, {
    bool notify = false,
  }) async {
    isLoading = true;
    isRequestError = false;
    isSearchError = false;
    if (notify) notifyListeners();

    Position? locData = await requestLocation(context);

    if (locData == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      currentLocation = LatLng(locData.latitude, locData.longitude);
      await getCurrentWeather(currentLocation!);
      await getDailyWeather(currentLocation!);
    } catch (e) {
      print(e);
      isRequestError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCurrentWeather(LatLng location) async {
  Uri url = Uri.parse(
    'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/${location.latitude},${location.longitude}?unitGroup=us&key=S2W4E5XW8LN735LMKLYDJRFHN&contentType=json',
  );

  try {
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch weather data: ${response.statusCode}');
    }

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    weather = Weather.fromJson(extractedData);
    if(!isFirstCharLetter(weather.city)){
Uri url = Uri.parse(
    'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&exclude=hourly,daily&appid=e7704bc895b4a8d2dfd4a29d404285b6'  );
try {
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch weather data: ${response.statusCode}');
    }
    final placeData = json.decode(res.body) as Map<String, dynamic>;
    weather.city=placeData['name'];
    weather.country=placeData['sys']['country'];
  } catch (error) {
    print('❌ Error fetching place');
  }
}

    print('✅ Fetched Weather for: ${weather.city}');
  } catch (error) {
    print('❌ Error fetching weather: $error');
    isLoading = false;
    isRequestError = true;
  }
}

 Future<void> getDailyWeather(LatLng location) async {
  isLoading = true;
  notifyListeners();

  Uri dailyUrl = Uri.parse(
    //'https://api.openweathermap.org/data/2.5/onecall?lat=${location.latitude}&lon=${location.longitude}&units=metric&exclude=minutely,current&appid=$apiKey',
    'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/${location.latitude},${location.longitude}?unitGroup=us&key=S2W4E5XW8LN735LMKLYDJRFHN&contentType=json',
  );
  
  try {
    final response = await http.get(dailyUrl);
    print('🔹 Requesting: $dailyUrl');
    print('🔹 Status Code: ${response.statusCode}');
    print('🔹 Response Body: ${response.body}');
    

    final dailyData = json.decode(response.body) as Map<String, dynamic>;

    if (dailyData == null || dailyData.isEmpty) {
      throw Exception('Received empty daily weather data');
    }
    List? dailyList = dailyData['days'];
    List? hourlyList = dailyData['days'][0]['hours'];

    if (dailyList == null || hourlyList == null) {
      throw Exception('Missing daily or hourly weather data');
    }

    hourlyWeather = hourlyList
        .map((item) => HourlyWeather.fromJson(item))
        .toList()
        .take(24)
        .toList();
    
    dailyWeather =
        dailyList.map((item) => DailyWeather.fromDailyJson(item)).toList();
        print('sucess');
    print(dailyWeather[0]);
    print(hourlyWeather[0]);
  } catch (error) {
    print('❌ Error fetching daily weather: $error');
    isLoading = false;
    isRequestError = true;
  }
}


  Future<GeocodeData?> locationToLatLng(String location) async {
    try {
      Uri url = Uri.parse(
        'https://api.openweathermap.org/geo/1.0/direct?q=$location&limit=5&appid=e7704bc895b4a8d2dfd4a29d404285b6',
      );
      final http.Response response = await http.get(url);
        print('🔹 Requesting: $url');
        print('🔹 Status Code: ${response.statusCode}');
        print('🔹 Response Body: ${response.body}');
      if (response.statusCode != 200) {print('error');
        return null;}
      return GeocodeData.fromJson(
        jsonDecode(response.body) as List<dynamic>,
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> searchWeather(String location) async {
    isLoading = true;
    notifyListeners();
    isRequestError = false;
    print('search');
    try {
      GeocodeData? geocodeData;
      geocodeData = await locationToLatLng(location);
      if (geocodeData == null) throw Exception('Unable to Find Location');
      await getCurrentWeather(geocodeData.latLng);
      await getDailyWeather(geocodeData.latLng);
      // replace location name with data from geocode
      // because data from certain lat long might return local area name
      weather.city = geocodeData.name;
      weather.country=geocodeData.country;
    } catch (e) {
      print(e);
      isSearchError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void switchTempUnit() {
    isCelsius = !isCelsius;
    notifyListeners();
  }
}
