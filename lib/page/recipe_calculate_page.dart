import 'package:flutter/material.dart';
import '../model/recipe_model.dart';
import '../model/recipe_ingredients_model.dart';
import '../database/recipe_ingredients_db.dart';
import '../widget/recipe_ingredients_widget.dart';

class RecipeCalculatePage extends StatefulWidget {
  final Recipe recipe;
  // final List<RecipeIngredients> ingredients;

  const RecipeCalculatePage({
    Key? key,
    required this.recipe,
    // required this.ingredients,
  }) : super(key: key);

  @override
  State<RecipeCalculatePage> createState() => _RecipeCalculatePageState();
}

class _RecipeCalculatePageState extends State<RecipeCalculatePage> {
  late num totalPrice;
  late num weight;
  late final String name;
  late final num extraPrice;
  late final String unit;
  late List<RecipeIngredients> ingredients;

  bool isLoading = false;
  TextStyle style = TextStyle(fontSize: 18, color: Colors.white);

  @override
  void initState() {
    super.initState();
    isLoading = true;
    totalPrice = widget.recipe.totalPrice;
    weight = widget.recipe.weight;
    name = widget.recipe.name;
    extraPrice = widget.recipe.extraPrice;
    unit = widget.recipe.unit;
    _initIngredients();
  }

  void _initIngredients() async {
    setState(() => isLoading = true);
    ingredients =
        await RecipeIngredientsDB.instance.readAll(name.replaceAll(' ', '_'));
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipe Calculator')),
      body: isLoading ? CircularProgressIndicator() : body(),
    );
  }

  void onChanged(String input, num value) {
    if (value == 0) return;
    setState(() {
      num oldPrice = totalPrice;
      if (input == 'Weight') {
        totalPrice = value * totalPrice / weight;
        weight = value;
      } else {
        weight = value * weight / totalPrice;
        totalPrice = value;
      }
      num newPrice = totalPrice;
      List<RecipeIngredients> tempIngredients=[];
      for (var ingredient in ingredients) {
        num tempPrice = newPrice*ingredient.price/oldPrice; //new ingr price
        ingredient=ingredient.copy(price: round(tempPrice), amount: round(tempPrice*ingredient.amount/ingredient.price));
        tempIngredients.add(ingredient);
      }
      ingredients = tempIngredients;
    });
  }

  num round(num val)
  {
    return num.parse(val.toStringAsFixed(2));
  }
  Widget body() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildText(initial: 'Name', value: name),
            buildText(initial: 'Extra Price', value: '₹ $extraPrice'),
            // buildText(initial: 'Unit', value: unit),
            buildText(
                initial: 'Weight', value: '${weight.toStringAsFixed(2)} $unit'),
            buildText(
                initial: 'Total Price',
                value: '₹ ${totalPrice.toStringAsFixed(2)}'),
            buildDecimalField('Weight', onChanged, weight),
            buildDecimalField('Total Price', onChanged, totalPrice),
            SizedBox(height: 8),
            RecipeIngredientsWidget(ingredients: ingredients),
          ],
        ),
      );

  Widget buildText({required String value, required String initial}) => Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          '$initial: $value',
          style: style,
        ),
      );

  Widget buildDecimalField(String input, Function onChanged, num initial) =>
      TextField(
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: input,
            labelStyle: TextStyle(color: Colors.white60, fontSize: 18)),
        onChanged: (value) =>
            onChanged(input, double.parse(value != '' ? value : '0')),
      );
}
