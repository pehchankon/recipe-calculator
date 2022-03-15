import 'package:sqflite/sqflite.dart';
import '../model/recipe_model.dart';
import '../model/ingredient_model.dart';

class RecipeDB {
  static final RecipeDB instance = RecipeDB._init();

  static Database? _database;

  RecipeDB._init();

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
        ${IngredientFields.unit} $textType)
    ''');
    await db.execute('''
      CREATE TABLE $tableRecipe (
        ${RecipeFields.id} $idType, 
        ${RecipeFields.name} $textType,
        ${RecipeFields.extraPrice} $doubleType,
        ${RecipeFields.weight} $doubleType,
        ${RecipeFields.unit} $textType,
        ${RecipeFields.notes} $textType,
        ${RecipeFields.totalPrice} $doubleType
        )''');
  }

  Future<int> create(Recipe recipe) async {
    final db = await instance.database;
    return await db.insert(tableRecipe, recipe.toJson());
  }

  Future<List<Recipe>> readAll() async {
    final db = await instance.database;
    final orderBy = '${RecipeFields.name} ASC';
    final result = await db.query(tableRecipe, orderBy: orderBy);

    return result.map((json) => Recipe.fromJson(json)).toList();
  }

  Future<int> update(Recipe recipe) async {
    final db = await instance.database;
    return await db.update(
      tableRecipe,
      recipe.toJson(),
      where: '${RecipeFields.id} = ? ',
      whereArgs: [recipe.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableRecipe,
      where: '${RecipeFields.id} = ? ',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    _database = null;
    await db.close();
  }
}
