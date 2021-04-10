import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scan_bloc.dart';
import 'package:qrreaderapp/src/models/scan_models.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class MapaPage extends StatelessWidget {
  ScansBloc scan = new ScansBloc();
  @override
  Widget build(BuildContext context) {
    scan.obtenerScans();
    return StreamBuilder(
        stream: scan.scansStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final scans = snapshot.data;

          if (scans.length == 0) {
            return Center(child: Text('No hay informacion'));
          }

          return ListView.builder(
              itemCount: scans.length,
              itemBuilder: (context, i) => Dismissible(
                    onDismissed: (direction) {
                      scan.borrarScan(scans[i].id);
                    },
                    key: UniqueKey(),
                    background:
                        Container(color: Theme.of(context).primaryColor),
                    child: ListTile(
                      onTap: () {
                        if (Platform.isIOS) {
                          Future.delayed(Duration(milliseconds: 750));
                          utils.abrirScan(context, scans[i]);
                        } else {
                          utils.abrirScan(context, scans[i]);
                        }
                      },
                      leading: Icon(Icons.cloud_queue,
                          color: Theme.of(context).primaryColor),
                      title: Text(scans[i].valor),
                      subtitle: Text('ID: ${scans[i].id}'),
                      trailing:
                          Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                    ),
                  ));
        });
  }
}
