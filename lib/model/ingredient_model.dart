final String tableIngredients = 'ingredients';

class IngredientFields {
  static final List<String> values = [id, unit, price, name];   //TODO: add amount column in ingredient table

  static final String id = '_id';
  static final String name = 'name';
  static final String price = 'price';
  static final String unit = 'unit';
  static final String amount = 'amount';
}

class Ingredient {
  final int? id;
  final String name;
  final num price;
  final String unit;
  final num amount;

  const Ingredient({
    this.id,
    required this.name,
    required this.price,
    required this.unit,
    required this.amount,
  });

  Map<String, Object?> toJson() => {
        IngredientFields.id: id,
        IngredientFields.name: name,
        IngredientFields.price: price,
        IngredientFields.unit: unit,
        IngredientFields.amount: amount,
      };

  Ingredient copy({int? id, String? name, num? price, String? unit, num? amount}) =>
      Ingredient(id: id??this.id, name: name??this.name, price: price??this.price, unit: unit??this.unit, amount: amount??this.amount);

  static Ingredient fromJson(Map<String, Object?> json) => Ingredient(
        id: json[IngredientFields.id] as int?,
        name: json[IngredientFields.name] as String,
        price: json[IngredientFields.price] as num,
        unit: json[IngredientFields.unit] as String,
        amount: json[IngredientFields.amount] as num,
      );
}
