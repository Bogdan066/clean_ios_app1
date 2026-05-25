import 'package:flutter/material.dart';
import 'package:clean_ios_app/config/app_colors.dart';
import 'package:clean_ios_app/config/images.dart';
import 'package:clean_ios_app/pages/profilepage/user_data.dart';
import 'package:clean_ios_app/cartState.dart';

class PelmeniDetailPage extends StatefulWidget {
  const PelmeniDetailPage({super.key});

  @override
  State<PelmeniDetailPage> createState() => _PelmeniDetailPageState();
}

class _PelmeniDetailPageState extends State<PelmeniDetailPage> {
  final String recipeTitle = 'Пельмени';

  final List<Map<String, dynamic>> ingredients = [
    {'name': 'вода', 'fullName': 'тёплая вода (200 мл)'},
    {'name': 'яйцо', 'fullName': 'яйцо куриное (1 шт)'},
    {'name': 'соль', 'fullName': 'соль (1 ч.л)'},
    {'name': 'говядина', 'fullName': 'говядина (500 г)'},
    {'name': 'свинина', 'fullName': 'свинина (500 г)'},
    {'name': 'лук репчатый', 'fullName': 'лук репчатый (2 шт)'},
    {'name': 'чеснок', 'fullName': 'чеснок (2 зуб)'},
    {'name': 'соль', 'fullName': 'соль (1,5 ч. л)'},
    {'name': 'перец', 'fullName': 'перец черный (по вкусу)'},
    {'name': 'вода', 'fullName': 'вода холодная (100 мл)'},
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
                              '250 ккал',
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
                              '2 часа',
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
                      '1. Просеять муку на столешницу, сделать углубление и влить воду с яйцом и солью.\n'
                      '2. Замесить тесто руками: сначала оно будет липким, но через 5–7 минут станет гладким.\n'
                      '3. Накрыть плёнкой и дать отдохнуть 20–30 минут — это сделает тесто эластичным для лепки.\n'
                      '4. Разделить на части, раскатать в тонкий пласт толщиной 2 мм.\n'
                      '5. Пропустить мясо и лук через мясорубку дважды для нежности.\n'
                      '6. Чеснок измельчить и вмешать.\n'
                      '7. Добавить соль, перец и воду.\n'
                      '8. Хорошо вымесить руками 5–10 минут — это выпустит белки и сделает фарш упругим.\n'
                      '9. Попробовать на соль (сырым), если нужно, досолить.\n'
                      '10. Оставить в холодильнике на 30 минут для пропитки.\n'
                      '11. Сварить получившиеся пельмени.\n',
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
