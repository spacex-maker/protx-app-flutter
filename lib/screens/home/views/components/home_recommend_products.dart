import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../../constants.dart';
import '../../../../models/product_x_model.dart';
import '../../../../services/product_service.dart';
import '../../../../route/screen_export.dart';

class HomeRecommendProducts extends StatefulWidget {
  const HomeRecommendProducts({super.key});

  @override
  State<HomeRecommendProducts> createState() => _HomeRecommendProductsState();
}

class _HomeRecommendProductsState extends State<HomeRecommendProducts> {
  final List<ProductX> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  bool _hasError = false;
  String _errorMessage = '';
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

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

  @override
  Widget build(BuildContext context) {
    if (_products.isEmpty) {
      if (_hasError) {
        return _buildErrorView();
      }
      if (_isLoading) {
        return _buildLoadingView();
      }
    }

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

  Widget _buildProductCard(ProductX product) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          productDetailsScreenRoute,
          arguments: product.id,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(defaultBorderRadious),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 商品图片
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(defaultBorderRadious),
                ),
                child: Image.network(
                  product.imageCover,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.error_outline,
                        size: 40,
                        color: Colors.red,
                      ),
                    );
                  },
                ),
              ),
            ),
            // 商品信息
            Padding(
              padding: const EdgeInsets.all(defaultPadding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: defaultPadding / 4),
                  Text(
                    "¥${product.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: defaultPadding / 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 12,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 2),
                          Text(
                            product.city,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '浏览 ${product.viewCount}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
