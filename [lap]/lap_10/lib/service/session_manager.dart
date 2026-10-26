import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _tokenKey = 'auth_token';
  static const String _userNameKey = 'auth_user';

  Future<void> saveToken(String token, String username) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_tokenKey, token);
    prefs.setString(_userNameKey, username);
  }
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_tokenKey);
    prefs.remove(_userNameKey);
  }
}