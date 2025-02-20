import 'package:flutter/material.dart';
import '../../../utils/http_client.dart';
import '../../../route/route_constants.dart';
import '../../../models/product_x_model.dart';
import '../../../services/product_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import '../../../utils/storage.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late Future<ProductX> _productFuture;
  ProductX? _product;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _productFuture = ProductService.getProductDetail(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<ProductX>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LoadingView();
          }

          if (snapshot.hasError) {
            return _ErrorView(error: snapshot.error);
          }

          _product = snapshot.data;
          return _ProductDetailView(
            product: _product!,
            onAddToCart: _addToCart,
            onToggleFavorite: _toggleFavorite,
            isAddingToCart: _isAddingToCart,
          );
        },
      ),
    );
  }

  Future<void> _addToCart() async {
    if (_product == null) return;
    setState(() => _isAddingToCart = true);

    try {
      final token = await Storage.getToken();
      if (token == null) {
        if (!mounted) return;
        Navigator.pushNamed(context, '/login');
        return;
      }

      final response = await HttpClient.post(
        '/productx/user-shopping-cart/create',
        data: {'productId': widget.productId, 'quantity': 1},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success'] && mounted) {
        _showSuccessSnackBar('已加入购物车', '查看购物车', () {
          Navigator.pushNamed(context, cartScreenRoute);
        });
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('加入购物车失败');
    } finally {
      if (mounted) setState(() => _isAddingToCart = false);
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      final token = await Storage.getToken();
      if (token == null) {
        if (!mounted) return;
        Navigator.pushNamed(context, '/login');
        return;
      }

      final isFavorite = _product?.isFavorite ?? false;
      final response = await HttpClient.post(
        isFavorite
            ? '/productx/user-product-favorites/remove'
            : '/productx/user-product-favorites/add',
        data: {'id': widget.productId},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.data['success'] && mounted) {
        setState(() => _product!.isFavorite = !isFavorite);
        _showSuccessSnackBar(isFavorite ? '已取消收藏' : '已收藏');
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('操作失败');
    }
  }

  void _showSuccessSnackBar(String message,
      [String? actionLabel, VoidCallback? onAction]) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _ErrorView extends StatelessWidget {
  final Object? error;

  const _ErrorView({this.error});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('错误: $error'));
  }
}

class _ProductDetailView extends StatelessWidget {
  final ProductX product;
  final VoidCallback onAddToCart;
  final VoidCallback onToggleFavorite;
  final bool isAddingToCart;

  const _ProductDetailView({
    required this.product,
    required this.onAddToCart,
    required this.onToggleFavorite,
    required this.isAddingToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildProductInfo(context),
                  _buildDescription(),
                  _buildStats(),
                  if (product.username != null) _buildSellerInfo(),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildBottomBar(context),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      floating: true,
      snap: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: product.imageCover ?? '',
          fit: BoxFit.cover,
        ),
        title: const Text('商品详情'),
        centerTitle: true,
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SelectableText(
              product.productName ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '¥${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (product.originalPrice != null &&
                  product.originalPrice > product.price)
                Text(
                  '¥${product.originalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SelectableText(
        product.productDescription ?? '',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '库存: ${product.stock ?? 0}',
            style: TextStyle(
              fontSize: 14,
              color: (product.stock ?? 0) <= 5 ? Colors.red : Colors.grey[600],
            ),
          ),
          Row(
            children: [
              Icon(Icons.remove_red_eye_outlined,
                  size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${product.viewCount ?? 0}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSellerInfo() {
    return Column(
      children: [
        const Divider(),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: CircleAvatar(
            backgroundImage:
                product.avatar != null ? NetworkImage(product.avatar!) : null,
            child: product.avatar == null ? const Icon(Icons.person) : null,
          ),
          title: Text(product.username ?? ''),
          subtitle: Text(product.city ?? ''),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16)
          .copyWith(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: product.isFavorite == true ? Colors.red : Colors.grey[400],
            ),
            onPressed: onToggleFavorite,
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: isAddingToCart
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.green,
                    ),
                  )
                : const Icon(Icons.shopping_cart),
            onPressed: isAddingToCart ? null : onAddToCart,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.red,
              ),
              onPressed: () {},
              child: const Text(
                '立即购买',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
