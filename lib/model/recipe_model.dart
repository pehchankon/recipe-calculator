const String tableRecipe = 'recipe';

class RecipeFields {
  static final List<String> values = [
    id,
    name,
    extraPrice,
    weight,
    notes,
    totalPrice,
    unit,
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String extraPrice = 'extra_price';
  static const String weight = 'weight';
  static const String notes = 'notes';
  static const String totalPrice = 'total_price';
  static const String unit = 'unit';
}

class Recipe {
  final int? id;
  final String name;
  final num extraPrice;
  final num weight;
  final String? notes;
  final num totalPrice;
  final String unit;

  const Recipe({
    this.id,
    required this.name,
    required this.extraPrice,
    required this.weight,
    required this.totalPrice,
    required this.unit,
    this.notes,
  });

  Map<String, Object?> toJson() => {
        RecipeFields.id: id,
        RecipeFields.name: name,
        RecipeFields.extraPrice: extraPrice,
        RecipeFields.weight: weight,
        RecipeFields.notes: notes ?? '',
        RecipeFields.totalPrice: totalPrice,
        RecipeFields.unit: unit,
      };

  Recipe copy(
          {int? id,
          String? name,
          num? extraPrice,
          num? weight,
          String? notes,
          num? totalPrice,
          String? unit}) =>
      Recipe(
        id: id ?? this.id,
        name: name ?? this.name,
        extraPrice: extraPrice ?? this.extraPrice,
        weight: weight ?? this.weight,
        notes: notes ?? this.notes,
        totalPrice: totalPrice ?? this.totalPrice,
        unit: unit ?? this.unit,
      );

  static Recipe fromJson(Map<String, Object?> json) => Recipe(
        id: json[RecipeFields.id] as int?,
        name: json[RecipeFields.name] as String,
        extraPrice: json[RecipeFields.extraPrice] as num,
        weight: json[RecipeFields.weight] as num,
        notes: json[RecipeFields.notes] as String?,
        totalPrice: json[RecipeFields.totalPrice] as num,
        unit: json[RecipeFields.unit] as String,
      );
}
