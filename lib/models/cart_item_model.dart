class CartItem {
  final String createTime;
  final String updateTime;
  final int id;
  final int userId;
  final int productId;
  int quantity;
  final ProductDetail userProductDetailResponse;

  CartItem({
    required this.createTime,
    required this.updateTime,
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.userProductDetailResponse,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      createTime: json['createTime'],
      updateTime: json['updateTime'],
      id: json['id'],
      userId: json['userId'],
      productId: json['productId'],
      quantity: json['quantity'],
      userProductDetailResponse:
          ProductDetail.fromJson(json['userProductDetailResponse']),
    );
  }
}

class ProductDetail {
  final String createTime;
  final String updateTime;
  final int id;
  final int userId;
  final String username;
  final String avatar;
  final String productName;
  final String productDescription;
  final double price;
  final double originalPrice;
  final String currencyCode;
  final int stock;
  final String category;
  final String city;
  final String imageCover;
  final List<String> imageList;
  final int viewCount;
  final bool? isFavorite;

  ProductDetail({
    required this.createTime,
    required this.updateTime,
    required this.id,
    required this.userId,
    required this.username,
    required this.avatar,
    required this.productName,
    required this.productDescription,
    required this.price,
    required this.originalPrice,
    required this.currencyCode,
    required this.stock,
    required this.category,
    required this.city,
    required this.imageCover,
    required this.imageList,
    required this.viewCount,
    this.isFavorite,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      createTime: json['createTime'],
      updateTime: json['updateTime'],
      id: json['id'],
      userId: json['userId'],
      username: json['username'],
      avatar: json['avatar'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      currencyCode: json['currencyCode'],
      stock: json['stock'],
      category: json['category'],
      city: json['city'],
      imageCover: json['imageCover'],
      imageList: List<String>.from(json['imageList']),
      viewCount: json['viewCount'],
      isFavorite: json['isFavorite'],
    );
  }
}
