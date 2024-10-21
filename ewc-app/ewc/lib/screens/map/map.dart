import 'package:flutter/material.dart';
import 'package:ewc/widgets/login_textfeild.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RecycleNXT',
      style:TextStyle(fontFamily: 'Questrial', fontSize: 22),
      ),
      ),
      body: content(),
    );
  }
  Widget content() {
  return FlutterMap(
    options: MapOptions(
      initialCenter: LatLng(51.4545, -2.5879),
      initialZoom: 11,
      interactionOptions:
        const InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom),
    ),
    children: [
      openStreetMapTileLayer,
      MarkerLayer(markers: [
        Marker(
          point: LatLng(51.4545, -2.5879),
          width: 60,
          height: 60,
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.location_pin,
            size:60,
            color: Colors.red,

        )),
      ])
    ],
  );
}
}

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
);