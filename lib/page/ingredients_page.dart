import 'package:flutter/material.dart';
import '../database/ingredients_db.dart';
import '../model/ingredient_model.dart';
import '../page/ingredients_add_page.dart';
import '../database/recipe_ingredients_db.dart';

class IngredientsPage extends StatefulWidget {
  const IngredientsPage({Key? key}) : super(key: key);

  @override
  _IngredientsPageState createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  late List<Ingredient> ingredients;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshIngredients();
  }

  @override
  void dispose() {
    IngredientsDB.instance.close();
    RecipeIngredientsDB.instance.close();
    super.dispose();
  }

  Future refreshIngredients() async {
    setState(() => isLoading = true);

    ingredients = await IngredientsDB.instance.readAll();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ingredients')),
      body: buildPage(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddEditIngredientPage()),
          );

          refreshIngredients();
        },
      ),
    );
  }

  Widget buildPage() {
    return Center(
      child: isLoading
          ? CircularProgressIndicator()
          : ingredients.isEmpty
              ? Text(
                  'No Ingredients Added',
                  style: TextStyle(color: Colors.white),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: ingredients.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddEditIngredientPage(
                                ingredient: ingredients[index]),
                          ),
                        );

                        refreshIngredients();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 50,
                          color: Colors.amber,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${ingredients[index].name}'),
                              Text(
                                  '₹${ingredients[index].price}/${ingredients[index].unit}'),
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
}
