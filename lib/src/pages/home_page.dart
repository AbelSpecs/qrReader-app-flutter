import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrreaderapp/src/bloc/scan_bloc.dart';
import 'package:qrreaderapp/src/models/scan_models.dart';
import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_pager.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScansBloc scans = new ScansBloc();
  int indexP = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                scans.borrarTodos();
              })
        ],
      ),
      body: Center(
        child: _pagina(indexP),
      ),
      bottomNavigationBar: _barra(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _scanner,
        child: Icon(Icons.filter_center_focus),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanner() async {
    //https://www3.animeflv.net/
    //geo:9.124977075040217,-67.5391139074219

    dynamic futureString;
    /* = 'https://www3.animeflv.net/';
    dynamic futureString2 = 'geo:9.124977075040217,-67.5391139074219';  */
    try {
      futureString = await BarcodeScanner.scan();
    } catch (e) {
      futureString = e.toString();
    }

    /* print('Future String:' + futureString.rawContent); */

    if (futureString != null) {
      final scan = ScanModel(valor: futureString);
      //DBProvider.db.nuevoScan(scan);
      scans.agregarScan(scan);
      //utils.abrirScan(scan);
    }
  }

  Widget _pagina(int pag) {
    switch (pag) {
      case 0:
        return MapaPage();
      case 1:
        return DireccionPage();
    }
  }

  Widget _barra() {
    return BottomNavigationBar(
        currentIndex: indexP,
        onTap: (int index) {
          setState(() {
            indexP = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Mapa'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.brightness_7),
            title: Text('Direcciones'),
          ),
        ]);
  }
}
