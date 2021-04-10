import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreaderapp/src/models/scan_models.dart';
import 'package:latlong/latlong.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  MapController mapController = new MapController();
  /* AnimationController animation = new AnimationController(); */
  String estilos = 'streets-v11';
  /* 'streets-v11',
    'light-v10',
    'dark-v10',
    'outdoors-v11',
    'satellite-v9' */

  @override
  Widget build(BuildContext context) {
    ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: [
          IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () {
                mapController.move(scan.getLatLng(), 10.0);
              })
        ],
      ),
      body: _crearflutterMap(scan),
      floatingActionButton: _floatingButton(context, scan),
    );
  }

  Widget _crearflutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 10.0,
      ),
      layers: [_crearMapa(), _crearMarcadores(scan)],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
        urlTemplate:
            'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1IjoiZWx0b3BvZGl2aW5vIiwiYSI6ImNrZjRnaTdjMTBjc2ozMHBqaHYydG9mNXcifQ.10j7gxGMO8HZoYCPFPnCOw',
          'id': 'mapbox/$estilos',
        });
  }

  _crearMarcadores(ScanModel scan) {
    return MarkerLayerOptions(markers: <Marker>[
      Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
                child: Icon(
                  Icons.location_on,
                  size: 50.0,
                  color: Theme.of(context).primaryColor,
                ),
              ))
    ]);
  }

  Widget _floatingButton(BuildContext context, ScanModel scan) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(Icons.repeat),
      onPressed: () {
        mapController.move(scan.getLatLng(), 40.0);
        Future.delayed(Duration(milliseconds: 500), () {
          mapController.move(scan.getLatLng(), 10.0);
        });

        setState(() {
          switch (estilos) {
            case 'streets-v11':
              estilos = 'light-v10';
              break;

            case 'light-v10':
              estilos = 'dark-v10';
              break;

            case 'dark-v10':
              estilos = 'outdoors-v11';
              break;

            case 'outdoors-v11':
              estilos = 'satellite-v9';
              break;

            case 'satellite-v9':
              return estilos = 'streets-v11';
              break;
          }
        });
      },
    );
  }
}
