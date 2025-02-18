import 'package:flutter/material.dart';
import '../../../../constants.dart';

class HomeCategoryNav extends StatelessWidget {
  const HomeCategoryNav({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'icon': Icons.phone_android, 'title': '手机数码'},
      {'icon': Icons.laptop, 'title': '电脑办公'},
      {'icon': Icons.watch, 'title': '智能数码'},
      {'icon': Icons.camera_alt, 'title': '相机摄影'},
      {'icon': Icons.headphones, 'title': '耳机音响'},
      {'icon': Icons.sports_esports, 'title': '游戏相关'},
      {'icon': Icons.book, 'title': '图书文具'},
      {'icon': Icons.more_horiz, 'title': '更多'},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: defaultPadding,
          crossAxisSpacing: defaultPadding,
          childAspectRatio: 1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  categories[index]['icon'] as IconData,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                categories[index]['title'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
