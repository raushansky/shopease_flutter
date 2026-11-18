import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/cart_controller.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';
import 'product_details_screen.dart';
import 'category_screen.dart';
import 'product_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  bool _isLoading = true;

  int _currentBannerPage = 0;
  late final PageController _bannerPageController = PageController();
  Timer? _bannerTimer;

  final List<Map<String, dynamic>> _sampleBestDeals = const [
    {
      'id': 'bd_1',
      'name': 'Building Blocks Set',
      'price': 799.0,
      'oldPrice': 999.0,
      'discount': '20% OFF',
      'rating': 4.5,
      'reviews': '12k+',
      'image': 'https://images.unsplash.com/photo-1587654780291-39c9404d746b?w=500',
    },
    {
      'id': 'bd_2',
      'name': 'Cricket Bat',
      'price': 1599.0,
      'oldPrice': 1999.0,
      'discount': '20% OFF',
      'rating': 4.5,
      'reviews': '8k+',
      'image': 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?w=500',
    },
    {
      'id': 'bd_3',
      'name': 'Non-Slip Yoga Mat',
      'price': 999.0,
      'oldPrice': 1299.0,
      'discount': '23% OFF',
      'rating': 4.5,
      'reviews': '10k+',
      'image': 'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=500',
    },
    {
      'id': 'bd_4',
      'name': 'Compact Coffee Mug',
      'price': 2799.0,
      'oldPrice': 3499.0,
      'discount': '20% OFF',
      'rating': 4.5,
      'reviews': '5k+',
      'image': 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=500',
    },
  ];

  final List<Map<String, dynamic>> _bannerList = const [
    {
      'titleStart': 'Min ',
      'titleHighlight': '40% OFF',
      'subtitle': 'On Top Fashion Brands',
      'button': 'Grab Deal',
      'gradient': [Color(0xFFFF5252), Color(0xFFFF7A00)],
      'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
    },
    {
      'titleStart': 'Big Saving\nUp to ',
      'titleHighlight': '70% OFF',
      'subtitle': 'On Electronics & Gadgets',
      'button': 'Shop Now',
      'gradient': [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
      'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
    },
    {
      'titleStart': 'Special Offer\nFlat ',
      'titleHighlight': '50% OFF',
      'subtitle': 'Smart Watches & Accessories',
      'button': 'Explore Deals',
      'gradient': [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
      'image': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
    },
  ];

  final List<Map<String, dynamic>> _categoryCircles = const [
    {
      'title': 'Fashion',
      'icon': Icons.checkroom_rounded,
      'bgColor': Color(0xFFF3E8FF),
      'iconColor': Color(0xFF9333EA),
    },
    {
      'title': 'Electronics',
      'icon': Icons.laptop_chromebook_rounded,
      'bgColor': Color(0xFFDBEAFE),
      'iconColor': Color(0xFF2563EB),
    },
    {
      'title': 'Home',
      'icon': Icons.home_rounded,
      'bgColor': Color(0xFFFFEDD5),
      'iconColor': Color(0xFFEA580C),
    },
    {
      'title': 'More',
      'icon': Icons.grid_view_rounded,
      'bgColor': Color(0xFFF1F5F9),
      'iconColor': Color(0xFF64748B),
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _searchController.addListener(_onSearchChanged);
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerPageController.hasClients) {
        final nextPage = (_currentBannerPage + 1) % _bannerList.length;
        _bannerPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerPageController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    try {
      final data = await ApiService.getProducts();
      if (!mounted) return;

      final apiList = List<Map<String, dynamic>>.from(data);
      List<Map<String, dynamic>> resolvedList = [];

      for (var p in apiList) {
        final item = Map<String, dynamic>.from(p);
        String name = (item['name'] ?? item['title'] ?? '').toString();
        String category = (item['category_name'] ?? item['category'] ?? '').toString();
        String rawImg = (item['image_url'] ?? item['image'] ?? item['imageUrl'] ?? '').toString();

        item['image'] = ProductModel.getValidImageUrl(rawImg, name, category);
        resolvedList.add(item);
      }

      setState(() {
        _products = resolvedList.isNotEmpty ? resolvedList : _sampleBestDeals;
        _filteredProducts = List.from(_products);
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _products = List.from(_sampleBestDeals);
        _filteredProducts = List.from(_products);
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = List.from(_products);
      } else {
        _filteredProducts = _products.where((p) {
          final name = (p['name'] ?? '').toString().toLowerCase();
          final category = (p['category'] ?? '').toString().toLowerCase();
          return name.contains(query) || category.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchProducts,
          color: AppColors.primary,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Location & Notification Row (Matching Reference Screenshot)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: const [
                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.black,
                            size: 26,
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Patna, Bihar',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.darkNavy,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.darkNavy,
                        size: 22,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 2. Rounded Search Bar Input (Matching Reference Screenshot)
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF94A3B8),
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search products...',
                            hintStyle: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 3. Offer Banner Slider (Symmetric Left/Right Margins)
                Column(
                  children: [
                    SizedBox(
                      height: 155,
                      child: PageView.builder(
                        controller: _bannerPageController,
                        itemCount: _bannerList.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentBannerPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final banner = _bannerList[index];
                          final List<Color> colors = List<Color>.from(banner['gradient']);

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: colors,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colors.first.withValues(alpha: 0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: banner['titleStart'],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: banner['titleHighlight'],
                                                  style: const TextStyle(
                                                    color: Color(0xFFFFEB3B),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          banner['subtitle'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                banner['button'],
                                                style: const TextStyle(
                                                  color: AppColors.darkNavy,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              const Icon(Icons.arrow_forward_rounded, color: AppColors.darkNavy, size: 13),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 135,
                                  padding: const EdgeInsets.all(8),
                                  child: Image.network(
                                    banner['image'],
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Banner Dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _bannerList.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          height: 7,
                          width: 7,
                          decoration: BoxDecoration(
                            color: _currentBannerPage == index
                                ? const Color(0xFF6366F1)
                                : const Color(0xFFCBD5E1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Categories Circular Icons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _categoryCircles.map((cat) {
                    return GestureDetector(
                      onTap: () {
                        if (cat['title'] == 'More') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CategoryScreen()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductListScreen(categoryName: cat['title']),
                            ),
                          );
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              color: cat['bgColor'],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              cat['icon'],
                              color: cat['iconColor'],
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cat['title'],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 28),

                // Best Deals Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Best Deals ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkNavy,
                          ),
                        ),
                        Text('🔥', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductListScreen(categoryName: 'Best Deals'),
                          ),
                        );
                      },
                      child: Row(
                        children: const [
                          Text(
                            'See All ',
                            style: TextStyle(
                              color: Color(0xFF6366F1),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.arrow_forward_rounded, color: Color(0xFF6366F1), size: 16),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Products Grid (Matching Screenshot)
                if (_isLoading)
                  const SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                      final double oldPrice = double.tryParse((product['oldPrice'] ?? 0).toString()) ?? (price * 1.25);
                      final String discount = (product['discount'] ?? '20% OFF').toString();

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
                              // Product Image & Wishlist Button
                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
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
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            '₹${price.toStringAsFixed(0)}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900,
                                              color: AppColors.darkNavy,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          if (oldPrice > price)
                                            Text(
                                              '₹${oldPrice.toStringAsFixed(0)}',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.textMuted,
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            ),
                                          const SizedBox(width: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFE4E6),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              discount,
                                              style: const TextStyle(
                                                color: Color(0xFFE11D48),
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Row(
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
                                          const SizedBox(width: 2),
                                          Text(
                                            '(${product['reviews'] ?? '12k+'})',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // ADD TO CART BUTTON ON THE CARD
                                    SizedBox(
                                      width: double.infinity,
                                      height: 36,
                                      child: ElevatedButton.icon(
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
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 16),
                                        label: const Text(
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

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  );
  }
}
