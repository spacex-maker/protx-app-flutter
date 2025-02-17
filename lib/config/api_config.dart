import 'env_config.dart';

/// API 配置类
/// 管理所有 API 相关的配置信息，包括基础 URL、超时设置、API 路径等
class ApiConfig {
  /// 开发环境地址
  static const String devBaseUrl = 'http://10.0.2.2:8080';

  /// 测试环境地址
  static const String stagingBaseUrl = 'http://10.0.2.2:8080';

  /// 生产环境地址
  static const String prodBaseUrl = 'http://api.example.com';

  /// 当前使用的基础地址
  static const String baseUrl = stagingBaseUrl;

  /// API 前缀
  static const String apiPrefix = '/productx';

  /// 完整的 API 基础地址
  static String get apiBaseUrl => '$baseUrl$apiPrefix';

  /// 网络请求超时时间
  static const int connectTimeout = 15000; // 15秒
  static const int receiveTimeout = 15000; // 15秒

  /// API 路径
  static const String register = '/user/register'; // 注册接口
  static const String login = '/user/login'; // 登录接口
  static const String forgotPassword = '/user/forgot-password'; // 忘记密码
  static const String resetPassword = '/user/reset-password'; // 重置密码
  static const String verifyCode = '/user/verify-code'; // 验证码验证
  static const String refreshToken = '/user/refresh-token'; // 刷新令牌

  /// 获取完整的 API URL
  static String getFullUrl(String path) {
    final baseUrl = EnvConfig.baseUrl;
    return '$baseUrl$apiPrefix$path';
  }

  /// 默认请求头
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
