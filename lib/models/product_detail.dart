class ProductDetail {
  final int id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  // 添加其他需要的字段...

  ProductDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      images: List<String>.from(json['images']),
    );
  }
}
