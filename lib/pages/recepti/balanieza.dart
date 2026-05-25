import 'package:flutter/material.dart';
import 'package:clean_ios_app/config/app_colors.dart';
import 'package:clean_ios_app/config/images.dart';
import 'package:clean_ios_app/pages/profilepage/user_data.dart';
import 'package:clean_ios_app/cartState.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({super.key});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final String recipeTitle = 'Паста болоньезе';

  final List<Map<String, dynamic>> ingredients = [
    {'name': 'спагетти', 'fullName': 'спагетти (400 г)'},
    {'name': 'фарш', 'fullName': 'говяжий фарш (500 г)'},
    {'name': 'морковь', 'fullName': 'морковь (1 шт)'},
    {'name': 'сельдерей', 'fullName': 'сельдерей (1 стебель)'},
    {'name': 'лук', 'fullName': 'лук (1 шт)'},
    {'name': 'чеснок', 'fullName': 'чеснок (2 зубч)'},
    {'name': 'томаты', 'fullName': 'томаты в собственном соку (400 г)'},
    {'name': 'масло', 'fullName': 'оливковое масло (для жарки)'},
    {'name': 'соль', 'fullName': 'соль (по вкусу)'},
    {'name': 'перец', 'fullName': 'перец (по вкусу)'},
    {'name': 'лавровый лист', 'fullName': 'лавровый лист (1 шт)'},
    {'name': 'базилик', 'fullName': 'сушёный базилик (по вкусу)'},
    {'name': 'орегано', 'fullName': 'орегано (по вкусу)'},
    {'name': 'сыр пармезан', 'fullName': 'тёртый пармезан (для подачи)'},
    {'name': 'вино', 'fullName': 'красное сухое вино (100 мл)'},
  ];

  @override
  Widget build(BuildContext context) {
    bool isFav = UserData.favoriteRecipes.contains(recipeTitle);

    return Scaffold(
      backgroundColor: primaryGreen,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Шапка
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
                              '170 ккал',
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
                      '1. Мелко нарежьте лук, морковь, сельдерей и чеснок.\n'
                      '2. На большой сковороде или в сотейнике разогрейте оливковое масло.\n'
                      '3. Обжарьте фарш до коричневого цвета. Выньте его из сковороды.\n'
                      '4. В той же сковороде обжарьте лук, морковь, сельдерей и чеснок до мягкости.\n'
                      '5. Верните фарш в сковороду к овощам. Добавьте красное вино и дайте ему выпариться.\n'
                      '6. Добавьте консервированные томаты, лавровый лист, сушёный базилик и орегано. Посолите и поперчите.\n'
                      '7. Тушите на медленном огне 1–1,5 часа.\n'
                      '8. Отварите пасту до состояния аль денте.\n'
                      '9. Подавайте пасту с соусом и тёртым пармезаном.',
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
