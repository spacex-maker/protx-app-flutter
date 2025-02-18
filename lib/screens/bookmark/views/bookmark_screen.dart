import 'package:flutter/material.dart';
import '../../../components/product/product_card.dart';
import '../../../models/product_x_model.dart';
import '../../../services/product_service.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('收藏夹'),
      ),
      body: FutureBuilder<List<ProductX>>(
        future: ProductService.getProducts(), // 这里应该改成获取收藏商品的接口
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('错误: ${snapshot.error}'));
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(child: Text('暂无收藏商品'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          );
        },
      ),
    );
  }
}
