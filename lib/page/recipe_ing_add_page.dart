import 'package:flutter/material.dart';
import '../model/recipe_ingredients_model.dart';
import '../model/ingredient_model.dart';
import '../database/ingredients_db.dart';

class RecipeIngAddPage extends StatefulWidget {
  final List<RecipeIngredients> ingredients;
  final ValueChanged<List<RecipeIngredients>> onChangedIngredients;

  const RecipeIngAddPage({
    Key? key,
    required this.ingredients,
    required this.onChangedIngredients,
  }) : super(key: key);

  @override
  State<RecipeIngAddPage> createState() => _RecipeIngAddPageState();
}

class _RecipeIngAddPageState extends State<RecipeIngAddPage> {
  late List<Ingredient> ingredientsList;
  Map<String, bool> _ingredientsChecked = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    refreshIngredients();
  }

  Future refreshIngredients() async {
    setState(() => isLoading = true);
    ingredientsList = await IngredientsDB.instance.readAll();
    for (var ingredient in ingredientsList) {
      _ingredientsChecked[ingredient.name] = false;
    }
    for (var element in widget.ingredients) {
      _ingredientsChecked[element.name] = true;
    }
    // print(_ingredientsChecked);
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    IngredientsDB.instance.nullDB();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Ingredients'),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Center(
      child: isLoading
          ? CircularProgressIndicator()
          : ingredientsList.isEmpty
              ? Text(
                  'No Ingredients Found',
                  style: TextStyle(color: Colors.white),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: ingredientsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () =>
                          _ingredientsChecked[ingredientsList[index].name] !=
                                  true
                              ? openDialog(ingredientsList[index])
                              : openDialog(ingredientsList[index],
                                  isEdit: true),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 50,
                          color: _ingredientsChecked[
                                      ingredientsList[index].name] ==
                                  true
                              ? Colors.green
                              : Colors.amber,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(ingredientsList[index].name),
                              Text(
                                  '₹${ingredientsList[index].price}/${ingredientsList[index].unit}'),
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

  void openDialog(Ingredient ingredient, {bool isEdit = false}) {
    String value = isEdit
        ? widget.ingredients
            .firstWhere((element) => element.name == ingredient.name)
            .amount
            .toString()
        : '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Choose Quantity'),
          content: TextFormField(
            initialValue: isEdit
                ? widget.ingredients
                    .firstWhere((element) => element.name == ingredient.name)
                    .amount
                    .toString()
                : '',
            keyboardType: TextInputType.number,
            onChanged: (String input) => value = input,
            decoration: InputDecoration(
              hintText: 'Enter amount in ${ingredient.unit}',
            ),
          ),
          actions: [
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (value.isNotEmpty) {
                  isEdit
                      ? widget.ingredients.remove(widget.ingredients.firstWhere(
                          (element) => element.name == ingredient.name))
                      : null;
                  widget.ingredients.add(RecipeIngredients(
                    id: ingredient.id,
                    name: ingredient.name,
                    amount: num.parse(value),
                    unit: ingredient.unit,
                    price: num.parse((ingredient.price * num.parse(value)).toStringAsFixed(3)),
                  ));
                  widget.onChangedIngredients(widget.ingredients);
                  Navigator.of(context).pop();
                  // print(ingredient.id);
                  setState(() => _ingredientsChecked[ingredient.name] = true);
                }
              },
            ),
            if (isEdit)
              TextButton(
                child: Text('Delete'),
                onPressed: () => setState(() {
                  widget.ingredients.remove(widget.ingredients.firstWhere(
                      (element) => element.name == ingredient.name));
                  widget.onChangedIngredients(widget.ingredients);
                  _ingredientsChecked[ingredient.name] = false;
                  Navigator.of(context).pop();
                }),
              ),
          ],
        );
      },
    );
  }
}
