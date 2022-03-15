import 'package:flutter/material.dart';
import '../database/ingredients_db.dart';
import '../model/ingredient_model.dart';
import '../widget/ingredient_form_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddEditIngredientPage extends StatefulWidget {
  final Ingredient? ingredient;

  const AddEditIngredientPage({
    Key? key,
    this.ingredient,
  }) : super(key: key);
  @override
  _AddEditIngredientPageState createState() => _AddEditIngredientPageState();
}

class _AddEditIngredientPageState extends State<AddEditIngredientPage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late num price;
  late String unit;
  late num amount;
  late bool isUpdating;

  @override
  void initState() {
    super.initState();
    isUpdating = widget.ingredient != null;
    name = widget.ingredient?.name ?? '';
    price = widget.ingredient?.price ?? 0;
    unit = widget.ingredient?.unit ?? '';
    amount = widget.ingredient?.amount ?? 0;
    amount = amount*price;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton(), if (isUpdating) buildDeleteButton()],
        ),
        body: Form(
          key: _formKey,
          child: IngredientFormWidget(
            name: name,
            price: price,
            amount: amount,
            unit: unit,
            onChangedName: (name) => setState(() => this.name = name),
            onChangedPrice: (price) => setState(() => this.price = price),
            onChangedUnit: (unit) => setState(() => this.unit = unit),
            onChangedAmount: (amount) => setState(() => this.amount = amount),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid =
        name.isNotEmpty && unit.isNotEmpty && price > 0.0 && amount > 0.0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateIngredient,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateIngredient() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      if (isUpdating) {
        await updateIngredient();
      } else {
        await addIngredient();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateIngredient() async {
    final ingredient = widget.ingredient!.copy(
      name: name,
      unit: unit,
      price: num.parse((price / amount).toStringAsFixed(3)),
      amount: amount,
    );

    await IngredientsDB.instance.update(ingredient);
  }

  Future addIngredient() async {
    final ingredient = Ingredient(
      name: name,
      unit: unit,
      price: num.parse((price / amount).toStringAsFixed(3)),      //TODO: fix dividing issue
      amount: amount,
    );

    await IngredientsDB.instance.create(ingredient);
  }

  Future deleteIngredient() async {
    int result = await IngredientsDB.instance.delete(widget.ingredient!.id!);
    if (result == -1) {
      await Fluttertoast.showToast(msg: 'Ingredient in use');
    } else {
      Navigator.of(context).pop();
    }
  }

  Widget buildDeleteButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: Colors.red,
        ),
        onPressed: deleteIngredient,
        child: Text('Delete'),
      ),
    );
  }
}
