import 'package:flutter/material.dart';

import '../models/WeatherList.dart';
import '../services/api-service.dart';

class Weatherscreen extends StatefulWidget {
  const Weatherscreen({super.key});

  @override
  State<Weatherscreen> createState() => _WeatherscreenState();
}

class _WeatherscreenState extends State<Weatherscreen> {
  final ApiService _apiService = ApiService();

  final _lonController = TextEditingController(text: '105.85');
  final _latController = TextEditingController(text: '21.03');

  late Future<List<WeatherList>> _weatherData;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  void _loadWeather() async {
    final double? lon = double.tryParse(_lonController.text);
    final double? lat = double.tryParse(_latController.text);

    if (lon == null || lat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đúng định dạng số!')),
      );
      return;
    }
    setState(() {
      _weatherData = _apiService.getWeatherData(lon: lon, lat: lat);
    });
  }

  @override
  void dispose() {
    _lonController.dispose();
    _latController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Column(
        children: [
          // Khu vực nhập tọa độ và nút bấm
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _lonController,
                    decoration: const InputDecoration(
                      labelText: 'Kinh độ',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _latController,
                    decoration: const InputDecoration(
                      labelText: 'Vĩ độ',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _loadWeather,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                  child: const Text('Xem'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<WeatherList>>(
              future: _weatherData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                }
                else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không có dữ liệu thời tiết.'));
                }
                final weatherList = snapshot.data!;
                return ListView.builder(
                  itemCount: weatherList.length,
                  itemBuilder: (context, index) {
                    final weather = weatherList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Text(
                              weather.weatherIcon,
                              style: const TextStyle(fontSize: 48),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    weather.formattedDate,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('Nhiệt độ: ${weather.tempMin}°C - ${weather.tempMax}°C'),
                                  Text('Trạng thái: ${weather.weather}'),
                                  const Divider(),
                                  Text(
                                    '${weather.getUmbrellaAdvice}',
                                    style: const TextStyle(color: Colors.blueAccent),
                                  ),
                                  Text(
                                    '${weather.getClotherAdvice}',
                                    style: const TextStyle(color: Colors.orange),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
