import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lap_08/models/WeatherList.dart';

class ApiService {
  Future<List<Weatherlist>> getDataWeather({required double lon, required double lat}) async {
    final url = "https://www.7timer.info/bin/civillight.php?lon=$lon&lat=$lat&ac=0&unit=metric&output=json";
    
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Có trường hợp server trả về nội dung lỗi nhưng kèm thêm một số string không phải json.
        // Hoặc mạng bị chặn. Ta bọc trong try-catch để xem lỗi thật sự là gì.
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> dataSeries = jsonResponse['dataseries'];
        return dataSeries.map((data) => Weatherlist.fromJson(data)).toList();
      } else {
        throw Exception('Server trả về lỗi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi hệ thống/mạng: $e');
    }
  }
}