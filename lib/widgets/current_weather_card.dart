// lib/widgets/current_weather_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentWeatherCard extends StatelessWidget {
  final String city;
  final DateTime date;
  final double temp;
  final double wind;
  final int humidity;
  final String iconUrl;
  final String description;

  const CurrentWeatherCard({
    required this.city,
    required this.date,
    required this.temp,
    required this.wind,
    required this.humidity,
    required this.iconUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext ctx) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(ctx).primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$city (${DateFormat('yyyy-MM-dd').format(date)})',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  'Temperature: ${temp.toStringAsFixed(1)}°C',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Wind: ${wind.toStringAsFixed(2)} M/S',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Humidity: $humidity%',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Image.network(iconUrl, width: 60, height: 60),
          SizedBox(width: 8),
          Text(description, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
