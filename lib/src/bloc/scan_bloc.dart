import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/validate.dart';
import 'package:qrreaderapp/src/models/scan_models.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

class ScansBloc with Validate {
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    //Obtiene los scans de la base de datos
  }

  final _scansController = new StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream =>
      _scansController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scansStreamHttp =>
      _scansController.stream.transform(validarHttp);

  dispose() {
    _scansController?.close();
  }

  obtenerScans() async {
    _scansController.sink.add(await DBProvider.db.getTodosScans());
  }

  agregarScan(ScanModel nuevoScan) async {
    await DBProvider.db.nuevoScan(nuevoScan);
    obtenerScans();
  }

  borrarScan(int id) async {
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarTodos() async {
    await DBProvider.db.deleteAll();
    obtenerScans();
  }
}
