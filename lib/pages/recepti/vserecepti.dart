import 'package:clean_ios_app/pages/profilepage/user_data.dart';
import 'package:clean_ios_app/pages/recepti/borsh.dart';
import 'package:flutter/material.dart';
import 'package:clean_ios_app/config/app_colors.dart';
import 'package:clean_ios_app/config/images.dart';
import 'package:clean_ios_app/pages/recepti/balanieza.dart';
import 'package:clean_ios_app/pages/recepti/pelemeni.dart';
import 'package:clean_ios_app/pages/recepti/tiramisu.dart';
import 'package:clean_ios_app/cartState.dart';

class RecipesPage extends StatefulWidget {
  final String userName;
  final String userEmail;

  const RecipesPage({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  bool _showAll = true;

  final List<Map<String, dynamic>> recipes = [
    {
      'name': 'Паста болоньезе',
      'time': '2 часа',
      'img': pastaBolonieza,
      'keywords': [
        'спагетти',
        'фарш',
        'лук',
        'чеснок',
        'томаты в собственном соку',
        'вино',
        'сыр',
        'морковь',
        'сельдерей',
        'оливковое масло',
        'соль',
        'перец',
        'лавровый лист',
        'сушенный базилик',
        'орегано',
      ],
      'page': const RecipeDetailPage(),
    },
    {
      'name': 'Борщ',
      'time': '2 часа',
      'img': borsh,
      'keywords': [
        'говядина',
        'свёкла',
        'картофель',
        'капуста',
        'морковь',
        'репчатый лук',
        'томатная паста',
        'вода',
        'лавровый лист',
        'душистый перец',
        'соль',
        'оливковое масло',
        'сахар',
        'уксус 9%',
        'растительное масло',
        'чеснок',
        'укроп',
      ],
      'page': const BorshDetailPage(),
    },
    {
      'name': 'Пельмени',
      'time': '2 часа',
      'img': pelemeni,
      'keywords': [
        'вода',
        'яйцо',
        'соль',
        'говядина',
        'свинина',
        'лук репчатый',
        'чеснок',
        'перец чёрный',
      ],
      'page': const PelmeniDetailPage(),
    },
    {
      'name': 'Тирамису',
      'time': '8 часов',
      'img': tiramisu,
      'keywords': [
        'яйца',
        'маскарпоне',
        'кофе',
        'соль',
        'сахар',
        'кофе',
        'коньяк',
        'какао',
        'савоярди',
      ],
      'page': const TiramisuDetailPage(),
    },
  ];

  List<Map<String, dynamic>> _filteredRecipes = [];

  @override
  void initState() {
    super.initState();
    _filteredRecipes = recipes;
  }

  int _countMatches(List<String> keywords) {
    final fridgeProducts = CartState().addedProducts
        .map((p) => p.name.toLowerCase().trim())
        .toList();

    int count = 0;
    for (var word in keywords) {
      String keyword = word.toLowerCase().trim();
      if (fridgeProducts.any(
        (prod) => prod.contains(keyword) || keyword.contains(prod),
      )) {
        count++;
      }
    }
    return count;
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      if (enteredKeyword.isEmpty) {
        _filteredRecipes = recipes;
      } else {
        _filteredRecipes = recipes
            .where(
              (recipe) => recipe['name'].toLowerCase().contains(
                enteredKeyword.toLowerCase(),
              ),
            )
            .toList();
      }
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
    List<Map<String, dynamic>> displayList = [];

    if (_showAll) {
      displayList = _filteredRecipes.map((r) {
        var recipeWithMatches = Map<String, dynamic>.from(r);
        recipeWithMatches['matches'] = _countMatches(r['keywords']);
        return recipeWithMatches;
      }).toList();
    } else {
      displayList = recipes
          .map((r) {
            var recipeWithMatches = Map<String, dynamic>.from(r);
            recipeWithMatches['matches'] = _countMatches(r['keywords']);
            return recipeWithMatches;
          })
          .where((r) => (r['matches'] as int) > 0)
          .toList();

      displayList.sort(
        (a, b) => (b['matches'] as int).compareTo(a['matches'] as int),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 52, left: 16, right: 16),
          child: Text(
            'Рецепты',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: bgCardWhite,
              fontFamily: 'Inter',
            ),
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSearchField(),
        ),
        const SizedBox(height: 50),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: bgAppMain,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 25),
                _buildAnimatedToggle(),
                const SizedBox(height: 30),
                Expanded(
                  child: displayList.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 100,
                          ),
                          itemCount: displayList.length,
                          itemBuilder: (context, index) {
                            final recipeData = displayList[index];
                            return GestureDetector(
                              onTap: () {
                                if (recipeData['page'] != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => recipeData['page'],
                                    ),
                                  );
                                }
                              },
                              child: _buildRecipeCard(
                                title: recipeData['name'],
                                duration: recipeData['time'],
                                imageWidget: recipeData['img'],
                                matchCount: recipeData['matches'] > 0
                                    ? recipeData['matches']
                                    : null,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeCard({
    required String title,
    required String duration,
    required Widget imageWidget,
    int? matchCount,
  }) {
    bool isFav = UserData.favoriteRecipes.contains(title);

    return Container(
      width: double.infinity,
      height: 120,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: bgCardWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              const SizedBox(width: 10),
              SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FittedBox(fit: BoxFit.cover, child: imageWidget),
                ),
              ),
              const SizedBox(width: 22),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: labelPrimaryAndButton,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      time,
                      const SizedBox(width: 3),
                      Text(
                        duration,
                        style: const TextStyle(
                          fontSize: 13,
                          color: labelSecondary,
                        ),
                      ),
                      if (matchCount != null) ...[
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.inventory_2_outlined,
                          size: 12,
                          color: primaryGreen,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '$matchCount',
                          style: const TextStyle(
                            fontSize: 12,
                            color: primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 11,
            right: 5,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isFav
                      ? UserData.favoriteRecipes.remove(title)
                      : UserData.favoriteRecipes.add(title);
                });
              },
              child: Icon(
                Icons.star,
                size: 28,
                color: isFav ? primaryGreen : labelSecondary.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          recipeKeeper,
          const SizedBox(height: 20),
          Text(
            _showAll
                ? 'Ничего не найдено'
                : 'Добавьте продукты, чтобы\nздесь появились рецепты',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              color: searchText,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 200),
        ],
      ),
    );
  }

  Widget _buildAnimatedToggle() {
    return Container(
      width: 290,
      height: 40,
      decoration: BoxDecoration(
        color: bgAppMain,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: _showAll ? Alignment.centerLeft : Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                width: _showAll ? 130 : 152,
                height: 32,
                decoration: BoxDecoration(
                  color: primaryGreen,
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _showAll = true),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 134,
                  child: Center(
                    child: Text(
                      'Все рецепты',
                      style: TextStyle(
                        color: _showAll ? bgCardWhite : labelSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _showAll = false),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      'Из моих продуктов',
                      style: TextStyle(
                        color: !_showAll ? bgCardWhite : labelSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      width: double.infinity,
      height: 43,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgCardWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocus,
        onChanged: _runFilter,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: 'Поиск',
          hintStyle: TextStyle(
            color: searchText.withOpacity(0.5),
            fontSize: 17,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.only(left: 15),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: searchText, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    _runFilter('');
                  },
                )
              : Padding(padding: const EdgeInsets.all(12.0), child: poisk),
        ),
      ),
    );
  }
}
