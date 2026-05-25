import 'package:flutter/material.dart';
import 'package:clean_ios_app/config/app_colors.dart';
import 'package:clean_ios_app/config/images.dart';
import 'package:clean_ios_app/pages/profilepage/user_data.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
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
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = UserData.favoriteRecipes
        .where((recipe) => recipe.toLowerCase().contains(_searchQuery))
        .toList();

    return Scaffold(
      backgroundColor: primaryGreen,
      resizeToAvoidBottomInset: false,
      body: Column(
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
                    const SizedBox(width: 12),
                    const Text(
                      'Избранное',
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),

              child: filteredList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                        top: 30,
                        left: 16,
                        right: 16,
                      ),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        return _buildFavoriteItem(filteredList[index]);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteItem(String title) {
    return Container(
      width: double.infinity,
      height: 52,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: bgCardWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: labelPrimaryAndButton,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              setState(() {
                UserData.favoriteRecipes.remove(title);
              });
            },
            child: const Icon(Icons.star, color: primaryGreen, size: 24),
          ),
        ],
      ),
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
        starSlash,
        const SizedBox(height: 15),
        const Text(
          'Добавьте рецепты в избранное,\nчтобы они появились здесь',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: searchText,
            fontSize: 17,
            fontFamily: 'Inter',
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
