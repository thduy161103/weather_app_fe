// lib/widgets/forecast_list.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Forecast {
  final DateTime date;
  final double temp;
  final double wind;
  final int humidity;
  final String iconUrl;

  Forecast(this.date, this.temp, this.wind, this.humidity, this.iconUrl);
}

class ForecastList extends StatelessWidget {
  final List<Forecast> forecasts;
  const ForecastList({required this.forecasts});

  @override
  Widget build(BuildContext ctx) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: forecasts.length,
      separatorBuilder: (_, __) => SizedBox(width: 12),
      itemBuilder: (_, i) {
        final f = forecasts[i];
        return Container(
          width: 140,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade600,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                '(${DateFormat('yyyy-MM-dd').format(f.date)})',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 8),
              Image.network(f.iconUrl, width: 40, height: 40),
              SizedBox(height: 8),
              Text(
                'Temp: ${f.temp.toStringAsFixed(2)}°C',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Wind: ${f.wind.toStringAsFixed(2)} M/S',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Humidity: ${f.humidity}%',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}
