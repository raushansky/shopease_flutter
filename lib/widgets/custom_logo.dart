import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ShopEaseLogo extends StatelessWidget {
  final double scale;
  final bool showTagline;

  const ShopEaseLogo({
    super.key,
    this.scale = 1.0,
    this.showTagline = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Shopping Bag with Cart Icon inside
        Container(
          width: 90 * scale,
          height: 90 * scale,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF818CF8), Color(0xFF4F46E5), Color(0xFF3730A3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(26 * scale),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.35),
                blurRadius: 18 * scale,
                offset: Offset(0, 8 * scale),
              ),
            ],
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_rounded,
                  size: 54 * scale,
                  color: Colors.white,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8 * scale),
                  child: Icon(
                    Icons.shopping_cart_rounded,
                    size: 26 * scale,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12 * scale),

        // Brand Name: ShopEase
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Shop',
                style: TextStyle(
                  color: AppColors.darkNavy,
                  fontSize: 34 * scale,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              TextSpan(
                text: 'Ease',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 34 * scale,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),

        if (showTagline) ...[
          SizedBox(height: 6 * scale),
          Text(
            'Shop Smart. Live Better.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14 * scale,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ],
    );
  }
}
