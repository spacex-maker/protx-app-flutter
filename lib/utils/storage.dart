import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static const String _tokenKey = 'auth_token';
  static const String _userInfoKey = 'user_info';

  // 存储token
  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // 获取token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // 存储用户信息
  static Future<void> setUserInfo(Map<String, dynamic> userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userInfoKey, json.encode(userInfo));
  }

  // 获取用户信息
  static Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoString = prefs.getString(_userInfoKey);
    if (userInfoString != null) {
      return json.decode(userInfoString);
    }
    return null;
  }

  // 清除所有存储的数据
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
