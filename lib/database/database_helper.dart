import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'shift_logs.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE alerts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        alertType TEXT,
        location TEXT,
        description TEXT,
        isResolved INTEGER,
        urgencyLevel REAL,
        coordinates TEXT,
        timestamp TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE injuries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        injuryType TEXT,
        injuredPerson TEXT,
        location TEXT,
        coordinates TEXT,
        severity TEXT,
        timestamp TEXT,
        description TEXT,
        isResolved INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE issues (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        equipmentName TEXT,
        issueType TEXT,
        location TEXT,
        urgencyLevel REAL,
        timestamp TEXT,
        coordinates TEXT,
        description TEXT,
        isResolved INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        eventType TEXT,
        description TEXT,
        location TEXT,
        timestamp TEXT,
        isResolved INTEGER,
        coordinates TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle schema upgrades
  }

  Future<int> insertAlert(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('alerts', data);
  }

  Future<List<Map<String, dynamic>>> getAlerts() async {
    final db = await database;
    return await db.query('alerts');
  }

  Future<int> insertInjury(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('injuries', data);
  }

  Future<List<Map<String, dynamic>>> getInjuries() async {
    final db = await database;
    return await db.query('injuries');
  }

  Future<int> insertIssue(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('issues', data);
  }

  Future<List<Map<String, dynamic>>> getIssues() async {
    final db = await database;
    return await db.query('issues');
  }

  Future<int> insertEvent(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('events', data);
  }

  Future<List<Map<String, dynamic>>> getEvents() async {
    final db = await database;
    return await db.query('events');
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<void> resetDatabase() async {
    String path = join(await getDatabasesPath(), 'shift_logs.db');
    if (await databaseExists(path)) {
      // Delete the existing database file
      await deleteDatabase(path);
    }

    // Reinitialize the database
    _database = await _initDatabase();
  }
}
