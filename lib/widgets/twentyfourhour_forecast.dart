import 'package:flutter/material.dart';
import '../helper/extensions.dart';
import '../models/hourly_weather.dart';
import '../provider/weather_provider.dart';
import '../theme/colors.dart';
import '../theme/text_style.dart';
import '../widgets/custom_shimmer.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import '../helper/utils.dart';

class TwentyFourHourForecast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundWhite, borderRadius: BorderRadius.circular(16.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              children: [
                PhosphorIcon(PhosphorIconsRegular.clock),
                const SizedBox(width: 4.0),
                Text(
                  '24-Hour Forecast',
                  style: semiboldText.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
          Consumer<WeatherProvider>(
            builder: (context, weatherProv, _) {
              if (weatherProv.isLoading) {
                return SizedBox(
                  height: 128.0,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: 10,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12.0),
                    itemBuilder: (context, index) => CustomShimmer(
                      height: 128.0,
                      width: 64.0,
                    ),
                  ),
                );
              }
              return SizedBox(
                height: 128.0,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: weatherProv.hourlyWeather.length,
                  itemBuilder: (context, index) => HourlyWeatherWidget(
                    index: index,
                    data: weatherProv.hourlyWeather[index],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}

class HourlyWeatherWidget extends StatelessWidget {
  final int index;
  final HourlyWeather data;
  const HourlyWeatherWidget({
    Key? key,
    required this.index,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 124.0,
      child: Column(
        children: [
          Consumer<WeatherProvider>(builder: (context, weatherProv, _) {
            return Text(
              weatherProv.isCelsius
                  ? '${data.temp.toCelcius().toStringAsFixed(1)}°'
                  : '${data.temp.toStringAsFixed(1)}°',
              style: semiboldText,
            );
          }),
          Stack(
            children: [
              Divider(
                thickness: 2.0,
                color: primaryBlue,
              ),
              if (index == 0)
                Positioned(
                  top: 2.0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
            ],
          ),
          SizedBox(
            height: 42.0,
            width: 42.0,
            child: Image.asset(
              getWeatherImage(data.icon),
              fit: BoxFit.cover,
            ),
          ),
          FittedBox(
            child: Text(
              data.condition?.toTitleCase() ?? '',
              style: regularText.copyWith(fontSize: 12.0),
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            index == DateTime.now().hour ? 'Now' : DateFormat('hh:mm a').format(data.date),
            style: regularText,
          )
        ],
      ),
    );
  }
}
