class ProductX {
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
  final String? username;
  final String? avatar;
  final List<String> imageList;
  final bool isFavorite;
  final List<String>? images;
  final List<Review>? reviews;

  ProductX({
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
    this.username,
    this.avatar,
    this.imageList = const [],
    this.isFavorite = false,
    this.images,
    this.reviews,
  });

  factory ProductX.fromJson(Map<String, dynamic> json) {
    return ProductX(
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
      username: json['username'],
      avatar: json['avatar'],
      imageList:
          json['imageList'] != null ? List<String>.from(json['imageList']) : [],
      isFavorite: json['isFavorite'] ?? false,
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      reviews: json['reviews'] != null
          ? List<Review>.from(json['reviews'].map((x) => Review.fromJson(x)))
          : null,
    );
  }
}

class Review {
  final String id;
  final String content;
  final double rating;
  final String userId;
  final String username;
  final String? userAvatar;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.content,
    required this.rating,
    required this.userId,
    required this.username,
    this.userAvatar,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      content: json['content'],
      rating: json['rating'].toDouble(),
      userId: json['userId'],
      username: json['username'],
      userAvatar: json['userAvatar'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
