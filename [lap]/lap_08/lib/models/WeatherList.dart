import 'dart:convert';

class Weatherlist {
  final String date;
  final String weather;
  final int tempMax;
  final int tempMin;

  Weatherlist({
    required this.date,
    required this.weather,
    required this.tempMax,
    required this.tempMin,
  });

  factory Weatherlist.fromJson(Map<String, dynamic> json) {
    return Weatherlist(
      date: json['date'].toString(),
      weather: json['weather'],
      tempMax: json['temp2m']['max'] as int,
      tempMin: json['temp2m']['min'] as int,
    );
  }
}
