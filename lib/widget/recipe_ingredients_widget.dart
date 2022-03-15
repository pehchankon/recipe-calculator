import 'package:flutter/material.dart';
import '../model/recipe_ingredients_model.dart';

class RecipeIngredientsWidget extends StatelessWidget {
  final List<RecipeIngredients> ingredients;
  final Function? function;

  RecipeIngredientsWidget({
    Key? key,
    required this.ingredients,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ingredients.isEmpty
      ? Text(
          'No Ingredients Found',
          style: TextStyle(color: Colors.white),
        )
      : Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: ingredients.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => function!=null ? function!():print('helo'),
                  child: Container(
                    height: 50,
                    color: Colors.amber,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(ingredients[index].name),
                        Text(
                            '₹${ingredients[index].price}  |  ${ingredients[index].amount}${ingredients[index].unit}'),
                      ],
                    ),
                    padding: const EdgeInsets.all(10),
                  ),
                ),
              );
            },
          ),
        );
}
