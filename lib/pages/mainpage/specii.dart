import 'package:flutter/material.dart';
import 'package:clean_ios_app/config/images.dart';
import 'package:clean_ios_app/config/app_colors.dart';
import 'package:clean_ios_app/cartState.dart';

class SpicesPage extends StatefulWidget {
  const SpicesPage({super.key});

  @override
  State<SpicesPage> createState() => _SpicesPageState();
}

class _SpicesPageState extends State<SpicesPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  bool _isSearching = false;

  final List<Map<String, dynamic>> _allProducts = [
    {'name': 'Черный перец (молотый)', 'isAdded': false},
    {'name': 'Красный перец (паприка)', 'isAdded': false},
    {'name': 'Соль морская', 'isAdded': false},
    {'name': 'Куркума', 'isAdded': false},
    {'name': 'Зира (кумин)', 'isAdded': false},
    {'name': 'Смесь итальянских трав', 'isAdded': false},
    {'name': 'Дрожжи', 'isAdded': false},
    {'name': 'Разрыхлитель теста', 'isAdded': false},
  ];

  List<Map<String, dynamic>> _foundProducts = [];

  @override
  void initState() {
    super.initState();
    _foundProducts = _allProducts;

    _searchFocus.addListener(() {
      setState(() {
        _isSearching = _searchFocus.hasFocus;
      });
    });

    for (var product in _allProducts) {
      product['isAdded'] = CartState().addedProducts.any(
        (p) => p.name == product['name'],
      );
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allProducts;
    } else {
      results = _allProducts
          .where(
            (product) => product['name'].toLowerCase().contains(
              enteredKeyword.toLowerCase(),
            ),
          )
          .toList();
    }

    setState(() {
      _foundProducts = results;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryGreen,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 52, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: arrowBackLeft,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Специи и добавки',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: bgCardWhite,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
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
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: _buildProductList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    if (_foundProducts.isEmpty) {
      return const Center(
        child: Text(
          'Ничего не найдено',
          style: TextStyle(color: searchText, fontSize: 17),
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 120),
      itemCount: _foundProducts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 30),
      itemBuilder: (context, index) => _buildProductCard(index),
    );
  }

  Widget _buildProductCard(int index) {
    final product = _foundProducts[index];
    return Container(
      width: double.infinity,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: bgCardWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 32),
          Expanded(
            child: Center(
              child: Text(
                product['name'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  color: labelPrimaryAndButton,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                product['isAdded'] = !product['isAdded'];
                CartState().toggleProduct(product['name']);
              });
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: product['isAdded'] ? search : primaryGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(
                product['isAdded'] ? Icons.check : Icons.add,
                color: bgCardWhite,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 43,
      decoration: BoxDecoration(
        color: bgCardWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocus,
        onChanged: _runFilter,
        decoration: InputDecoration(
          hintText: 'Поиск',
          hintStyle: TextStyle(
            color: searchText.withOpacity(0.5),
            fontSize: 17,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          suffixIcon: _isSearching
              ? IconButton(
                  icon: const Icon(Icons.close, color: searchText, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    _runFilter('');
                    _searchFocus.unfocus();
                  },
                )
              : Padding(padding: const EdgeInsets.all(12.0), child: poisk),
        ),
      ),
    );
  }
}
