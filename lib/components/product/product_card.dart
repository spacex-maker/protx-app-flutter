import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/product_x_model.dart';
import '../../route/route_constants.dart';
import '../network_image_with_loader.dart';

class ProductCard extends StatelessWidget {
  final ProductX product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  double? get discountPercent {
    if (product.originalPrice > product.price) {
      return ((product.originalPrice - product.price) /
              product.originalPrice *
              100)
          .roundToDouble();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          productDetailsScreenRoute,
          arguments: product.id,
        );
      },
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(140, 220),
        maximumSize: const Size(140, 220),
        padding: const EdgeInsets.all(8),
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.15,
            child: Stack(
              children: [
                NetworkImageWithLoader(
                  product.imageCover,
                  radius: defaultBorderRadious,
                ),
                if (discountPercent != null)
                  Positioned(
                    right: defaultPadding / 2,
                    top: defaultPadding / 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2,
                      ),
                      height: 16,
                      decoration: const BoxDecoration(
                        color: errorColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(defaultBorderRadious),
                        ),
                      ),
                      child: Text(
                        "${discountPercent!.toInt()}% off",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding / 2,
                vertical: defaultPadding / 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 10,
                        ),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Text(
                    product.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontSize: 12,
                        ),
                  ),
                  const Spacer(),
                  if (product.originalPrice > product.price)
                    Row(
                      children: [
                        Text(
                          "¥${product.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Color(0xFF31B0D8),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: defaultPadding / 4),
                        Text(
                          "¥${product.originalPrice.toStringAsFixed(2)}",
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                            fontSize: 10,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      "¥${product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Color(0xFF31B0D8),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
