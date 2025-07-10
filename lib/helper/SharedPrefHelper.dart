import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<bool> isAuth() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  Future<void> saveMessage(String message) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('message', message);
  }

  Future<String?> getMessage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('message');
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  Future<void> removeRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('role');
  }
}
