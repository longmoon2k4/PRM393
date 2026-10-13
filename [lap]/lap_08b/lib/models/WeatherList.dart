import 'dart:convert';

class WeatherList {
  final String date;
  final String weather;
  final int tempMax;
  final int tempMin;

  WeatherList({
    required this.date,
    required this.weather,
    required this.tempMax,
    required this.tempMin,
  });

  factory WeatherList.fromJson(Map<String, dynamic> json) {
    return WeatherList(
      date: json['date'].toString(),
      weather: json['weather'],
      tempMax: json['temp2m']['max'] as int,
      tempMin: json['temp2m']['min'] as int,
    );
  }

  String get formattedDate {
    final year = date.substring(0, 4);
    final month = date.substring(4, 6);
    final day = date.substring(6, 8);
    return '$day/$month/$year';
  }

  String get getUmbrellaAdvice {
    return weather == 'rain'
        ? 'Nên mang theo ô khi ra ngoài'
        : 'Hãy chuẩn bị ô nếu có thể';
  }

  String get weatherIcon {
    switch (weather) {
      case 'clear':
        return '☀️';
      case 'pcloudy':
        return '⛅';
      case 'mcloudy':
        return '☁️';
      case 'cloudy':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'snow':
        return '❄️';
      default:
        return '';
    }
  }

  String get getClotherAdvice {
    if (tempMin < 20) {
      return 'Nên mặc áo khoác trước khi ra ngoài';
    } else if (tempMax < 30) {
      return 'Thời tiết mát mẻ, có thể touch grass';
    } else {
      return 'Thời tiết nóng, nên ở trong nhà';
    }
  }
}
