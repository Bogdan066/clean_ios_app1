import 'package:flutter/material.dart';
import 'package:clean_ios_app/config/images.dart';
import 'package:clean_ios_app/config/app_colors.dart';
import 'package:clean_ios_app/pages/mainpage/kategorie.dart';
import 'package:clean_ios_app/pages/profilepage/profile.dart';
import 'package:clean_ios_app/cartState.dart';
import 'package:clean_ios_app/pages/recepti/vserecepti.dart';

class MainPage extends StatefulWidget {
  final String userName;
  final String userEmail;

  const MainPage({super.key, required this.userName, required this.userEmail});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final FocusNode _searchFocus = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(() {
      setState(() {
        _isSearching = _searchFocus.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _selectedIndex == 0 ? primaryGreen : primaryGreen,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildCurrentPage(),
          Positioned(bottom: 0, left: 0, right: 0, child: _buildFooter()),
        ],
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildFridgeBody();
      case 1:
        return RecipesPage(
          userName: widget.userName,
          userEmail: widget.userEmail,
        );
      case 2:
        return ProfilePage(
          userName: widget.userName,
          userEmail: widget.userEmail,
        );
      default:
        return _buildFridgeBody();
    }
  }

  Widget _buildFridgeBody() {
    final allProducts = CartState().addedProducts;
    final filteredProducts = allProducts.where((product) {
      return product.name.toLowerCase().contains(_searchQuery);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 52, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Мой холодильник',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: bgCardWhite,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 40),
              _buildSearchField(),
            ],
          ),
        ),
        const SizedBox(height: 50),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: bgAppMain,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: allProducts.isEmpty
                ? _buildEmptyState()
                : _buildProductList(filteredProducts),
          ),
        ),
      ],
    );
  }

  Widget _buildProductList(List<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 25,
            bottom: 15,
            right: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Продукты в наличии:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: labelSecondary,
                  fontFamily: 'Inter',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoriesPage(),
                    ),
                  ).then((_) => setState(() {}));
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: bgCardWhite, size: 24),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: products.isEmpty && _searchQuery.isNotEmpty
              ? const Center(
                  child: Text(
                    'Ничего не найдено',
                    style: TextStyle(color: searchText, fontSize: 17),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 110,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: bgCardWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.fastfood,
                            color: primaryGreen,
                            size: 24,
                          ),
                          const SizedBox(width: 15),
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                CartState().toggleProduct(product.name);
                              });
                            },
                            child: const Icon(
                              Icons.delete_outline,
                              color: error,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      width: double.infinity,
      height: 43,
      decoration: BoxDecoration(
        color: bgCardWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocus,
        textInputAction: TextInputAction.search,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Поиск',
          hintStyle: TextStyle(
            color: searchText.withOpacity(0.5),
            fontSize: 17,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          border: InputBorder.none,
          suffixIcon: _isSearching
              ? IconButton(
                  icon: const Icon(Icons.close, color: searchText, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                    _searchFocus.unfocus();
                  },
                )
              : Padding(padding: const EdgeInsets.all(12.0), child: poisk),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        fridgeSad,
        const SizedBox(height: 10),
        const Text(
          'В холодильнике пусто.\nДобавьте продукты',
          textAlign: TextAlign.center,
          style: TextStyle(color: searchText, fontSize: 17),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoriesPage()),
            ).then((_) => setState(() {}));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            elevation: 0,
            fixedSize: const Size(265, 49),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Добавить продукты',
            style: TextStyle(
              color: bgCardWhite,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildColoredIcon(Widget iconWidget, Color color) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      child: iconWidget,
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      height: 90,
      padding: const EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
        color: bgCardWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () => setState(() => _selectedIndex = 0),
            icon: _buildColoredIcon(
              fridge,
              _selectedIndex == 0 ? primaryGreen : searchText,
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _selectedIndex = 1),
            icon: _buildColoredIcon(
              cookHat,
              _selectedIndex == 1 ? primaryGreen : searchText,
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _selectedIndex = 2),
            icon: _buildColoredIcon(
              profile,
              _selectedIndex == 2 ? primaryGreen : searchText,
            ),
          ),
        ],
      ),
    );
  }
}
