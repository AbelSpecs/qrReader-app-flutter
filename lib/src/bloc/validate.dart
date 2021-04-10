import 'dart:async';

import 'package:qrreaderapp/src/models/scan_models.dart';

class Validate {
  final validarGeo =
      StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
          handleData: (scans, sink) {
    final geoScan = scans.where((s) => s.tipo == 'geo').toList();
    sink.add(geoScan);
  });

  final validarHttp =
      StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
          handleData: (scans, sink) {
    final httpScan = scans.where((s) => s.tipo == 'http').toList();
    sink.add(httpScan);
  });
}
