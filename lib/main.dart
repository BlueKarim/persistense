import 'package:flutter/material.dart';
import 'package:persistense/Dog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dogdb.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var beggie = Dog(id: 1, name: 'beggie', age: 40);
  var pug = Dog(id: 2, name: 'pug', age: 45);
  await DogDB.insertDog(beggie);
  await DogDB.insertDog(pug);
  print(await DogDB.dogs());
  await DogDB.deleteDog(1);
  print(await DogDB.dogs());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Shared preferences demo',
      home: MyHomePage(
        title: 'Shared preferences demo',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;
  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = (prefs.getInt('counter') ?? 0);
    });
  }

  void _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('You have pushed the button this many times: '),
          Text(
            '$counter',
            style: Theme.of(context).textTheme.headline4,
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
