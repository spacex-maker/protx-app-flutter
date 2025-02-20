import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../constants.dart';
import '../../../models/product_x_model.dart';
import '../../../services/product_service.dart';
import '../../../route/route_constants.dart';
import '../../../widgets/product_card.dart';
import '../../../models/product_list_item.dart';
import '../../../widgets/product_list_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  // 搜索结果相关状态
  final List<ProductListItem> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  bool _hasError = false;
  String _errorMessage = '';
  int _currentPage = 1;

  // 控制历史记录展开/收起
  bool _isHistoryExpanded = true;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _searchProducts();
    }
  }

  Future<void> _searchProducts() async {
    if (_isLoading || !_hasMore || _searchController.text.trim().isEmpty)
      return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final newProducts = await ProductService.getProducts(
        searchKey: _searchController.text,
        currentPage: _currentPage,
        pageSize: 10,
      );

      setState(() {
        _products.addAll(newProducts);
        _currentPage++;
        _hasMore = newProducts.isNotEmpty;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = '加载失败，请检查网络后重试';
      });
    }
  }

  void _handleSearch(String value) {
    if (value.trim().isEmpty) return;

    // TODO: 保存搜索历史

    setState(() {
      _products.clear();
      _currentPage = 1;
      _hasMore = true;
      _hasError = false;
      _isHistoryExpanded = false; // 搜索时收起历史记录
    });

    _searchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Container(
            height: 40,
            margin: const EdgeInsets.only(right: defaultPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: '搜索你想要的宝贝',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade400,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _products.clear();
                      _isHistoryExpanded = true;
                    });
                  },
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: _handleSearch,
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // 搜索历史部分
          if (_isHistoryExpanded && _products.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "搜索历史",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () {
                                // TODO: 清除搜索历史
                              },
                            ),
                            IconButton(
                              icon: Icon(_isHistoryExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down),
                              onPressed: () {
                                setState(() {
                                  _isHistoryExpanded = !_isHistoryExpanded;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (_isHistoryExpanded)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          "iPhone 14",
                          "MacBook Pro",
                          "AirPods",
                          "iPad"
                        ].map((item) => _buildHistoryItem(item)).toList(),
                      ),
                  ],
                ),
              ),
            ),

          // 搜索结果部分
          if (_isLoading)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          else if (_hasError)
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            )
          else if (_products.isEmpty && _searchController.text.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.search_off_outlined,
                        size: 48,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '暂无搜索结果',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '没有找到"${_searchController.text}"相关的商品',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '搜索建议',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.tips_and_updates_outlined,
                                size: 16,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '检查输入是否正确',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.tips_and_updates_outlined,
                                size: 16,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '尝试使用其他关键词',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.tips_and_updates_outlined,
                                size: 16,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '使用更简单的词语',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_products.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.all(defaultPadding),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: defaultPadding,
                crossAxisSpacing: defaultPadding,
                itemBuilder: (context, index) {
                  if (index >= _products.length) {
                    if (_isLoading) {
                      return Container(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (_hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: Text(_errorMessage),
                        ),
                      );
                    }
                    return const SizedBox();
                  }
                  // 为每个 ProductCard 添加唯一的 key
                  return ProductListCard(product: _products[index]);
                },
                childCount:
                    _products.length + (_isLoading || _hasError ? 1 : 0),
              ),
            ),

          // 热门搜索部分
          if (_products.isEmpty && !_isLoading)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "热门搜索",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        "iPhone 15",
                        "Switch",
                        "PS5",
                        "显卡",
                        "机械键盘",
                        "相机"
                      ].map((item) => _buildHotSearchItem(item)).toList(),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String text) {
    return InkWell(
      onTap: () {
        _searchController.text = text;
        // TODO: 执行搜索
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildHotSearchItem(String text) {
    return InkWell(
      onTap: () {
        _searchController.text = text;
        // TODO: 执行搜索
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
