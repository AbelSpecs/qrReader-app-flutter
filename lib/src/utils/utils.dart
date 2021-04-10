import 'package:qrreaderapp/src/models/scan_models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

abrirScan(BuildContext context, ScanModel scan) async {
  if (scan.tipo == 'http') {
    if (await canLaunch(scan.valor)) {
      await launch(scan.valor);
    } else {
      throw 'No se puede abrir ${scan.valor}';
    }
  } else {
    //print('Geo..');

    Navigator.pushNamed(context, 'mapa', arguments: scan);
  }
}
