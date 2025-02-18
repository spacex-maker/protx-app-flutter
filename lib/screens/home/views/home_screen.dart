import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shop/constants.dart';
import 'package:shop/screens/search/views/search_screen.dart';
import 'components/home_recommend_products.dart';
import 'components/home_category_nav.dart';
import 'components/location_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentLocation = '选择地区';

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationPicker(
        onLocationSelected: (country, city) {
          setState(() {
            _currentLocation = '$country · $city';
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: _buildSearchBar(context),
        automaticallyImplyLeading: false,
      ),
      body: CustomScrollView(
        slivers: [
          // 分类导航
          const SliverToBoxAdapter(
            child: HomeCategoryNav(),
          ),

          // 推荐商品标题
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "猜你喜欢",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Text(
                          "换一批",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.refresh,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 推荐商品列表
          const HomeRecommendProducts(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add_photo_alternate_outlined, size: 28),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        // 地区选择按钮
        TextButton.icon(
          onPressed: _showLocationPicker,
          icon: const Icon(
            Icons.location_on_outlined,
            size: 20,
          ),
          label: Text(
            _currentLocation,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),

        // 搜索框
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '搜索',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 24,
                    width: 1,
                    color: Colors.grey.shade300,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
        ),

        // 消息按钮
        Stack(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.chat_bubble_outline,
                color: Colors.grey.shade700,
                size: 22,
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 1.5,
                  ),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: const Text(
                  '2',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
