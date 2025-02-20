class ProductListItem {
  final String createTime;
  final String updateTime;
  final int id;
  final int userId;
  final String? province;
  final String city;
  final String productName;
  final String productDescription;
  final double price;
  final double originalPrice;
  final String currencyCode;
  final int stock;
  final String category;
  final String imageCover;
  final int viewCount;
  bool isFavorite;
  // ... 列表页需要的其他字段

  ProductListItem({
    required this.createTime,
    required this.updateTime,
    required this.id,
    required this.userId,
    this.province,
    required this.city,
    required this.productName,
    required this.productDescription,
    required this.price,
    required this.originalPrice,
    required this.currencyCode,
    required this.stock,
    required this.category,
    required this.imageCover,
    required this.viewCount,
    this.isFavorite = false,
  });

  factory ProductListItem.fromJson(Map<String, dynamic> json) {
    return ProductListItem(
      createTime: json['createTime'],
      updateTime: json['updateTime'],
      id: json['id'],
      userId: json['userId'],
      province: json['province'],
      city: json['city'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      price: json['price'].toDouble(),
      originalPrice: json['originalPrice'].toDouble(),
      currencyCode: json['currencyCode'],
      stock: json['stock'],
      category: json['category'],
      imageCover: json['imageCover'],
      viewCount: json['viewCount'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
