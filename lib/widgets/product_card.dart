import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants.dart';
import '../models/product_x_model.dart';
import '../route/route_constants.dart';
import '../models/product_list_item.dart';

class ProductCard extends StatelessWidget {
  final ProductX product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTapProduct(context),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImageSection(product: product),
            ProductInfoSection(product: product),
          ],
        ),
      ),
    );
  }

  void _onTapProduct(BuildContext context) {
    Navigator.pushNamed(
      context,
      productDetailsScreenRoute,
      arguments: product.id,
    );
  }
}

class ProductImageSection extends StatelessWidget {
  final ProductX product;

  const ProductImageSection({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: Stack(
        children: [
          _buildProductImage(),
          if (product.stock <= 5) _buildStockLabel(),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return AspectRatio(
      aspectRatio: 1,
      child: CachedNetworkImage(
        imageUrl: product.imageCover,
        fit: BoxFit.cover,
        memCacheWidth: 300,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        ),
        errorWidget: _buildErrorWidget,
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String url, dynamic error) {
    debugPrint('Image Error for URL: $url');
    debugPrint('Error details: $error');
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 40,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 4),
          Text(
            '图片加载失败',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockLabel() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.8),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          '库存紧张',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class ProductInfoSection extends StatelessWidget {
  final ProductX product;

  const ProductInfoSection({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductName(),
          const SizedBox(height: defaultPadding / 4),
          _buildPriceRow(context),
          const SizedBox(height: defaultPadding / 4),
          _buildBottomRow(),
        ],
      ),
    );
  }

  Widget _buildProductName() {
    return Text(
      product.productName,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context) {
    return Row(
      children: [
        Text(
          "¥${product.price.toStringAsFixed(2)}",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        if (product.originalPrice > product.price) ...[
          const SizedBox(width: 4),
          Text(
            "¥${product.originalPrice.toStringAsFixed(2)}",
            style: TextStyle(
              color: Colors.grey[500],
              decoration: TextDecoration.lineThrough,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildCategoryTag(),
            const SizedBox(width: 4),
            _buildLocationInfo(),
          ],
        ),
        _buildViewCount(),
      ],
    );
  }

  Widget _buildCategoryTag() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        product.category ?? '',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 12,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 2),
        Text(
          product.city ?? '',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildViewCount() {
    return Text(
      '浏览 ${product.viewCount ?? 0}',
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 10,
      ),
    );
  }
}
