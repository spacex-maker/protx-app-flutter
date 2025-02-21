import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static SharedPreferences? _prefs;

  /// 初始化 SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String _tokenKey = 'auth_token';
  static const String _userInfoKey = 'user_info';

  // 存储token
  static Future<void> setToken(String token) async {
    await _prefs?.setString(_tokenKey, token);
  }

  // 获取token
  static Future<String?> getToken() async {
    return _prefs?.getString(_tokenKey);
  }

  // 存储用户信息
  static Future<void> setUserInfo(Map<String, dynamic> userInfo) async {
    await _prefs?.setString(_userInfoKey, json.encode(userInfo));
  }

  // 获取用户信息
  static Future<Map<String, dynamic>?> getUserInfo() async {
    final userInfoString = _prefs?.getString(_userInfoKey);
    if (userInfoString != null) {
      return json.decode(userInfoString);
    }
    return null;
  }

  // 清除所有存储的数据
  static Future<void> clear() async {
    await _prefs?.clear();
  }

  /// 获取字符串
  static Future<String?> getString(String key) async {
    if (_prefs == null) await init();
    return _prefs?.getString(key);
  }

  /// 保存字符串
  static Future<bool> setString(String key, String value) async {
    if (_prefs == null) await init();
    return await _prefs?.setString(key, value) ?? false;
  }
}
