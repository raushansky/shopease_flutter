class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double oldPrice;
  final String discount;
  final double rating;
  final String reviews;
  final String category;
  final String image;

  ProductModel({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    this.oldPrice = 0.0,
    this.discount = '',
    this.rating = 4.5,
    this.reviews = '0',
    this.category = '',
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    double parsedPrice = double.tryParse((json['price'] ?? 0).toString()) ?? 0.0;
    double parsedOldPrice = json['oldPrice'] != null
        ? (double.tryParse(json['oldPrice'].toString()) ?? (parsedPrice > 0 ? parsedPrice * 1.4 : 0.0))
        : (json['old_price'] != null
            ? (double.tryParse(json['old_price'].toString()) ?? (parsedPrice > 0 ? parsedPrice * 1.4 : 0.0))
            : (parsedPrice > 0 ? parsedPrice * 1.4 : 0.0));

    String name = (json['name'] ?? json['title'] ?? json['product_name'] ?? 'Product').toString();
    String category = (json['category_name'] ?? json['category'] ?? '').toString();
    String rawImage = (json['image_url'] ?? json['image'] ?? json['imageUrl'] ?? json['img'] ?? '').toString();

    String resolvedImage = getValidImageUrl(rawImage, name, category);

    return ProductModel(
      id: (json['id'] ?? json['_id'] ?? json['product_id'] ?? '').toString(),
      name: name,
      description: (json['description'] ?? json['desc'] ?? '').toString(),
      price: parsedPrice,
      oldPrice: parsedOldPrice,
      discount: (json['discount'] ??
          (parsedOldPrice > parsedPrice && parsedPrice > 0
              ? '${(((parsedOldPrice - parsedPrice) / parsedOldPrice) * 100).round()}% OFF'
              : '40% OFF')).toString(),
      rating: double.tryParse((json['rating'] ?? json['rate'] ?? 4.5).toString()) ?? 4.5,
      reviews: (json['reviews'] ?? json['reviews_count'] ?? '10k').toString(),
      category: category,
      image: resolvedImage,
    );
  }

  static String getValidImageUrl(String image, String name, String category) {
    final n = name.toLowerCase();
    final c = category.toLowerCase();

    if (image.isEmpty ||
        image.contains('400x300') ||
        image.contains('placeholder') ||
        image.contains('dummyjson.com/image') ||
        image.contains('-cover') ||
        !image.startsWith('http')) {
      if (n.contains('bat') || n.contains('cricket')) {
        return 'https://images.unsplash.com/photo-1531415074968-036ba1b575da?w=600';
      } else if (n.contains('yoga') || n.contains('mat')) {
        return 'https://images.unsplash.com/photo-1592432678016-e910b452f9a2?w=600';
      } else if (n.contains('coffee') || n.contains('mug')) {
        return 'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=600';
      } else if (n.contains('block') || n.contains('toy') || n.contains('building')) {
        return 'https://images.unsplash.com/photo-1587654780291-39c9404d746b?w=600';
      } else if (n.contains('steel') || n.contains('bottle') || n.contains('insulated')) {
        return 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=600';
      } else if (n.contains('shoe') || n.contains('running') || c.contains('shoe') || c.contains('sports')) {
        return 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600';
      } else if (n.contains('shawl') || n.contains('dress') || n.contains('shirt') || n.contains('cloth') || c.contains('fashion')) {
        return 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=600';
      } else if (n.contains('watch') || n.contains('smart')) {
        return 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600';
      } else if (n.contains('headphone') || n.contains('earbud') || n.contains('audio') || n.contains('music')) {
        return 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600';
      } else if (n.contains('phone') || c.contains('mobile')) {
        return 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=600';
      }
      return 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=600';
    }
    return image;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'oldPrice': oldPrice,
      'discount': discount,
      'rating': rating,
      'reviews': reviews,
      'category': category,
      'image': image,
    };
  }
}
