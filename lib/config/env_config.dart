import 'api_config.dart';

/// 环境枚举
/// 用于区分开发、测试和生产环境
enum Environment {
  dev, // 开发环境
  staging, // 测试环境
  prod // 生产环境
}

/// 环境配置类
/// 管理不同环境的配置信息
class EnvConfig {
  /// 当前环境设置
  static Environment environment = Environment.staging; // 默认使用测试环境

  /// 获取当前环境的基础 URL
  static String get baseUrl {
    switch (environment) {
      case Environment.dev:
        return ApiConfig.devBaseUrl;
      case Environment.staging:
        return ApiConfig.stagingBaseUrl;
      case Environment.prod:
        return ApiConfig.prodBaseUrl;
    }
  }

  /// 环境判断方法
  static bool get isDevelopment => environment == Environment.dev;
  static bool get isStaging => environment == Environment.staging;
  static bool get isProduction => environment == Environment.prod;
}
