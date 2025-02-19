import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../../constants.dart';
import '../../../../models/product_x_model.dart';
import '../../../../services/product_service.dart';
import '../../../../route/screen_export.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../widgets/product_card.dart';

/// 首页推荐商品列表组件
/// 使用瀑布流布局展示商品列表，支持分页加载和错误处理
/// 通过 [ProductService] 获取商品数据
class HomeRecommendProducts extends StatefulWidget {
  const HomeRecommendProducts({super.key});

  @override
  HomeRecommendProductsState createState() => HomeRecommendProductsState();
}

/// 推荐商品列表的状态管理类
/// 负责处理商品数据的加载、分页和错误状态
class HomeRecommendProductsState extends State<HomeRecommendProducts> {
  /// 存储已加载的商品列表数据
  final List<ProductX> _products = [];

  /// 标记是否正在加载数据
  bool _isLoading = false;

  /// 标记是否还有更多数据可以加载
  bool _hasMore = true;

  /// 标记是否发生加载错误
  bool _hasError = false;

  /// 存储错误信息，用于显示给用户
  String _errorMessage = '';

  /// 当前页码，用于分页加载
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  /// 加载商品数据
  ///
  /// 如果正在加载或没有更多数据，则直接返回
  /// 加载成功时会更新商品列表和分页信息
  /// 加载失败时会设置错误状态和错误信息
  Future<void> _loadProducts() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final newProducts = await ProductService.getProducts(
        currentPage: _currentPage,
        pageSize: 10,
      );

      setState(() {
        _products.addAll(newProducts);
        _currentPage++;
        _hasMore = newProducts.isNotEmpty;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = '加载失败，请检查网络后重试';
      });
    }
  }

  /// 对外暴露的加载方法，供父组件调用
  Future<void> loadProducts() async {
    await _loadProducts();
  }

  /// 获取当前是否正在加载
  bool get isLoading => _isLoading;

  /// 获取是否还有更多数据
  bool get hasMore => _hasMore;

  @override
  Widget build(BuildContext context) {
    // 处理空状态显示
    if (_products.isEmpty) {
      if (_hasError) {
        return _buildErrorView();
      }
      if (_isLoading) {
        return _buildLoadingView();
      }
    }

    // 使用瀑布流布局展示商品列表
    return SliverPadding(
      padding: const EdgeInsets.all(defaultPadding),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: defaultPadding,
        crossAxisSpacing: defaultPadding,
        childCount: _products.length + (_hasMore || _hasError ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _products.length) {
            return _buildLoadingIndicator();
          }
          return _buildProductCard(_products[index]);
        },
      ),
    );
  }

  /// 构建错误视图
  /// 显示错误图标、错误信息和重试按钮
  Widget _buildErrorView() {
    return SliverToBoxAdapter(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.grey,
            ),
            const SizedBox(height: defaultPadding),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: _loadProducts,
              child: const Text('重新加载'),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建加载中视图
  /// 显示居中的加载指示器
  Widget _buildLoadingView() {
    return const SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  /// 构建底部加载指示器或错误提示
  /// 根据当前状态显示不同的内容：
  /// - 错误状态：显示错误信息和重试按钮
  /// - 加载中：显示加载指示器
  /// - 没有更多数据：显示"到底了"文本
  Widget _buildLoadingIndicator() {
    if (_hasError) {
      return Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.grey),
            ),
            TextButton(
              onPressed: _loadProducts,
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : const Text('到底了', style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  /// 构建商品卡片
  /// 显示商品图片、名称、价格等信息
  /// 点击时跳转到商品详情页
  Widget _buildProductCard(ProductX product) {
    return ProductCard(product: product);
  }
}
