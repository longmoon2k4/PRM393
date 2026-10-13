import 'package:flutter/material.dart';
import 'package:lap_08/models/WeatherList.dart';
import 'package:lap_08/services/api-service.dart';

class Weatherscreen extends StatefulWidget {
  const Weatherscreen({super.key});

  @override
  State<Weatherscreen> createState() => _WeatherscreenState();
}

class _WeatherscreenState extends State<Weatherscreen> {
  final ApiService _apiService = ApiService();
  final _lonController = TextEditingController(text: '105.85');
  final _latController = TextEditingController(text: '21.03');

  late Future<List<Weatherlist>> _weatherList;

  void _loadWeather() {
    final double lon = double.parse(_lonController.text);
    final double lat = double.parse(_latController.text);
    setState(() {
      _weatherList = _apiService.getDataWeather(lon: lon, lat: lat);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadWeather();
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
      appBar: AppBar(title: const Text('Dự báo thời tiết')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _lonController,
                    decoration: const InputDecoration(
                      labelText: 'Longitude',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _latController,
                    decoration: const InputDecoration(
                      labelText: 'Latitude',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _loadWeather,
                  child: const Text('Load'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _weatherList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final List<Weatherlist> list = snapshot.data!;
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return ListTile(
                        title: Text(item.date),
                        subtitle: Text(item.weather),
                        trailing: Text('${item.tempMax}°C - ${item.tempMin}°C'),
                      );
                    },
                  );
                }

                return const SizedBox.shrink(); 
              },
            ),
          ),
        ],
      ),
    );
  }
}
