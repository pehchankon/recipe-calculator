import 'package:flutter/material.dart';
import '../database/recipe_db.dart';
import '../model/recipe_model.dart';
import '../page/recipe_add_page.dart';
import '../database/recipe_ingredients_db.dart';
import '../page/recipe_calculate_page.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({Key? key}) : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  late List<Recipe> recipe;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshRecipes();
  }

  @override
  void dispose() {
    RecipeDB.instance.close();
    RecipeIngredientsDB.instance.close();
    super.dispose();
  }

  Future refreshRecipes() async {
    setState(() => isLoading = true);
    recipe = await RecipeDB.instance.readAll();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipes')),
      body: buildPage(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddEditRecipePage()),
          );

          refreshRecipes();
        },
      ),
    );
  }

  Widget buildPage() {
    return Center(
      child: isLoading
          ? CircularProgressIndicator()
          : recipe.isEmpty
              ? Text(
                  'No Recipes Added',
                  style: TextStyle(color: Colors.white),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: recipe.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                AddEditRecipePage(recipe: recipe[index]),
                          ),
                        );

                        refreshRecipes();
                      },
                      onLongPress: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                RecipeCalculatePage(recipe: recipe[index]),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 50,
                          color: Colors.amber,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${recipe[index].name}'),
                              Text(
                                  '₹${recipe[index].totalPrice}  |  ${recipe[index].weight}${recipe[index].unit}'),
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
