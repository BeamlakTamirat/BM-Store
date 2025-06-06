import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CyberBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CyberBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(width: 1, color: AppColors.dividerColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              icon: Icons.store_rounded,
              label: "Shop",
              index: 0,
            ),
            _buildNavItem(
              context: context,
              icon: Icons.shopping_cart_rounded,
              label: "Cart",
              index: 1,
            ),
            _buildNavItem(
              context: context,
              icon: Icons.favorite_rounded,
              label: "Favorites",
              index: 2,
            ),
            _buildNavItem(
              context: context,
              icon: Icons.person_rounded,
              label: "Profile",
              index: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: AppConstants.shortDuration,
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? getColorForIndex(index).withOpacity(0.1)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color:
                    isSelected
                        ? getColorForIndex(index)
                        : AppColors.textSecondaryColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color:
                    isSelected
                        ? getColorForIndex(index)
                        : AppColors.textSecondaryColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getColorForIndex(int index) {
    switch (index) {
      case 0:
        return AppColors.primaryColor;
      case 1:
        return AppColors.infoColor;
      case 2:
        return AppColors.accentColor;
      case 3:
        return AppColors.tertiaryColor;
      default:
        return AppColors.primaryColor;
    }
  }
}
