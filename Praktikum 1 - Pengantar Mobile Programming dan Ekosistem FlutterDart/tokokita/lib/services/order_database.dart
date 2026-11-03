import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class OrderDatabase {
  static final OrderDatabase instance = OrderDatabase._init();
  static Database? _database;

  OrderDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tokokita_orders.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tanggal TEXT NOT NULL,
        daftarItem TEXT NOT NULL,
        totalHarga REAL NOT NULL,
        status TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertOrder(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('orders', row);
  }

  Future<List> getAllOrders() async {
    Database db = await instance.database;
    return await db.query('orders', orderBy: 'id DESC');
  }

  Future<int> updateOrderStatus(int id, String newStatus) async {
    Database db = await instance.database;
    return await db.update(
      'orders',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteOrder(int id) async {
    Database db = await instance.database;
    return await db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<List> searchOrders(String keyword) async {
    Database db = await instance.database;
    return await db.query(
      'orders',
      where: 'status LIKE ? OR daftarItem LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
      orderBy: 'id DESC',
    );
  }
}
