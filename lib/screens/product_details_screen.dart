import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/cart_controller.dart';
import '../utils/app_colors.dart';
import 'checkout_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? productData;

  const ProductDetailsScreen({
    super.key,
    this.productData,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;
  int selectedSize = 7;

  bool _checkIsShoe(String name, String category) {
    final n = name.toLowerCase();
    final c = category.toLowerCase();

    return n.contains('shoe') ||
        n.contains('sneaker') ||
        n.contains('slipper') ||
        n.contains('boot') ||
        n.contains('footwear') ||
        c.contains('shoe') ||
        c.contains('footwear');
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);

    final product = widget.productData ?? {
      'id': '1',
      'name': 'Running Shoes',
      'price': 1299.0,
      'oldPrice': 2199.0,
      'discount': '40% OFF',
      'rating': 4.5,
      'reviews': '8k+',
      'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
    };

    final String id = (product['id'] ?? product['name'] ?? '').toString();
    final String name = (product['name'] ?? product['title'] ?? 'Product').toString();
    final String category = (product['category'] ?? product['category_name'] ?? '').toString();
    final double price = double.tryParse((product['price'] ?? 0).toString()) ?? 1299.0;
    final double oldPrice = double.tryParse((product['oldPrice'] ?? 0).toString()) ?? 2199.0;
    final String discount = (product['discount'] ?? '40% OFF').toString();
    final double rating = double.tryParse((product['rating'] ?? 4.5).toString()) ?? 4.5;
    final String reviews = (product['reviews'] ?? '8k+').toString();
    final String image = (product['image'] ?? product['image_url'] ?? 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600').toString();

    final bool isFavorite = cartController.isWishlisted(id);
    final bool isShoeItem = _checkIsShoe(name, category);
    final List<int> shoeSizes = const [6, 7, 8, 9, 10];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.darkNavy, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Product Details',
          style: TextStyle(
            color: AppColors.darkNavy,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Product Image Container
                  Stack(
                    children: [
                      Container(
                        height: 230,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF4FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Image.network(
                              image,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported_outlined, size: 80, color: AppColors.textMuted),
                            ),
                          ),
                        ),
                      ),

                      // Discount Badge on Top Left
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            discount,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Share & Wishlist Icons on Top Right
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.share_outlined, color: AppColors.darkNavy, size: 18),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                cartController.toggleWishlist(product);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  color: isFavorite ? AppColors.heartRed : AppColors.darkNavy,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Image Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: index == 0 ? 8 : 6,
                        height: index == 0 ? 8 : 6,
                        decoration: BoxDecoration(
                          color: index == 0 ? const Color(0xFF6366F1) : const Color(0xFFCBD5E1),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 16),

                  // Product Title
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkNavy,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Rating Row
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.accentYellow, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '$rating',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '($reviews reviews)',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Price & Discount Row
                  Row(
                    children: [
                      Text(
                        '₹${price.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AppColors.darkNavy,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (oldPrice > price)
                        Text(
                          '₹${oldPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textMuted,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE4E6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          discount,
                          style: const TextStyle(
                            color: Color(0xFFE11D48),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Available Offers
                  const Text(
                    'Available Offers',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkNavy,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Special Deal on $name',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: const [
                      Icon(Icons.check_circle, color: Color(0xFF10B981), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Extra 10% Cashback',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: const [
                      Icon(Icons.check_circle, color: Color(0xFF10B981), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Free Delivery',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark),
                      ),
                    ],
                  ),

                  // Select Size Section ONLY if the product is a Shoe item
                  if (isShoeItem) ...[
                    const SizedBox(height: 20),

                    const Text(
                      'Select Size',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkNavy,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: shoeSizes.map((sz) {
                        final bool isSelected = selectedSize == sz;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSize = sz;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFF8FAFC),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '$sz',
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.textDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom Action Bar (Add to Cart & Buy Now)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 10,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Add to Cart Button (Outlined)
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        cartController.addToCart(product, qty: quantity);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to Cart!'),
                            backgroundColor: AppColors.discountGreen,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          color: Color(0xFF4F46E5),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Buy Now Button (Solid Purple/Blue)
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        cartController.addToCart(product, qty: quantity);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckoutScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Buy Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
