import '../models/product_x_model.dart';
import '../utils/http_client.dart';
import '../utils/storage.dart';
import 'package:http/http.dart';
import 'package:dio/dio.dart';

class ProductService {
  static Future<List<ProductX>> getProducts({
    String? searchKey,
    double? priceUp,
    double? priceDown,
    String? category,
    String? province,
    String? city,
    bool viewCountEnabled = false,
    int pageSize = 10,
    int currentPage = 1,
  }) async {
    try {
      final queryParameters = {
        if (searchKey != null) 'searchKey': searchKey,
        if (priceUp != null) 'priceUp': priceUp.toString(),
        if (priceDown != null) 'priceDown': priceDown.toString(),
        if (category != null) 'category': category,
        if (province != null) 'province': province,
        if (city != null) 'city': city,
        'viewCountEnabled': viewCountEnabled.toString(),
        'pageSize': pageSize.toString(),
        'currentPage': currentPage.toString(),
      };

      final response = await HttpClient.get(
        '/productx/user-product/list',
        queryParameters: queryParameters,
      );

      if (response.data['success'] == true) {
        final List<dynamic> productsJson = response.data['data']['data'];
        return productsJson.map((json) => ProductX.fromJson(json)).toList();
      }
      throw Exception('加载商品失败');
    } catch (e) {
      throw Exception('网络请求错误: $e');
    }
  }

  static Future<ProductX> getProductDetail(int productId) async {
    try {
      final token = await Storage.getToken();

      final response = await HttpClient.post(
        '/productx/user-product/detail',
        data: {"productId": productId},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('API Response: ${response.data}');

      if (response.data['success']) {
        return ProductX.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '获取商品详情失败');
      }
    } catch (e) {
      print('Error in getProductDetail: $e');
      rethrow;
    }
  }
}
