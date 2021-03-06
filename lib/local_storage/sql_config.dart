import 'dart:async';
import 'package:excelapp_prototype/API/Events/eventsList_Class.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  //if our database exist in mobile, use it otherwise create it (creation done once)
  Future<Database> get database async {
    if(_database != null)
      return _database;
    
    // creating our database(done once)
    _database = await initDB();
    return _database;
  }

  initDB() async {
    // android SQLite path
    String databasePath = await getDatabasesPath();
    // Our database path
    String path = join(databasePath, 'TestDB.db');

    // once database is created, we define our tables inside it
    return await openDatabase(path,version: 1,onOpen: (db){},
    onCreate: (Database db,int version) async {
    await db.execute("CREATE TABLE EventList ("
      "id INTEGER PRIMARY KEY,"
      "name TEXT,"
      "icon TEXT,"
      "category TEXT"
      ")");
    });
  }


  // add event to database
  addEvent(Event event) async {
    final db = await database;
    await db.insert('EventList', event.toJson(),conflictAlgorithm: ConflictAlgorithm.replace);
  }


  // get list of all events from database
  Future<List<Event>> getEvents() async {
    final db = await database;

    // all the rows from table -- list of maps
    final List<Map<String,dynamic>> maps = await db.query('EventList');

    // convert list of maps to list of events
    return maps.map<Event>((row) => Event.fromJson(row)).toList();
  }

}