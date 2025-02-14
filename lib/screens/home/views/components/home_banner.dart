import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import '../../../../constants.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  int _currentIndex = 0;
  final List<String> bannerImages = [
    "assets/images/banner1.jpg",
    "assets/images/banner2.jpg",
    "assets/images/banner3.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: Swiper(
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(bannerImages[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            itemCount: bannerImages.length,
            viewportFraction: 0.92,
            scale: 0.95,
            autoplay: true,
            onIndexChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            pagination: SwiperPagination(
              margin: const EdgeInsets.only(top: 16),
              builder: DotSwiperPaginationBuilder(
                activeColor: Theme.of(context).primaryColor,
                color: Colors.grey.shade300,
                size: 8,
                activeSize: 8,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
