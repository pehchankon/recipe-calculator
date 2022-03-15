import 'package:flutter/material.dart';

class IngredientFormWidget extends StatelessWidget {
  final String? name;
  final num? price;
  final String? unit;
  final num? amount;
  final ValueChanged<String> onChangedName;
  final ValueChanged<num> onChangedPrice;
  final ValueChanged<String> onChangedUnit;
  final ValueChanged<num> onChangedAmount;

  const IngredientFormWidget({
    Key? key,
    this.name = '',
    this.price = 0,
    this.unit = '',
    this.amount = 0,
    required this.onChangedName,
    required this.onChangedPrice,
    required this.onChangedUnit,
    required this.onChangedAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTextField('name', onChangedName, name!),
              SizedBox(height: 8),
              buildDecimalField('price', onChangedPrice, price!),
              SizedBox(height: 8),
              buildDecimalField('quantity', onChangedAmount, amount!),
              SizedBox(height: 8),
              buildTextField('unit', onChangedUnit, unit!),
            ],
          ),
        ),
      );

  Widget buildTextField(String input, Function(String) onChanged, String initial) => TextFormField(
        initialValue: initial,
        style: TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          label: Text(input,style:TextStyle(color: Colors.white60)),
        ),
        validator: (text) =>
            text != null && text.isEmpty ? 'The field cannot be empty' : null,
        onChanged: onChanged,
      );

      Widget buildDecimalField(String input, Function onChanged,num initial) => TextFormField(
        initialValue: initial>0?initial.toString():'',
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          label: Text(input,style:TextStyle(color: Colors.white60)),
        ),
        validator: (text) =>
            text != null && text.isEmpty ? 'The field cannot be empty' : null,
        onChanged: (value) => onChanged(double.parse(value)),
      );

}
