import 'package:flutter/material.dart';
import 'package:clean_ios_app/config/app_colors.dart';
import 'package:clean_ios_app/config/images.dart';
import 'package:clean_ios_app/pages/profilepage/user_data.dart';
import 'package:clean_ios_app/cartState.dart';

class BorshDetailPage extends StatefulWidget {
  const BorshDetailPage({super.key});

  @override
  State<BorshDetailPage> createState() => _BorshDetailPageState();
}

class _BorshDetailPageState extends State<BorshDetailPage> {
  final String recipeTitle = 'Борщ';

  final List<Map<String, dynamic>> ingredients = [
    {'name': 'говядина', 'fullName': 'говядина (600 г)'},
    {'name': 'вода', 'fullName': 'вода (3 л)'},
    {'name': 'лавровый лист', 'fullName': 'лавровый лист (2 шт)'},
    {'name': 'душистый перец', 'fullName': 'душистый перец (3 горош)'},
    {'name': 'соль', 'fullName': 'соль (по вкусу)'},
    {'name': 'свёкла', 'fullName': 'свёкла (2 шт)'},
    {'name': 'морковь', 'fullName': 'морковь (1 шт)'},
    {'name': 'масло', 'fullName': 'оливковое масло (для жарки)'},
    {'name': 'репчатый лук', 'fullName': 'репчатый лук (1 шт)'},
    {'name': 'картофель', 'fullName': 'картофель (4 шт)'},
    {'name': 'капуста', 'fullName': 'свежая капуста (300 г)'},
    {'name': 'томатная паста', 'fullName': 'томатная паста (2 ст. л)'},
    {'name': 'сахар', 'fullName': 'сахар (1 ч. л)'},
    {'name': 'уксус 9%', 'fullName': 'уксус 9% (1 ч. л)'},
    {'name': 'растительное масло', 'fullName': 'растительное масло (3 ст. л)'},
    {'name': 'чеснок', 'fullName': 'чеснок (2 зубч)'},
    {'name': 'укроп', 'fullName': 'укроп (по вкусу)'},
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
                              '40 ккал',
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
                              '1 час',
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
                      '1. Варим бульон: говядину промыть, залить холодной водой и довести до кипения. Снять пену, уменьшить огонь и варить бульон на слабом огне около 1,5 часов до мягкости мяса. За 15 минут до готовности добавить лавровый лист, перец и немного соли. Затем достать мясо, отделить от костей и нарезать кусочками.\n'
                      '2. Подготавливаем овощи: свёклу натереть на крупной тёрке, морковь — на средней, лук мелко нарезать. В сковороде разогреть масло, добавить лук и морковь, обжарить до мягкости. Затем выложить свёклу, добавить уксус и сахар — это поможет сохранить насыщенный цвет. Вмешать томатную паста и немного бульона, тушить под крышкой около 10 минут.\n'
                      '3. Готовим суп: в готовый бульон добавить нарезанный картофель и варить 10–15 минут, затем ввести нашинкованную капусту. Когда овощи станут мягкими, добавить зажарку и кусочки мяса. Посолить, при желании добавить немного перца. Варить всё вместе ещё 10 минут.\n'
                      '4. Финальные штрихи: добавить в борщ измельчённый чеснок и мелко нарезанную зелень. Накрыть крышкой и дать настояться 15–20 минут.\n',
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
