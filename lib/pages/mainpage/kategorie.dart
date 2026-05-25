import 'package:flutter/material.dart';
import 'package:clean_ios_app/config/images.dart';
import 'package:clean_ios_app/config/app_colors.dart';

import 'package:clean_ios_app/pages/mainpage/moloch.dart';
import 'package:clean_ios_app/pages/mainpage/meat.dart';
import 'package:clean_ios_app/pages/mainpage/bakaleya.dart';
import 'package:clean_ios_app/pages/mainpage/cheesseAndkolbasa.dart';
import 'package:clean_ios_app/pages/mainpage/fruitandvegetable.dart';
import 'package:clean_ios_app/pages/mainpage/specii.dart';
import 'package:clean_ios_app/pages/mainpage/sousiAndKonservi.dart';
import 'package:clean_ios_app/pages/mainpage/drinks.dart';
import 'package:clean_ios_app/pages/mainpage/sweets.dart';
import 'package:clean_ios_app/pages/mainpage/anothers.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final FocusNode _searchFocus = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  late final List<Map<String, dynamic>> _allCategories = [
    {'title': 'Молочка и яйца', 'image': molochnie},
    {'title': 'Мясо и рыба', 'image': meat},
    {'title': 'Бакалея', 'image': pasta},
    {'title': 'Сыры и колбасы', 'image': cheese},
    {'title': 'Овощи и фрукты', 'image': vegetable},
    {'title': 'Специи и добавки', 'image': spice},
    {'title': 'Соусы и консервы', 'image': sous},
    {'title': 'Напитки', 'image': drinks},
    {'title': 'Сладости', 'image': sweet},
    {'title': 'Другое', 'image': another},
  ];

  List<Map<String, dynamic>> _foundCategories = [];

  @override
  void initState() {
    super.initState();
    _foundCategories = _allCategories;
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

  void _runFilter(String enteredKeyword) {
    setState(() {
      if (enteredKeyword.isEmpty) {
        _foundCategories = _allCategories;
      } else {
        _foundCategories = _allCategories
            .where(
              (c) => c['title'].toLowerCase().contains(
                enteredKeyword.toLowerCase(),
              ),
            )
            .toList();
      }
    });
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
                          'Категории',
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
                    child: _buildGridContent(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridContent() {
    if (_foundCategories.isEmpty) {
      return const Center(
        child: Text(
          'Категория не найдена',
          style: TextStyle(color: searchText, fontSize: 17),
        ),
      );
    }

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 120),
      itemCount: _foundCategories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final category = _foundCategories[index];
        return GestureDetector(
          onTap: () {
            _navigateToCategory(category['title']);
          },
          child: _buildCategoryCard(category['title'], category['image']),
        );
      },
    );
  }

  void _navigateToCategory(String title) {
    Widget? nextPage;

    switch (title) {
      case 'Молочка и яйца':
        nextPage = const DairyPage();
        break;
      case 'Мясо и рыба':
        nextPage = const MeatPage();
        break;
      case 'Бакалея':
        nextPage = const GroceryPage();
        break;
      case 'Сыры и колбасы':
        nextPage = const CheesePage();
        break;
      case 'Овощи и фрукты':
        nextPage = const VegetablesPage();
        break;
      case 'Специи и добавки':
        nextPage = const SpicesPage();
        break;
      case 'Соусы и консервы':
        nextPage = const SaucesPage();
        break;
      case 'Напитки':
        nextPage = const DrinksPage();
        break;
      case 'Сладости':
        nextPage = const SweetsPage();
        break;
      case 'Другое':
        nextPage = const OtherPage();
        break;
    }

    if (nextPage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => nextPage!),
      ).then((_) => setState(() {}));
    }
  }

  Widget _buildCategoryCard(String title, dynamic imageData) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: bgCardWhite,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: (imageData is Image)
                ? Image(image: imageData.image, fit: BoxFit.cover)
                : (imageData is String)
                ? Image.asset(imageData, fit: BoxFit.cover)
                : Container(color: labelSeparator),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  labelPrimaryAndButton.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 12,
            right: 12,
            child: Text(
              title,
              style: const TextStyle(
                color: bgCardWhite,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
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
