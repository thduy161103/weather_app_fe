// lib/screens/dashboard.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/current_weather_card.dart';
import '../widgets/forecast_list.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _controller = TextEditingController();
  Map<String, dynamic>? _currentData;
  // Forecast model defined in forecast_list.dart
  List<Forecast> _forecasts = [];
  bool _loading = true;
  final _emailController = TextEditingController();
  final _subCityController = TextEditingController();

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16),
            color: Theme.of(ctx).primaryColor,
            child: Center(
              child: Text(
                'Weather Dashboard',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left panel
                  Container(
                    width: 280,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Enter a City Name',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'E.g., New York, London, Tokyo',
                            border: OutlineInputBorder(),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                        SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _onSearch,
                          child: Text('Search'),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                'or',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: _onUseLocation,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.grey.shade600,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Use Current Location'),
                        ),
                        SizedBox(height: 16),
                        // Subscription section
                        Text(
                          'Subscribe for daily forecast:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Your email address',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: _subCityController,
                          decoration: InputDecoration(
                            hintText: 'City for notifications',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _onRegister,
                                child: Text('Register'),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _onUnsubscribe,
                                child: Text('Unsubscribe'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  // Right panel
                  Expanded(
                    child:
                        _loading
                            ? Center(child: CircularProgressIndicator())
                            : (_currentData == null
                                ? Center(child: Text('Error loading weather'))
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CurrentWeatherCard(
                                      city:
                                          _currentData!['location']?['name']
                                              as String? ??
                                          '',
                                      date: () {
                                        final localtime =
                                            _currentData!['location']?['localtime']
                                                as String?;
                                        try {
                                          return localtime != null
                                              ? DateTime.parse(localtime)
                                              : DateTime.now();
                                        } catch (_) {
                                          return DateTime.now();
                                        }
                                      }(),
                                      temp:
                                          (_currentData!['current']?['temp_c']
                                                  as num?)
                                              ?.toDouble() ??
                                          0.0,
                                      wind:
                                          (_currentData!['current']?['wind_kph']
                                                  as num?)
                                              ?.toDouble() ??
                                          0.0,
                                      humidity:
                                          (_currentData!['current']?['humidity']
                                              as int?) ??
                                          0,
                                      iconUrl:
                                          'https:${_currentData!['current']?['condition']?['icon'] ?? ''}',
                                      description:
                                          _currentData!['current']?['condition']?['text']
                                              as String? ??
                                          '',
                                    ),
                                    SizedBox(height: 24),
                                    Text(
                                      '7-Day Forecast',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    // Horizontal scrollable forecast list with fixed height
                                    SizedBox(
                                      height: 160,
                                      child: ForecastList(
                                        forecasts: _forecasts,
                                      ),
                                    ),
                                  ],
                                )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchData('Ho Chi Minh');
  }

  Future<void> _fetchData(String city) async {
    setState(() => _loading = true);
    try {
      // Fetch current weather
      final currentUrl = Uri.parse(
        'http://localhost:3000/weather/current?city=$city',
      );
      final currResp = await http.get(currentUrl);
      if (currResp.statusCode == 200) {
        _currentData = jsonDecode(currResp.body);
      } else {
        _currentData = null;
      }
      // Fetch 7-day forecast
      final forecastUrl = Uri.parse(
        'http://localhost:3000/weather/forecast?city=$city&days=7',
      );
      final foreResp = await http.get(forecastUrl);
      if (foreResp.statusCode == 200) {
        final data = jsonDecode(foreResp.body);
        final days = (data['forecast']?['forecastday'] ?? []) as List;
        _forecasts =
            days.map((d) {
              return Forecast(
                DateTime.parse(d['date'] ?? ''),
                (d['day']?['avgtemp_c'] as num?)?.toDouble() ?? 0.0,
                (d['day']?['maxwind_kph'] as num?)?.toDouble() ?? 0.0,
                (d['day']?['avghumidity'] as num?)?.toInt() ?? 0,
                'https:${d['day']?['condition']?['icon'] ?? ''}',
              );
            }).toList();
      } else {
        _forecasts = [];
      }
    } catch (e) {
      print('[Dashboard] _fetchData error: $e');
      setState(() {
        _currentData = null;
        _forecasts = [];
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  void _onSearch() async {
    final city = _controller.text.trim();
    print('[Dashboard] Search button pressed, city=$city');
    setState(() {
      _loading = true;
    });
    try {
      final url = Uri.parse('http://localhost:3000/weather/current?city=$city');
      print('[Dashboard] Fetching $url');
      final resp = await http.get(url);
      print(
        '[Dashboard] Received response: status=${resp.statusCode}, body=${resp.body}',
      );
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        setState(() {
          _currentData = data;
          _loading = false;
        });
      } else {
        print('[Dashboard] Error response from server');
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      print('[Dashboard] Exception during search: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  void _onUseLocation() {
    /* lấy geo, gọi API */
  }

  Future<void> _onRegister() async {
    final email = _emailController.text.trim();
    final city = _subCityController.text.trim();
    if (email.isEmpty || city.isEmpty) return;
    print('[Dashboard] Register email=$email, city=$city');
    final url = Uri.parse('http://localhost:3000/subscription/register');
    try {
      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'city': city}),
      );
      print('[Dashboard] Register response: ${resp.statusCode} ${resp.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registration request sent. Check email for confirmation.',
          ),
        ),
      );
    } catch (e) {
      print('[Dashboard] Registration error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error sending registration.')));
    }
  }

  Future<void> _onUnsubscribe() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;
    print('[Dashboard] Unsubscribe email=$email');
    final url = Uri.parse('http://localhost:3000/subscription/unsubscribe');
    try {
      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      print(
        '[Dashboard] Unsubscribe response: ${resp.statusCode} ${resp.body}',
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unsubscription processed.')));
    } catch (e) {
      print('[Dashboard] Unsubscribe error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error processing unsubscribe.')));
    }
  }
}
