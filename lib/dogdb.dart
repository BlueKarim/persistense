import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Dog.dart';

class DogDB {
  static late Database database;

  static Future<Database> initDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'doggie_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE dogs(""id INTERGER PRIMARY KEY","name TEXT","age INTEGER"")',
        );
      },
      version: 1,
    );
    return database;
  }

  static Future<Database> getDatabaseConnect() async {
    if (database != null) {
      return database;
    } else {
      return await initDatabase();
    }
  }

  static Future<List<Dog>> dogs() async {
    final Database db = await getDatabaseConnect();
    final List<Map<String, dynamic>> maps = await db.query('dogs');
    return List.generate(maps.length, (i) {
      return Dog(id: maps[i]['id'], name: maps[i]['name'], age: maps[i]['age']);
    });
  }

  static Future<void> insertDog(Dog dog) async {
    final Database db = await getDatabaseConnect();

    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateDog(Dog dog) async {
    final db = await getDatabaseConnect();
    await db.update('dogs', dog.toMap(), where: 'id = ?', whereArgs: [dog.id]);
  }

  static Future<void> deleteDog(int id) async {
    final db = await getDatabaseConnect();
    await db.delete('dogs', where: 'id = ?', whereArgs: [id]);
  }
}
