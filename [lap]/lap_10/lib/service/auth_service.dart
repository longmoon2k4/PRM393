import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  static const String _urlString = 'https://dummyjson.com/auth/login';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse(_urlString);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return {
        'success': true,
        'token': data['accessToken'] ?? data['token'],
        'userData': data['user'],
      };
    } else {
      final errorData = jsonDecode(response.body);
      return {
        'success': false,
        'message': errorData['message'] ?? 'Đăng nhập thất bại!',
      };
    }
  }
}
