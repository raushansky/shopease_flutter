import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/cart_controller.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';
import 'product_details_screen.dart';

class ProductListScreen extends StatefulWidget {
  final String categoryName;

  const ProductListScreen({
    super.key,
    this.categoryName = 'Fashion',
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String selectedFilter = 'All';
  final List<String> filterChips = const ['All', 'Men', 'Women', 'Kids'];

  List<Map<String, dynamic>> _allProducts = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  bool _isLoading = true;

  bool get _isFashionCategory {
    final cat = widget.categoryName.toLowerCase();
    return cat == 'fashion' || cat.contains('clothing');
  }

  // Curated Fallback Products per Category
  final Map<String, List<Map<String, dynamic>>> _curatedCategoryProducts = {
    'music': [
      {
        'id': 'mus_1',
        'name': 'Acoustic Guitar',
        'price': 4999.0,
        'oldPrice': 6999.0,
        'rating': 4.7,
        'category': 'Music',
        'image': 'https://images.unsplash.com/photo-1510915361894-db8b60106cb1?w=400',
        'description': 'Premium 41-inch acoustic guitar with rich sound and comfortable neck.',
      },
      {
        'id': 'mus_2',
        'name': 'Studio Headphones',
        'price': 2499.0,
        'oldPrice': 3999.0,
        'rating': 4.6,
        'category': 'Music',
        'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
        'description': 'Over-ear studio monitoring headphones with deep bass and clear audio.',
      },
      {
        'id': 'mus_3',
        'name': 'USB Condenser Mic',
        'price': 1899.0,
        'oldPrice': 2999.0,
        'rating': 4.5,
        'category': 'Music',
        'image': 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400',
        'description': 'High fidelity condenser microphone ideal for vocals, podcasting, and streaming.',
      },
      {
        'id': 'mus_4',
        'name': 'Electric Keyboard',
        'price': 8999.0,
        'oldPrice': 11999.0,
        'rating': 4.8,
        'category': 'Music',
        'image': 'https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?w=400',
        'description': '61-key piano keyboard with touch sensitive keys and multiple sound effects.',
      },
    ],
    'men': [
      {
        'id': 'men_1',
        'name': 'Men T-Shirt',
        'price': 499.0,
        'oldPrice': 999.0,
        'rating': 4.4,
        'category': "Men's Fashion",
        'image': 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=400',
      },
      {
        'id': 'men_2',
        'name': 'Jacket',
        'price': 1299.0,
        'oldPrice': 2499.0,
        'rating': 4.6,
        'category': "Men's Fashion",
        'image': 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400',
      },
      {
        'id': 'men_3',
        'name': 'Jeans',
        'price': 999.0,
        'oldPrice': 1999.0,
        'rating': 4.4,
        'category': "Men's Fashion",
        'image': 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=400',
      },
    ],
    'women': [
      {
        'id': 'wom_1',
        'name': 'Women Dress',
        'price': 799.0,
        'oldPrice': 1499.0,
        'rating': 4.5,
        'category': "Women's Fashion",
        'image': 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=400',
      },
      {
        'id': 'wom_2',
        'name': 'Woman Shawl',
        'price': 149.0,
        'oldPrice': 299.0,
        'rating': 4.1,
        'category': "Women's Fashion",
        'image': 'https://images.unsplash.com/photo-1608234807905-4466023792f5?w=400',
      },
    ],
    'home': [
      {
        'id': 'hm_1',
        'name': 'Ergonomic Office Chair',
        'price': 3499.0,
        'oldPrice': 5999.0,
        'rating': 4.8,
        'category': 'Home & Living',
        'image': 'https://images.unsplash.com/photo-1580481072645-022f9a6d1273?w=400',
      },
      {
        'id': 'hm_2',
        'name': 'Modern Desk Lamp',
        'price': 899.0,
        'oldPrice': 1499.0,
        'rating': 4.5,
        'category': 'Home & Living',
        'image': 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=400',
      },
    ],
    'books': [
      {
        'id': 'bk_1',
        'name': 'Flutter & Dart Guide',
        'price': 499.0,
        'oldPrice': 899.0,
        'rating': 4.9,
        'category': 'Books',
        'image': 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400',
      },
      {
        'id': 'bk_2',
        'name': 'Atomic Habits',
        'price': 399.0,
        'oldPrice': 699.0,
        'rating': 4.8,
        'category': 'Books',
        'image': 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400',
      },
    ],
    'beauty': [
      {
        'id': 'bty_1',
        'name': 'Organic Skincare Set',
        'price': 1199.0,
        'oldPrice': 1999.0,
        'rating': 4.6,
        'category': 'Beauty',
        'image': 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=400',
      },
      {
        'id': 'bty_2',
        'name': 'Matte Lipstick Pack',
        'price': 599.0,
        'oldPrice': 999.0,
        'rating': 4.5,
        'category': 'Beauty',
        'image': 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=400',
      },
    ],
    'sports': [
      {
        'id': 'spt_1',
        'name': 'Nike Running Shoes',
        'price': 2999.0,
        'oldPrice': 4999.0,
        'rating': 4.5,
        'category': 'Sports',
        'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
      },
      {
        'id': 'spt_2',
        'name': 'Yoga Mat',
        'price': 699.0,
        'oldPrice': 1299.0,
        'rating': 4.4,
        'category': 'Sports',
        'image': 'https://images.unsplash.com/photo-1592432678016-e910b452f9a2?w=400',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final data = await ApiService.getProducts();
      if (!mounted) return;
      setState(() {
        _allProducts = List<Map<String, dynamic>>.from(data);
        _applyFilter();
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _applyFilter();
        _isLoading = false;
      });
    }
  }

  void _applyFilter() {
    final cat = widget.categoryName.toLowerCase().trim();

    // 1. Check curated items first
    for (var key in _curatedCategoryProducts.keys) {
      if (cat.contains(key) || key.contains(cat)) {
        _filteredProducts = List.from(_curatedCategoryProducts[key]!);
        return;
      }
    }

    // 2. Filter from API products
    if (cat.isEmpty || cat == 'all' || cat == 'best deals' || cat == 'fashion') {
      _filteredProducts = List.from(_allProducts);
    } else {
      _filteredProducts = _allProducts.where((p) {
        final pCat = (p['category'] ?? '').toString().toLowerCase();
        final pName = (p['name'] ?? '').toString().toLowerCase();
        return pCat.contains(cat) || cat.contains(pCat) || pName.contains(cat);
      }).toList();
    }

    // 3. Fallback if still empty so "No product found" never appears
    if (_filteredProducts.isEmpty) {
      _filteredProducts = _allProducts.isNotEmpty ? List.from(_allProducts) : [
        {
          'id': 'def_1',
          'name': '${widget.categoryName} Special Item',
          'price': 1499.0,
          'oldPrice': 2499.0,
          'rating': 4.5,
          'category': widget.categoryName,
          'image': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
          'description': 'High quality product under ${widget.categoryName} category.',
        }
      ];
    }

    // Apply Sub-Category Filter Chip if Fashion Category
    if (_isFashionCategory && selectedFilter != 'All') {
      _filteredProducts = _filteredProducts.where((p) {
        final pName = (p['name'] ?? '').toString().toLowerCase();
        final pCat = (p['category'] ?? '').toString().toLowerCase();
        final filter = selectedFilter.toLowerCase();
        return pName.contains(filter) || pCat.contains(filter);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);

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
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: AppColors.darkNavy,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: AppColors.darkNavy, size: 24),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips Row (ONLY SHOWN IF FASHION CATEGORY)
          if (_isFashionCategory) ...[
            SizedBox(
              height: 46,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filterChips.length,
                itemBuilder: (context, index) {
                  final chip = filterChips[index];
                  final isSelected = selectedFilter == chip;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = chip;
                        _applyFilter();
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.inputBg,
                        borderRadius: BorderRadius.circular(24),
                        border: isSelected ? null : Border.all(color: AppColors.borderColor),
                      ),
                      child: Center(
                        child: Text(
                          chip,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textDark,
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Product Cards Grid
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.58,
                    ),
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      final id = (product['id'] ?? product['name'] ?? '').toString();
                      final isWish = cartController.isWishlisted(id);

                      final double price = double.tryParse((product['price'] ?? 0).toString()) ?? 0.0;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(productData: product),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0A000000),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image & Wishlist Heart Icon
                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF8FAFC),
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                        child: Image.network(
                                          product['image'] ?? '',
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                              const Icon(Icons.image_not_supported_outlined, color: AppColors.textMuted),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 6,
                                      right: 6,
                                      child: GestureDetector(
                                        onTap: () {
                                          cartController.toggleWishlist(product);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0x1A000000),
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            isWish ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                            size: 18,
                                            color: isWish ? AppColors.heartRed : const Color(0xFF64748B),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Info Details
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['name'] ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₹${price.toStringAsFixed(1)}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.darkNavy,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.star_rounded, color: AppColors.accentYellow, size: 14),
                                        const SizedBox(width: 2),
                                        Text(
                                          '${product['rating'] ?? 4.5}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    // ADD TO CART BUTTON ON THE CARD
                                    SizedBox(
                                      width: double.infinity,
                                      height: 34,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          cartController.addToCart(product);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Added to Cart!'),
                                              backgroundColor: AppColors.discountGreen,
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF5046E5),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text(
                                          'Add to Cart',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
