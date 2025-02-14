import 'package:flutter/material.dart';
import '../../../../constants.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "分类市场",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: defaultPadding),
          Wrap(
            spacing: 24, // 水平间距
            runSpacing: 20, // 垂直间距
            children: [
              _buildCategory(
                icon: Icons.phone_android_outlined,
                label: "手机数码",
                color: Colors.blue,
                onTap: () {},
              ),
              _buildCategory(
                icon: Icons.laptop_outlined,
                label: "电脑办公",
                color: Colors.orange,
                onTap: () {},
              ),
              _buildCategory(
                icon: Icons.watch_outlined,
                label: "智能数码",
                color: Colors.purple,
                onTap: () {},
              ),
              _buildCategory(
                icon: Icons.sports_basketball_outlined,
                label: "运动户外",
                color: Colors.green,
                onTap: () {},
              ),
              _buildCategory(
                icon: Icons.checkroom_outlined,
                label: "服饰鞋包",
                color: Colors.red,
                onTap: () {},
              ),
              _buildCategory(
                icon: Icons.diamond_outlined,
                label: "珠宝配饰",
                color: Colors.pink,
                onTap: () {},
              ),
              _buildCategory(
                icon: Icons.home_outlined,
                label: "家居家装",
                color: Colors.teal,
                onTap: () {},
              ),
              _buildCategory(
                icon: Icons.book_outlined,
                label: "图书文具",
                color: Colors.indigo,
                onTap: () {},
              ),
              _buildCategory(
                icon: Icons.car_repair_outlined,
                label: "汽车用品",
                color: Colors.brown,
                onTap: () {},
              ),
              _buildCategory(
                icon: Icons.more_horiz,
                label: "更多分类",
                color: Colors.grey,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategory({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 64, // 固定宽度
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
