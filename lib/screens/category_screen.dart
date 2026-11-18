import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/cart_controller.dart';
import '../utils/app_colors.dart';
import 'product_list_screen.dart';

class CategoryScreen extends StatefulWidget {
  final bool isTab;

  const CategoryScreen({super.key, this.isTab = false});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _sampleCategories = const [
    {
      'title': 'Fashion',
      'count': '(120+)',
      'image': 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=300',
    },
    {
      'title': 'Electronics',
      'count': '(150+)',
      'image': 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=300',
    },
    {
      'title': 'Home & Living',
      'count': '(100+)',
      'image': 'https://images.unsplash.com/photo-1580481072645-022f9a6d1273?w=300',
    },
    {
      'title': 'Home & Living',
      'count': '(90+)',
      'image': 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=300',
    },
    {
      'title': 'Beauty',
      'count': '(100+)',
      'image': 'https://images.unsplash.com/photo-1587654780291-39c9404d746b?w=300',
    },
    {
      'title': 'Beauty',
      'count': '(80+)',
      'image': 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=300',
    },
    {
      'title': 'Sports',
      'count': '(50+)',
      'image': 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?w=300',
    },
    {
      'title': 'Toys',
      'count': '(70+)',
      'image': 'https://images.unsplash.com/photo-1587654780291-39c9404d746b?w=300',
    },
    {
      'title': 'More',
      'count': '(50+)',
      'isMore': true,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);
    final cartCount = cartController.cartCount;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: !widget.isTab,
        leading: !widget.isTab
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.darkNavy, size: 20),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text(
          'Categories',
          style: TextStyle(
            color: AppColors.darkNavy,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.darkNavy, size: 24),
                onPressed: () {},
              ),
              if (cartCount > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // Search Categories Input Bar
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search categories...',
                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 22),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 3-Column Grid of Categories
              Expanded(
                child: GridView.builder(
                  itemCount: _sampleCategories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (context, index) {
                    final cat = _sampleCategories[index];
                    final String title = cat['title'];
                    final String count = cat['count'];
                    final bool isMore = cat['isMore'] == true;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductListScreen(categoryName: title),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: isMore
                                    ? const Center(
                                        child: Icon(
                                          Icons.more_horiz_rounded,
                                          size: 40,
                                          color: AppColors.darkNavy,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          cat['image'] ?? '',
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) =>
                                              const Icon(Icons.category_rounded, size: 40, color: Color(0xFF6366F1)),
                                        ),
                                      ),
                              ),
                            ),
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textDark,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              count,
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
