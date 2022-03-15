import 'package:flutter/material.dart';
import '../database/recipe_db.dart';
import '../database/recipe_ingredients_db.dart';
import '../model/recipe_model.dart';
import '../model/recipe_ingredients_model.dart';
import '../page/recipe_ing_add_page.dart';
import '../widget/recipe_form_widget.dart';
import '../widget/recipe_ingredients_widget.dart';

class AddEditRecipePage extends StatefulWidget {
  final Recipe? recipe;
  final RecipeIngredients? recipeIngredients;

  const AddEditRecipePage({
    Key? key,
    this.recipe,
    this.recipeIngredients,
  }) : super(key: key);
  @override
  _AddEditRecipePageState createState() => _AddEditRecipePageState();
}

class _AddEditRecipePageState extends State<AddEditRecipePage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late num extraPrice;
  late num weight;
  late String unit;
  late String notes;
  late num totalPrice=0;
  List<RecipeIngredients> ingredients = [];
  bool isLoading = false;
  late bool isUpdating;

  @override
  void initState() {
    super.initState();
    isUpdating = widget.recipe != null;
    name = widget.recipe?.name ?? '';
    extraPrice = widget.recipe?.extraPrice ?? 0;
    weight = widget.recipe?.weight ?? 0;
    notes = widget.recipe?.notes ?? '';
    totalPrice = widget.recipe?.totalPrice ?? 0;
    unit = widget.recipe?.unit ?? '';
    _initIngredients();
  }

  Future _initIngredients() async {
    // await RecipeIngredientsDB.instance.readAll(name);
    setState(() => isLoading = true);
    ingredients = name != ''
        ? await RecipeIngredientsDB.instance.readAll(name.replaceAll(' ', '_'))
        : [];
    totalPrice = calculateTotalPrice();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton(), if (isUpdating) buildDeleteButton()],
          title: Text(isUpdating ? 'Edit Recipe' : 'Add Recipe'),
        ),
        body: isLoading
            ? CircularProgressIndicator()
            : Column(
                children: [
                  Form(
                    key: _formKey,
                    child: RecipeFormWidget(
                      name: name,
                      extraPrice: extraPrice,
                      weight: weight,
                      notes: notes,
                      totalPrice: totalPrice,
                      unit: unit,
                      ingredients: ingredients,
                      onChangedUnit: (unit) => setState(() => this.unit = unit),
                      onChangedName: (name) => setState(() => this.name = name),
                      onChangedExtraPrice: (price) => setState(() {
                        totalPrice += (price - extraPrice);
                        extraPrice = price;
                        // print(price);
                      }),
                      onChangedNotes: (notes) =>
                          setState(() => this.notes = notes),
                      onChangedWeight: (weight) =>
                          setState(() => this.weight = weight),
                    ),
                  ),
                  RecipeIngredientsWidget(
                      ingredients: ingredients, function: callRecIngrAddPage),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => callRecIngrAddPage(),
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
        ),
      );

  void callRecIngrAddPage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RecipeIngAddPage(
            ingredients: ingredients,
            onChangedIngredients: (ingredients) =>
                setState(() => this.ingredients = ingredients)),
      ),
    );

    setState(() {
      totalPrice = calculateTotalPrice();
    });
  }

  Widget buildButton() {
    final isFormValid = name.isNotEmpty && weight > 0.0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateRecipe,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateRecipe() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      if (isUpdating) {
        await updateRecipe();
      } else {
        await addRecipe();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateRecipe() async {
    final recipe = widget.recipe!.copy(
      name: name,
      weight: weight,
      extraPrice: extraPrice,
      unit: unit,
      notes: notes,
      totalPrice: calculateTotalPrice(),
    );
    // print(ingredients.length);
    // print(recipe.totalPrice);
    if(widget.recipe!.name!=name) RecipeIngredientsDB.instance.changeName(widget.recipe!.name.replaceAll(' ', '_'));
    await RecipeIngredientsDB.instance.deleteAll(name.replaceAll(' ', '_'));    
    await RecipeIngredientsDB.instance
        .create(name.replaceAll(' ', '_'), ingredients);
    await RecipeDB.instance.update(recipe);
  }

  num calculateTotalPrice() {
    num totalPrice = 0;
    for (var element in ingredients) {
      totalPrice += element.price;
      // print(element.price);
    }
    return num.parse((totalPrice + extraPrice).toStringAsFixed(3));
  }

  Future addRecipe() async {
    final recipe = Recipe(
      name: name,
      unit: unit,
      weight: weight,
      extraPrice: extraPrice,
      notes: notes,
      totalPrice: calculateTotalPrice(),
    );
    setState(() {});
    await RecipeDB.instance.create(recipe);
    await RecipeIngredientsDB.instance
        .create(name.replaceAll(' ', '_'), ingredients);
  }

  Future deleteRecipe() async {
    await RecipeIngredientsDB.instance.deleteAll(name.replaceAll(' ', '_'));
    await RecipeDB.instance.delete(widget.recipe!.id!);
    Navigator.of(context).pop();
  }

  Widget buildDeleteButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: Colors.red,
        ),
        onPressed: deleteRecipe,
        child: Text('Delete'),
      ),
    );
  }
}
