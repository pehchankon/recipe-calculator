import 'package:sqflite/sqflite.dart';
import '../model/ingredient_model.dart';
import '../model/recipe_model.dart';
import '../database/recipe_ingredients_db.dart';

class IngredientsDB {
  static final IngredientsDB instance = IngredientsDB._init();

  static Database? _database;

  IngredientsDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('recipe_calculator.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + '/' + filePath;
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final doubleType = 'DECIMAL NOT NULL';

    await db.execute('''
      CREATE TABLE $tableIngredients (
        ${IngredientFields.id} $idType, 
        ${IngredientFields.name} $textType,
        ${IngredientFields.price} $doubleType,
        ${IngredientFields.unit} $textType,
        ${IngredientFields.amount} $doubleType)
    ''');
    await db.execute('''
      CREATE TABLE $tableRecipe (
        ${RecipeFields.id} $idType, 
        ${RecipeFields.name} $textType,
        ${RecipeFields.extraPrice} $doubleType,
        ${RecipeFields.weight} $doubleType,
        ${RecipeFields.unit} $textType,
        ${RecipeFields.notes} $textType,
        ${RecipeFields.totalPrice} $doubleType)
        ''');
  }

  Future<Ingredient> create(Ingredient ingredient) async {
    final db = await instance.database;
    final id = await db.insert(tableIngredients, ingredient.toJson());
    return ingredient.copy(id: id);
  }

  Future<List<Ingredient>> readAll() async {
    final db = await instance.database;
    final orderBy = '${IngredientFields.name} ASC';
    final result = await db.query(tableIngredients, orderBy: orderBy);

    return result.map((json) => Ingredient.fromJson(json)).toList();
  }

  Future<int> update(Ingredient ingredient) async {
    final db = await instance.database;
    await RecipeIngredientsDB.instance.update(ingredient);
    return await db.update(
      tableIngredients,
      ingredient.toJson(),
      where: '${IngredientFields.id} = ? ',
      whereArgs: [ingredient.id],
    );
  }

  Future<int> delete(int id) async {
    bool flag = false;
    final db = await instance.database;
    List<String> tableNames = await RecipeIngredientsDB.instance.findTables();
    for (var name in tableNames) {
      final result = await db
          .query(name, where: '${IngredientFields.id} = ?', whereArgs: [id]);
      // print(result);
      if (result.isNotEmpty) {
        flag = true;
        break;
      }
    }
    // print(flag);
    if (flag) {
      return -1;
    }

    return await db.delete(
      tableIngredients,
      where: '${IngredientFields.id} = ? ',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    _database = null;
    await db.close();
  }

  void nullDB() {
    _database = null;
  }
}
