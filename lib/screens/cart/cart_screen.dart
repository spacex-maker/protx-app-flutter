import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/cart_item_model.dart';
import '../../utils/http_client.dart';
import '../../utils/storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> _cartItems = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasMore = true;
  double _totalPrice = 0.0;
  Set<int> _selectedItems = {};

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    print('CartScreen initState');
    _loadCartItems();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_hasMore && !_isLoading) {
        print('触发滚动加载');
        _loadCartItems();
      }
    }
  }

  Future<void> _loadCartItems() async {
    print('开始加载购物车数据...');
    if (!_hasMore || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final token = await Storage.getToken();
      if (token == null) {
        if (!mounted) return;
        Navigator.pushNamed(context, '/login');
        return;
      }

      final response = await HttpClient.get(
        '/productx/user-shopping-cart/list',
        queryParameters: {
          'pageSize': _pageSize,
          'currentPage': _currentPage,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success']) {
        final List<dynamic> newItems = response.data['data']['data'];
        final newCartItems =
            newItems.map((item) => CartItem.fromJson(item)).toList();

        if (mounted) {
          setState(() {
            if (_currentPage == 1) {
              _cartItems = newCartItems;
            } else {
              _cartItems.addAll(newCartItems);
            }
            _hasMore = newItems.length == _pageSize;
            _currentPage++;
            _isLoading = false;
          });
        }
      } else {
        print('加载购物车数据失败: ${response.data['message']}');
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.data['message'] ?? '加载失败')),
          );
        }
      }
    } catch (e) {
      print('加载购物车数据错误: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败: $e')),
        );
      }
    }
  }

  void _updateTotalPrice() {
    double total = 0.0;
    for (var id in _selectedItems) {
      var item = _cartItems.firstWhere((item) => item.id == id);
      total += item.userProductDetailResponse.price * item.quantity;
    }
    setState(() => _totalPrice = total);
  }

  Widget _buildEmptyCart() {
    return const Center(
      child: Text('购物车是空的'),
    );
  }

  Widget _buildCartList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _cartItems.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _cartItems.length) {
          return _buildLoadingIndicator();
        }
        return _buildCartItem(_cartItems[index]);
      },
    );
  }

  Widget _buildCartItem(CartItem item) {
    final product = item.userProductDetailResponse;
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Checkbox(
              value: _selectedItems.contains(item.id),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedItems.add(item.id);
                  } else {
                    _selectedItems.remove(item.id);
                  }
                  _updateTotalPrice();
                });
              },
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: product.imageCover,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '¥${product.price}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _buildQuantityControl(item),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityControl(CartItem item) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: item.quantity > 1
              ? () {
                  setState(() {
                    item.quantity--;
                    if (_selectedItems.contains(item.id)) {
                      _updateTotalPrice();
                    }
                  });
                }
              : null,
        ),
        Text('${item.quantity}'),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              item.quantity++;
              if (_selectedItems.contains(item.id)) {
                _updateTotalPrice();
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }

  Widget _buildBottomBar() {
    return Material(
      elevation: 8,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Row(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _selectedItems.length == _cartItems.length &&
                        _cartItems.isNotEmpty,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedItems =
                              _cartItems.map((item) => item.id).toSet();
                        } else {
                          _selectedItems.clear();
                        }
                        _updateTotalPrice();
                      });
                    },
                  ),
                  const Text('全选'),
                ],
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '合计: ¥${_totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '已选${_selectedItems.length}件商品',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _selectedItems.isEmpty
                      ? null
                      : () {
                          // TODO: 实现结算功能
                        },
                  child: const Text(
                    '结算',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('购物车'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _cartItems.isEmpty && !_isLoading
                ? _buildEmptyCart()
                : _buildCartList(),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
