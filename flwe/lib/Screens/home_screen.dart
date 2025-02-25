import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import 'request_error.dart';
import 'custom_search_bar.dart';
import 'location_error_display.dart';
import '../provider/weather_provider.dart';
import '../theme/colors.dart';
import '../theme/text_style.dart';
import '../widgets/weather_info_header.dart';
import '../widgets/main_weather_detail.dart';
import '../widgets/main_weather_info.dart';
import '../widgets/sevenday_forecast.dart';
import '../widgets/twentyfourhour_forecast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FloatingSearchBarController fsc = FloatingSearchBarController();

  @override
  void initState() {
    super.initState();
    requestWeather();
  }

Future<void> requestWeather() async {
  var weatherProvider = Provider.of<WeatherProvider>(context, listen: false);

  Position? position;
  try {
    position = await weatherProvider.requestLocation(context);
  } catch (e) {
    print('❌ Không thể lấy vị trí: $e');
  }

  if (position != null) {
    await weatherProvider.getWeatherData(context);
  } else {
    print('📍 GPS không khả dụng, tìm kiếm thời tiết Hà Nội');

    // 🔹 Đặt isLoading = true để tránh UI hiển thị lỗi
    weatherProvider.isLoading = true;
    weatherProvider.notifyListeners();

    // 🔹 Thực hiện tìm kiếm thời tiết mặc định (Hanoi)
    await weatherProvider.searchWeather('Hanoi');

    // 🔹 Cập nhật trạng thái sau khi đã có dữ liệu
    weatherProvider.isLocationserviceEnabled = true;
    weatherProvider.locationPermission = LocationPermission.always;
    weatherProvider.isLoading = false; // Dữ liệu đã tải xong
    weatherProvider.notifyListeners();
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProv, _) {
          if (!weatherProv.isLoading && !weatherProv.isLocationserviceEnabled)
            return LocationServiceErrorDisplay();

          if (!weatherProv.isLoading &&
              weatherProv.locationPermission != LocationPermission.always &&
              weatherProv.locationPermission != LocationPermission.whileInUse) {
            return LocationPermissionErrorDisplay();
          }

          if (weatherProv.isRequestError) return RequestErrorDisplay();

          if (weatherProv.isSearchError) return SearchErrorDisplay(fsc: fsc);

          return Stack(
            children: [
              ListView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.all(12.0).copyWith(
                  top: kToolbarHeight +
                      MediaQuery.viewPaddingOf(context).top +
                      24.0,
                ),
                children: [
                  WeatherInfoHeader(),
                  const SizedBox(height: 16.0),
                  MainWeatherInfo(),
                  const SizedBox(height: 16.0),
                  MainWeatherDetail(),
                  const SizedBox(height: 24.0),
                  TwentyFourHourForecast(),
                  const SizedBox(height: 18.0),
                  SevenDayForecast(),
                ],
              ),
              CustomSearchBar(fsc: fsc),
            ],
          );
        },
      ),
    );
  }
}

