import 'package:flutter/material.dart';
import 'package:clean_ios_app/config/app_colors.dart';
import 'package:clean_ios_app/config/images.dart';
import 'package:clean_ios_app/pages/profilepage/user_data.dart';
import 'package:clean_ios_app/cartState.dart';

class TiramisuDetailPage extends StatefulWidget {
  const TiramisuDetailPage({super.key});

  @override
  State<TiramisuDetailPage> createState() => _TiramisuDetailPageState();
}

class _TiramisuDetailPageState extends State<TiramisuDetailPage> {
  final String recipeTitle = 'Тирамису';

  final List<Map<String, dynamic>> ingredients = [
    {'name': 'яйцо', 'fullName': 'желтки и белки (5 шт и 3 шт)'},
    {'name': 'маскарпоне', 'fullName': 'маскарпоне (500 г)'},
    {'name': 'сахар', 'fullName': 'сахар (100 г)'},
    {'name': 'кофе', 'fullName': 'крепкий кофе (400 мл)'},
    {'name': 'коньяк', 'fullName': 'коньяк (2 ст. л)'},
    {'name': 'печенье савоярди', 'fullName': 'печенье савоярди (24 шт)'},
    {'name': 'какао', 'fullName': 'какао-порошок (для посыпки)'},
  ];

  @override
  Widget build(BuildContext context) {
    bool isFav = UserData.favoriteRecipes.contains(recipeTitle);

    return Scaffold(
      backgroundColor: primaryGreen,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 52, left: 16, right: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: arrowBackLeft,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Рецепты',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: bgCardWhite,
                    fontFamily: 'Inter',
                  ),
                ),
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          recipeTitle,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: labelPrimaryAndButton,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isFav) {
                                UserData.favoriteRecipes.remove(recipeTitle);
                              } else {
                                UserData.favoriteRecipes.add(recipeTitle);
                              }
                            });
                          },
                          child: Icon(
                            Icons.star,
                            size: 32,
                            color: isFav
                                ? primaryGreen
                                : labelSecondary.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            fire,
                            const SizedBox(width: 5),
                            const Text(
                              '450 ккал',
                              style: TextStyle(
                                color: labelSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            time,
                            const SizedBox(width: 5),
                            const Text(
                              '8 часов',
                              style: TextStyle(
                                color: labelSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Ингредиенты',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: labelPrimaryAndButton,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ...ingredients
                        .map((item) => _buildIngredientRow(item))
                        .toList(),
                    const SizedBox(height: 30),
                    const Text(
                      'Приготовление',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: labelPrimaryAndButton,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      '1. Заварить очень крепкий кофе и полностью остудить его. В холодный напиток добавить алкоголь — он усиливает аромат и балансирует сладость крема.\n'
                      '2. Отдельно разделить яйца. Белки взбить с щепоткой соли до пены, затем постепенно ввести сахар и довести массу до плотной, устойчивой меренги. Желтки взбить отдельно — без сахара — до заметного посветления.\n'
                      '3. К желткам частями добавить маскарпоне, добиваясь гладкого, однородного крема. После этого аккуратно, лопаткой, вмешать меренгу, стараясь не осадить воздушную структуру.\n'
                      '4. Савоярди очень быстро окунуть в кофе — буквально на секунду. Печенье должно остаться суховатым внутри: так оно впитает крем, но не расползётся.\n'
                      '5. В форму выложить слой савоярди, затем половину крема, после чего повторять слои. В классической подаче второй слой печенья часто укладывают перпендикулярно первому — так десерт лучше держит форму при нарезке.\n'
                      '6. Тирамису убрать в холодильник минимум на 6 часов, а лучше — на ночь. Перед подачей поверхность щедро посыпать какао-порошком.\n',
                      style: TextStyle(
                        fontSize: 15,
                        color: labelSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientRow(Map<String, dynamic> ingredient) {
    final fridgeProductNames = CartState().addedProducts
        .map((p) => p.name.toLowerCase())
        .toList();

    bool hasProduct = fridgeProductNames.any(
      (productInFridge) =>
          ingredient['fullName'].toLowerCase().contains(productInFridge) ||
          ingredient['name'].toLowerCase().contains(productInFridge),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: hasProduct
                  ? primaryGreen
                  : labelSecondary.withOpacity(0.3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ingredient['fullName'],
              style: const TextStyle(fontSize: 15, color: labelSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
