import 'package:flutter/material.dart';
import '../models/product_list_item.dart';
import '../route/route_constants.dart';

class ProductListCard extends StatelessWidget {
  final ProductListItem product;

  const ProductListCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
      child: GestureDetector(
        onTap: () => _onTapProduct(context),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProductListImageSection(product: product),
              _ProductListInfoSection(product: product),
            ],
          ),
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

class _ProductListImageSection extends StatelessWidget {
  final ProductListItem product;

  const _ProductListImageSection({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.network(
          product.imageCover,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _ProductListInfoSection extends StatelessWidget {
  final ProductListItem product;

  const _ProductListInfoSection({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.productName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            product.productDescription,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '¥${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              if (product.originalPrice > product.price)
                Text(
                  '¥${product.originalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '库存: ${product.stock}',
                style: TextStyle(
                  fontSize: 11,
                  color: product.stock <= 5 ? Colors.red : Colors.grey[600],
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.remove_red_eye_outlined,
                    size: 12,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${product.viewCount}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
