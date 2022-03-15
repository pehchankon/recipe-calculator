
class RecipeIngredientsFields {
  static final List<String> values = [
    id,
    name,
    amount,
    unit,
    price,
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String amount = 'amount';
  static const String price = 'price';
  static const String unit = 'unit';
}

class RecipeIngredients {
  final int? id;
  final String name;
  final num amount;
  final num price;
  final String unit;

  const RecipeIngredients({
    this.id,
    required this.name,
    required this.amount,
    required this.price,
    required this.unit,
  });

  Map<String, Object?> toJson() => {
        RecipeIngredientsFields.id: id,
        RecipeIngredientsFields.name: name,
        RecipeIngredientsFields.amount: amount,
        RecipeIngredientsFields.price: price ,
        RecipeIngredientsFields.unit: unit,
      };

  RecipeIngredients copy(
          {int? id,
          String? name,
          num? price,
          num? amount,
          String? unit}) =>
      RecipeIngredients(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        amount: amount ?? this.amount,
        unit: unit ?? this.unit,
      );

  static RecipeIngredients fromJson(Map<String, Object?> json) => RecipeIngredients(
        id: json[RecipeIngredientsFields.id] as int?,
        name: json[RecipeIngredientsFields.name] as String,
        price: json[RecipeIngredientsFields.price] as num,
        amount: json[RecipeIngredientsFields.amount] as num,
        unit: json[RecipeIngredientsFields.unit] as String,
      );
}
