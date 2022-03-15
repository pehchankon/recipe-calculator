import 'package:flutter/material.dart';
import '../page/ingredients_page.dart';
import '../page/recipe_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipe Calc')),
      body: buildPage(),
    );
  }

  Widget buildPage() {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20),primary: Colors.black,padding: EdgeInsets.all(15));

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElevatedButton(
            style: style,
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => IngredientsPage()),
              );
            },
            child: const Text('Ingredients'),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: style,
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => RecipePage()),
              );
            },
            child: const Text('Recipe'),
          ),
        ],
      ),
    );
  }
}
