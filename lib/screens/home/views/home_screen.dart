import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shop/constants.dart';
import 'package:shop/screens/search/views/search_screen.dart';
import 'components/home_recommend_products.dart';
import 'components/home_category_nav.dart';
import 'components/location_picker.dart';

/// 首页屏幕组件
/// 包含搜索栏、分类导航、推荐商品等内容
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 当前选择的地区
  String _currentLocation = '选择地区';
  // 滚动控制器，用于监听滚动位置实现无限加载
  final ScrollController _scrollController = ScrollController();
  // 添加 key 用于获取 HomeRecommendProducts 的状态
  final _recommendProductsKey = GlobalKey<HomeRecommendProductsState>();

  @override
  void initState() {
    super.initState();
    // 添加滚动监听器
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // 清理滚动控制器
    _scrollController.dispose();
    super.dispose();
  }

  /// 滚动事件处理
  /// 当滚动到接近底部时，触发加载更多数据
  void _onScroll() {
    // 通过 key 获取 HomeRecommendProducts 的状态
    final homeRecommendProductsState = _recommendProductsKey.currentState;

    if (homeRecommendProductsState != null) {
      // 当滚动到距离底部200像素，且不在加载中，且还有更多数据时
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !homeRecommendProductsState.isLoading &&
          homeRecommendProductsState.hasMore) {
        // 触发加载更多数据
        homeRecommendProductsState.loadProducts();
      }
    }
  }

  /// 显示地区选择器
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
        // 使用滚动控制器监听整个页面的滚动
        controller: _scrollController,
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

          // 推荐商品列表，添加 key
          HomeRecommendProducts(key: _recommendProductsKey),
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
