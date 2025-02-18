import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductImages extends StatefulWidget {
  final List<String> images;

  const ProductImages({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  State<ProductImages> createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.images.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.error_outline),
                      );
                    },
                  ),
                );
              },
            );
          }).toList(),
        ),
        if (widget.images.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.images.asMap().entries.map((entry) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withOpacity(
                          _currentIndex == entry.key ? 0.9 : 0.4,
                        ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
