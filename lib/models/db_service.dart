import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'dart:async';
import 'package:path/path.dart';
import 'package:todo_app/models/todo.dart';


class DBService {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  Future<Database> get database async {
    _db ??= await initDatabase();
    return _db!;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'todo.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE TodoTask (id TEXT PRIMARY KEY, todoDetails TEXT, isCompleted INTEGER, ondate TEXT, ontime TEXT, priority TEXT)');
  }

  Future<void> add(TodoTask task) async {
    final db = await database;
    await db.insert(
      'TodoTask',
      task.toMap(), // Convert the TodoTask to a Map
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TodoTask>> getTasks() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('TodoTask', columns: ['id', 'todoDetails', 'isCompleted', 'ondate', 'ontime', 'priority']);
    List<TodoTask> tasks = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        tasks.add(TodoTask.fromMap(maps[i] as Map<String, dynamic>)); // Cast to Map<String, dynamic>
      }
    }
    return tasks;
  }

  Future<int> delete(String id) async {
    var dbClient = await db;
    return await dbClient.delete('TodoTask', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(TodoTask task) async {
    final db = await database;
    return await db.update(
      'TodoTask',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}