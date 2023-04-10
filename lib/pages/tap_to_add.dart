import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_test/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

import '../data_class/latlng_position.dart';
import '../methods/calc.dart';
import '../methods/list_circles.dart';

class TapToAddPage extends StatefulWidget {
  static const String route = '/tap';

  const TapToAddPage({Key? key}) : super(key: key);
  static const double timingDistance = 535.0;
  @override
  State<StatefulWidget> createState() {
    return TapToAddPageState();
  }
}

class TapToAddPageState extends State<TapToAddPage> {
  List<LatLngCircle> tappedPoints = [];
  bool isDeleting = false;
  MapController mapController = MapController();
  int index = -1;
  var dist;
  List<Marker> markers = [];
  double x = 0;
  double y = 0;
  @override
  void initState() {
    // mapController.mapEventStream.listen((event) {
    //   print('teg mapEventStream ${event.source.index}');
    //   print('teg mapEventStream ${event.center}');
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    markers = getMarkers(tappedPoints, setState, (i) => index = i, isDeleting);

    var listLatLng = tappedPoints.map((e) => e.latLng).toList();
    if (markers.length > 1) {
      dist = calculateDistance(listLatLng[0], listLatLng[1]);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tap to add pins'),
        actions: actions(tappedPoints, setState, index, isDeleting,
            () => setState(() => isDeleting = !isDeleting), (i) => index = i),
      ),
      drawer: buildDrawer(context, TapToAddPage.route),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                  index != -1 ? tappedPoints[index].latLng.toString() : ''),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text(dist.toString()),
            ),
            Flexible(
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerMove: (event) {
                  if (index < tappedPoints.length && index != -1) {
                    tappedPoints[index] = tappedPoints[index].copyWith(
                        latLng: LatLng(
                            tappedPoints[index].latLng.latitude -
                                (event.original?.localDelta.dy ?? 0) *
                                    0.00005 *
                                    (19 - mapController.zoom),
                            tappedPoints[index].latLng.longitude +
                                (event.original?.localDelta.dx ?? 0) *
                                    0.00005 *
                                    (19 - mapController.zoom)));

                    setState(() {});
                  }
                },
                child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                      maxZoom: 18,
                      minZoom: 3,
                      center: LatLng(45.5231, -122.6765),
                      zoom: 13,
                      onTap: _handleTap),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      // userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    ),
                    CircleLayer(circles: getListCircles(tappedPoints)),
                    PolylineLayer(
                      polylines: [Polyline(points: listLatLng)],
                    ),
                    MarkerLayer(markers: markers),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      final latLngCircle =
          LatLngCircle(latLng: latlng, timing: 1, editing: false);
      tappedPoints.add(latLngCircle);
      index = tappedPoints.indexOf(latLngCircle);
    });
  }
}
