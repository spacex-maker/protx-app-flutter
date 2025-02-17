import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../config/env_config.dart';

/// HTTP 客户端工具类
/// 封装 Dio 实例，提供统一的网络请求方法
class HttpClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8080/productx', // 确保基础URL正确
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  /// 获取 Dio 实例
  static Dio get dio {
    return _dio;
  }

  /// 创建 Dio 实例
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.baseUrl,
        headers: ApiConfig.defaultHeaders,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 5),
      ),
    );

    // 添加拦截器
    dio.interceptors.addAll([
      LogInterceptor(
        request: true, // 总是打印请求日志
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    ]);

    return dio;
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
    // 使用 ApiConfig.getFullUrl 获取完整 URL
    final fullUrl = ApiConfig.getFullUrl(path);
    return await dio.post(
      fullUrl,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
