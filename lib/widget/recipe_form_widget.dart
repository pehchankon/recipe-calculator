import 'package:flutter/material.dart';
import '../model/recipe_ingredients_model.dart';

class RecipeFormWidget extends StatelessWidget {
  final String? name;
  final num? extraPrice;
  final num? weight;
  final String? notes;
  final num? totalPrice;
  final List<RecipeIngredients> ingredients;
  final String? unit;
  final ValueChanged<String> onChangedName;
  final ValueChanged<num> onChangedExtraPrice;
  final ValueChanged<num> onChangedWeight;
  final ValueChanged<String> onChangedNotes;
  final ValueChanged<String> onChangedUnit;

  const RecipeFormWidget({
    Key? key,
    this.name = '',
    this.extraPrice = 0,
    this.weight = 0,
    this.notes = '',
    this.totalPrice = 0,
    this.unit = '',
    required this.ingredients,
    required this.onChangedUnit,
    required this.onChangedName,
    required this.onChangedExtraPrice,
    required this.onChangedWeight,
    required this.onChangedNotes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildTextField('name', onChangedName, name!),
            SizedBox(height: 8),
            buildDecimalField('extra cost', onChangedExtraPrice, extraPrice!,
                canBeEmpty: true),
            SizedBox(height: 8),
            buildDecimalField('quantity', onChangedWeight, weight!),
            SizedBox(height: 8),
            buildTextField('unit', onChangedUnit, unit!),
            SizedBox(height: 8),
            buildTextField('notes', onChangedNotes, notes!, canBeEmpty: true),
            SizedBox(height: 8),
            buildText(totalPrice!),
            SizedBox(height: 8),
            // RecipeIngredientsWidget(ingredients: ingredients),
          ],
        ),
      );

  Widget buildTextField(
          String input, Function(String) onChanged, String initial,
          {bool canBeEmpty = false}) =>
      TextFormField(
        initialValue: initial,
        style: TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          label: Text(input, style: TextStyle(color: Colors.white60)),
        ),
        validator: (text) => text != null && !canBeEmpty && text.isEmpty
            ? 'The field cannot be empty'
            : null,
        onChanged: onChanged,
      );

  Widget buildDecimalField(String input, Function onChanged, num initial,
          {bool canBeEmpty = false}) =>
      TextFormField(
        initialValue: initial > 0 ? initial.toString() : '',
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          label: Text(input, style: TextStyle(color: Colors.white60)),
        ),
        validator: (text) => text != null && text.isEmpty && !canBeEmpty
            ? 'The field cannot be empty'
            : null,
        onChanged: (value) =>
            onChanged(double.parse(value != '' ? value : '0')),
      );

  Widget buildText(num initial) => Row(
        children: [
          Text('Total Price: ',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          Text(
            '₹ ' + initial.toString(),
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      );
}
