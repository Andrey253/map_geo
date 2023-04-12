import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_test/data_class/double_latlng.dart';
import 'package:map_test/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

import '../data_class/latlng_position.dart';
import '../methods/calc.dart';
import '../methods/list_circles.dart';
import '../methods/marker_of_circle.dart';

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
  var p = 0.017453292519943295;

  List<Marker> allCircleMarkers = [];
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
    markers = getMarkers(tappedPoints, setState, (i) => index = i, isDeleting,
        () => isDeleting = false, reDrawCircleMarkers);

    var listLatLng = tappedPoints.map((e) => e.latLng).toList();
    if (markers.length > 1) {
      dist = calculateDistance(listLatLng[0], listLatLng[1]);
      // calculateDistanceTwo(listLatLng[0], listLatLng[1]);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tap to add pins'),
        actions: actions(
            tappedPoints,
            setState,
            index,
            isDeleting,
            () => setState(() => isDeleting = !isDeleting),
            (i) => index = i,
            reDrawCircleMarkers),
      ),
      drawer: buildDrawer(context, TapToAddPage.route),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Text(index != -1 ? tappedPoints[index].latLng.toString() : ''),
                Text(dist.toString()),
              ],
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
                    MarkerLayer(markers: allCircleMarkers),
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
    final latLngCircle = LatLngCircle(
        latLng: latlng,
        timing: 1,
        editing: false,
        listDouobleLatLng: drawCirklePoints(latlng, 1));
    tappedPoints.add(latLngCircle);
    index = tappedPoints.indexOf(latLngCircle);
    setState(() {});
  }

  void reDrawCircleMarkers() {
      allCircleMarkers.clear();
    if (tappedPoints.length > 1) {
      for (var d in tappedPoints[0].listDouobleLatLng) {
        for (var big in tappedPoints[1].listDouobleLatLng.map((e) => e.big)) {
          searchingArea(d, big);
        }
        for (var big in tappedPoints[1].listDouobleLatLng.map((e) => e.small)) {
          searchingArea(d, big);
        }
      }
      for (var d in tappedPoints[1].listDouobleLatLng) {
        for (var latLng
            in tappedPoints[0].listDouobleLatLng.map((e) => e.big)) {
          searchingArea(d, latLng);
        }
        for (var smal
            in tappedPoints[0].listDouobleLatLng.map((e) => e.small)) {
          searchingArea(d, smal);
        }
        //нарисовать и на третий, а последний убирет все лишнее
      // if(tappedPoints.length > 2){
      //    for (var smal
      //       in tappedPoints[2].listDouobleLatLng.map((e) => e.small)) {
      //     //  убираем лишние маркеры
      //   }
      // }
      //
      }
    }
    setState(() {});
  }

  void searchingArea(DoubleLatLng d, LatLng big) {
    if (condition(d, big)) {
      allCircleMarkers.add(Marker(
          point: big,
          builder: (context) =>
              const Icon(Icons.lens, size: 8, color: Colors.blue)));
    }
  }

  bool condition(DoubleLatLng d, LatLng l) {
    return ((d.big.latitude >= l.latitude &&
                d.small.latitude <= l.latitude) ||
            (d.big.latitude <= l.latitude &&
                d.small.latitude >= l.latitude)) &&
        //////
        ((d.big.longitude >= l.longitude &&
                d.small.longitude <= l.longitude) ||
            (d.big.longitude <= l.longitude &&
                d.small.longitude >= l.longitude));
  }
}

extension UpAndDoun on double {
  double up([double degree = 0.00002]) {
    return this > 0 ? this + degree : this - degree;
  }

  double down([double degree = 0.00002]) {
    return this < 0 ? this - degree : this + degree;
  }
}
