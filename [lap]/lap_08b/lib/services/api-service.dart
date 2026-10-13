import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lap_08b/models/WeatherList.dart';

class ApiService {
  Future<List<WeatherList>> getWeatherData({required double lon, required double lat}) async {
    final url = "https://www.7timer.info/bin/civillight.php?lon=$lon&lat=$lat&ac=0&unit=metric&output=json";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> rawList = data['dataseries'];
      List<WeatherList> dataList = rawList.map((item) => WeatherList.fromJson(item)).toList();
      return dataList;
    } else throw Exception('Failed to load weather data');
  }
}
