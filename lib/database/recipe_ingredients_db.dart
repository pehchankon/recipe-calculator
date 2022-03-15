import 'package:sqflite/sqflite.dart';
import '../model/ingredient_model.dart';
import '../model/recipe_model.dart';
import '../model/recipe_ingredients_model.dart';

class RecipeIngredientsDB {
  static final RecipeIngredientsDB instance = RecipeIngredientsDB._init();

  static Database? _database;

  RecipeIngredientsDB._init();

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

  Future _createIngredientsTable(String name) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final doubleType = 'DECIMAL NOT NULL';

    final db = await instance.database;
    await db.execute('''
      CREATE TABLE $name (
        ${RecipeIngredientsFields.id} $idType, 
        ${RecipeIngredientsFields.name} $textType,
        ${RecipeIngredientsFields.price} $doubleType,
        ${RecipeIngredientsFields.amount} $doubleType,
        ${RecipeIngredientsFields.unit} $textType)
        ''');
  }

  Future create(String name, List<RecipeIngredients> ingredients) async {
    final db = await instance.database;
    await _checkTable(name);
    for (var ingredient in ingredients) {
      await db.insert(name + '_ingredients', ingredient.toJson());
    }
  }

  Future _checkTable(String name) async {
    name = name + '_ingredients';
    final db = await instance.database;
    var result =
        await db.query('sqlite_master', where: 'name = ?', whereArgs: [name]);
    if (result.isEmpty) {
      // print('yesssssssssssssssssss');
      await _createIngredientsTable(name);
    }
  }

  Future<List<String>> findTables() async {
    final db = await instance.database;
    final result = await db.query('sqlite_master',
        where: 'name LIKE \'%_ingredients\'', columns: ['name']);
    List<String> resultNames = [];
    for (var element in result) {
      resultNames.add(element['name'] as String);
    }
    return resultNames;
  }

  Future<List<RecipeIngredients>> readAll(String name) async {
    final db = await instance.database;
    await _checkTable(name);
    name = name + '_ingredients';
    final orderBy = '${RecipeIngredientsFields.name} ASC';
    final result = await db.query(name, orderBy: orderBy);

    return result.map((json) => RecipeIngredients.fromJson(json)).toList();
  }

  Future update(Ingredient ingredient) async {
    final db = await instance.database;
    List<String> names = await findTables();
    for (var name in names) {
      final result =
          await db.query(name, where: '_id = ?', whereArgs: [ingredient.id]);

      for (var element in result) {
        RecipeIngredients recipeIngredient =
            RecipeIngredients.fromJson(element);
        num tempPrice = recipeIngredient.price;
        recipeIngredient = recipeIngredient.copy(
          name: ingredient.name,
          price: num.parse(
              (ingredient.price * recipeIngredient.amount).toStringAsFixed(3)),
          unit: ingredient.unit,
        );
        await db.update(name, recipeIngredient.toJson(),
            where: '_id = ?', whereArgs: [ingredient.id]);
        String priceDifference =
            (recipeIngredient.price - tempPrice).toStringAsFixed(3);
        await db.rawUpdate(
            'UPDATE $tableRecipe SET ${RecipeFields.totalPrice} = ${RecipeFields.totalPrice} + $priceDifference');
      }
      // print(await readAll(recipeName));
    }
  }

  Future<int> delete(int id, String name) async {
    final db = await instance.database;
    await _checkTable(name);
    return await db.delete(
      name + '_ingredients',
      where: '${RecipeIngredientsFields.id} = ? ',
      whereArgs: [id],
    );
  }

  Future changeName(String orgName) async {
    final db = await instance.database;
    await _checkTable(orgName);
    await db.execute("DROP TABLE IF EXISTS $orgName");
  }

  Future deleteAll(String name) async {
    final db = await instance.database;
    await _checkTable(name);
    await db.delete(name + '_ingredients');
  }

  Future close() async {
    final db = await instance.database;
    _database = null;
    await db.close();
  }
}
