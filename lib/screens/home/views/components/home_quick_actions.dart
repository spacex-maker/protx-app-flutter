import 'package:flutter/material.dart';
import '../../../../constants.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickAction(
            context,
            icon: Icons.local_mall_outlined,
            label: "逛同城",
            color: Colors.orange,
            onTap: () {},
          ),
          _buildQuickAction(
            context,
            icon: Icons.card_giftcard_outlined,
            label: "特价好物",
            color: Colors.red,
            onTap: () {},
          ),
          _buildQuickAction(
            context,
            icon: Icons.storefront_outlined,
            label: "品牌闪购",
            color: Colors.purple,
            onTap: () {},
          ),
          _buildQuickAction(
            context,
            icon: Icons.volunteer_activism_outlined,
            label: "公益回收",
            color: Colors.green,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
