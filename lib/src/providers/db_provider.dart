import 'dart:io';

import 'package:path/path.dart';
import 'package:qrreaderapp/src/models/scan_models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Scans('
          'id INTEGER PRIMARY KEY not null,'
          'tipo TEXT,'
          'valor TEXT'
          ')');
    });
  }

  //CREAR REGISTROS

  Future<int> nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    final resp = await db.insert('Scans', nuevoScan.toJson());
    return resp;
  }

  //SELECT

  Future<ScanModel> getScanId(int id) async {
    final db = await database;
    final resp = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return resp.isNotEmpty ? ScanModel.fromJson(resp.first) : null;
  }

  Future<List<ScanModel>> getTodosScans() async {
    final db = await database;
    final resp = await db.query('Scans');

    List<ScanModel> list =
        resp.isNotEmpty ? resp.map((c) => ScanModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<ScanModel>> getTipo(String tipo) async {
    final db = await database;
    final resp = await db.query('Scans', where: 'tipo = ?', whereArgs: [tipo]);

    List<ScanModel> list =
        resp.isNotEmpty ? resp.map((l) => ScanModel.fromJson(l)).toList() : [];

    return list;
  }

  //Actualizar registros
  Future<int> updateScan(ScanModel nuevoScan) async {
    final db = await database;
    final resp = await db.update('Scans', nuevoScan.toJson(),
        where: 'id = ?', whereArgs: [nuevoScan.id]);
    return resp;
  }

  Future<int> deleteScan(int id) async {
    final db = await database;
    final resp = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return resp;
  }

  Future<int> deleteAll() async {
    final db = await database;
    final resp = await db.delete('Scans');
    return resp;
  }
}
