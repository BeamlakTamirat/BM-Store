import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../constants/app_constants.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_grid_item.dart';
import 'cart_screen.dart';
import 'login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    debugPrint('Initializing data...');
    try {
      await Provider.of<CartProvider>(context, listen: false).loadCartItems();
      // Products are automatically loaded in the ProductProvider constructor
    } catch (e) {
      debugPrint('Error initializing data: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title:
            _isSearchFocused
                ? TextField(
                  controller: _searchController,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                  ),
                  cursorColor: AppColors.primaryColor,
                  textAlign: TextAlign.left,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    hintStyle: TextStyle(color: AppColors.textSecondaryColor),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.defaultRadius,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    isDense: true,
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                  ),
                  onChanged: (value) {
                    productProvider.setSearchQuery(value);
                  },
                )
                : Text(
                  'BM Store',
                  style: AppTextStyles.headline3.copyWith(color: Colors.white),
                ),
        actions: [
          IconButton(
            icon: Icon(_isSearchFocused ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearchFocused = !_isSearchFocused;
                if (!_isSearchFocused) {
                  _searchController.clear();
                  productProvider.setSearchQuery('');
                }
              });
            },
          ),
          badges.Badge(
            position: badges.BadgePosition.topEnd(top: 5, end: 5),
            badgeContent: Text(
              '${cartProvider.itemCount}',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            showBadge: cartProvider.itemCount > 0,
            badgeStyle: const badges.BadgeStyle(
              badgeColor: AppColors.accentColor,
              padding: EdgeInsets.all(5),
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.account_circle_outlined),
            itemBuilder:
                (context) => [
                  if (!authProvider.isAuthenticated)
                    PopupMenuItem(
                      child: const Text('Login'),
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 100), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        });
                      },
                    )
                  else ...[
                    PopupMenuItem(
                      child: Text('Hello, ${authProvider.user?.email}'),
                      enabled: false,
                    ),
                    PopupMenuItem(
                      child: const Text('Logout'),
                      onTap: () {
                        authProvider.logout();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Logged out successfully'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => productProvider.retry(),
        color: AppColors.primaryColor,
        child: Column(
          children: [
            // Categories section (if available)
            if (productProvider.categories.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Categories', style: AppTextStyles.headline3),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 40,
                      child: _buildCategoryList(productProvider),
                    ),
                  ],
                ),
              ),

            // Product count section (if not loading or error)
            if (!productProvider.isError && !productProvider.isLoading)
              Padding(
                padding: const EdgeInsets.all(AppConstants.smallPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      productProvider.selectedCategory.isEmpty
                          ? 'All Products'
                          : productProvider.selectedCategory,
                      style: AppTextStyles.headline3,
                    ),
                    Text(
                      '${productProvider.filteredProducts.length} items',
                      style: AppTextStyles.bodyText2.copyWith(
                        color: AppColors.textLightColor,
                      ),
                    ),
                  ],
                ),
              ),

            // Main content area - expanded to fill remaining space
            Expanded(child: _buildMainContent(productProvider, context)),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(
    ProductProvider productProvider,
    BuildContext context,
  ) {
    if (productProvider.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primaryColor),
            const SizedBox(height: 16),
            Text('Loading products...', style: AppTextStyles.bodyText1),
          ],
        ),
      );
    } else if (productProvider.isError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
              color: AppColors.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: AppTextStyles.headline3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Unable to load products. Please check your internet connection and try again.',
                style: AppTextStyles.bodyText1.copyWith(
                  color: AppColors.textLightColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => productProvider.retry(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (productProvider.filteredProducts.isEmpty &&
        productProvider.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 60,
              color: AppColors.primaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text('No products found', style: AppTextStyles.headline3),
            const SizedBox(height: 8),
            Text(
              'Pull down to refresh',
              style: AppTextStyles.bodyText1.copyWith(
                color: AppColors.textLightColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else if (productProvider.filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 60,
              color: AppColors.textLightColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No products match your search',
              style: AppTextStyles.headline3,
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term or category',
              style: AppTextStyles.bodyText1.copyWith(
                color: AppColors.textLightColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      // Products grid
      return Padding(
        padding: const EdgeInsets.all(AppConstants.smallPadding),
        child: MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          itemCount: productProvider.filteredProducts.length,
          itemBuilder: (context, index) {
            return ProductGridItem(
              product: productProvider.filteredProducts[index],
            );
          },
        ),
      );
    }
  }

  Widget _buildCategoryList(ProductProvider productProvider) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: productProvider.categories.length + 1,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Text(
              index == 0 ? 'All' : productProvider.categories[index - 1],
              style: TextStyle(
                color:
                    productProvider.selectedCategory.isEmpty && index == 0 ||
                            index > 0 &&
                                productProvider.selectedCategory ==
                                    productProvider.categories[index - 1]
                        ? Colors.white
                        : AppColors.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            selected:
                productProvider.selectedCategory.isEmpty && index == 0 ||
                index > 0 &&
                    productProvider.selectedCategory ==
                        productProvider.categories[index - 1],
            onSelected: (selected) {
              if (selected) {
                productProvider.setSelectedCategory(
                  index == 0 ? '' : productProvider.categories[index - 1],
                );
              }
            },
            backgroundColor: AppColors.secondaryColor,
            selectedColor: AppColors.primaryColor,
            checkmarkColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        );
      },
    );
  }
}
