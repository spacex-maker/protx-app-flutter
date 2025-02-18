import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../components/buy_full_ui_kit.dart';
import '../../../components/cart_button.dart';
import '../../../components/custom_modal_bottom_sheet.dart';
import '../../../components/product/product_card.dart';
import '../../../constants.dart';
import '../../../components/review_card.dart';
import '../../../models/product_x_model.dart';
import '../../../models/product_detail.dart';
import '../../../services/product_service.dart';
import '../../../utils/http_client.dart';
import '../../../utils/storage.dart';
import 'components/notify_me_card.dart';
import 'components/product_images.dart';
import 'components/product_info.dart';
import 'components/product_list_tile.dart';
import 'product_buy_now_screen.dart';
import 'product_returns_screen.dart';

import 'package:shop/route/screen_export.dart';

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

  @override
  void initState() {
    super.initState();
    _productFuture = ProductService.getProductDetail(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('商品详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<ProductX>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('错误: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('没有找到商品'));
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductImages(
                  images: [product.imageCover, ...?product.images],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.productName,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '¥${product.price.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite_border),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.message),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('加入购物车'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: () {},
                child: const Text('立即购买'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
