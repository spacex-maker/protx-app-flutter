import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../config/env_config.dart';
import 'storage.dart'; // 添加 storage 引入用于持久化

/// HTTP 客户端工具类
/// 封装 Dio 实例，提供统一的网络请求方法
class HttpClient {
  static final Dio _dio = createDio();
  static const String _baseUrlKey = 'api_base_url'; // 存储 key
  static const String _defaultBaseUrl = 'http://10.0.2.2:8080/'; // 默认地址

  /// 获取 Dio 实例
  static Dio get dio => _dio;

  /// 创建 Dio 实例
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _defaultBaseUrl, // 初始使用默认地址
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 5),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 添加拦截器
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );

    // 初始化时尝试从存储加载 baseUrl
    _loadBaseUrl();

    return dio;
  }

  /// 从存储加载 baseUrl
  static Future<void> _loadBaseUrl() async {
    final savedBaseUrl = await Storage.getString(_baseUrlKey);
    if (savedBaseUrl != null && savedBaseUrl.isNotEmpty) {
      _dio.options.baseUrl = savedBaseUrl;
    }
  }

  /// 设置并保存 baseUrl
  static Future<void> setBaseUrl(String url) async {
    _dio.options.baseUrl = url;
    await Storage.setString(_baseUrlKey, url);
  }

  /// 获取当前 baseUrl
  static String getBaseUrl() {
    return _dio.options.baseUrl;
  }

  /// GET 请求方法
  static Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// POST 请求方法
  static Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
