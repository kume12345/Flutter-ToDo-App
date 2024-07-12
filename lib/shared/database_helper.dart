
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/todo.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  static const table = 'todo_table';
  static const columnId = 'id';
  static const columnCategoryId = 'categoryId';
  static const columnIsDone = 'isDone';
  static const columnDescription = 'description';

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE $table($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnCategoryId INTEGER, '
            '$columnIsDone INTEGER, $columnDescription TEXT)');
      },
    );
    return database;
  }

  // Fetch Operation: Get all todo objects from database
  Future<List<Map<String, dynamic>>> getTodoMapList() async {
    final db = await database;
    var result = await db.query(table);
    return result;
  }

  // Insert Operation: Insert a todo object to database
  Future<int> insertTodo(Map<String, dynamic> row) async {
    final db = await database;
    var result = await db.insert(table, row);
    return result;
  }

  // Update Operation: Update a todo object and save it to database
  Future<int> updateTodo(Map<String, dynamic> row) async {
    Database? db = await database;
    var result = await db!
        .update(table, row, where: '$columnId = ?', whereArgs: [row[columnId]]);
    return result;
  }

  // Delete Operation: Delete a todo object from database
  Future<int> deleteTodo(int id) async {
    Database? db = await database;
    int result =
        await db!.rawDelete('DELETE FROM $table WHERE $columnId = $id');
    return result;
  }

  // Get number of todo objects in database
  Future<int?> getCount() async {
    Database? db = await database;
    List<Map<String, dynamic>> x =
        await db!.rawQuery('SELECT COUNT (*) from $table');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Todo List' [ List<Todo> ]
  Future<List<Todo>> getTodoList() async {
    var todoMapList = await getTodoMapList(); // Get 'Map List' from database
    int? count =
        todoMapList.length; // Count the number of map entries in db table

    List<Todo> todoList = <Todo>[];
    // For loop to create a 'Todo List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      todoList.add(Todo.fromMap(todoMapList[i]));
    }
    return todoList;
  }
}
