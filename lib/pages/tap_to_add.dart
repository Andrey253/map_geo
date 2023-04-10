import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_test/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

import '../data_class/latlng_position.dart';

class TapToAddPage extends StatefulWidget {
  static const String route = '/tap';

  const TapToAddPage({Key? key}) : super(key: key);

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
  double timingDistance = 535.0;
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
    markers = tappedPoints.map((entri) {
      return Marker(
        width: 80,
        height: 80,
        point: entri.latLng,
        builder: (ctx) => GestureDetector(
            child: Icon(Icons.place),
            onTap: () {
              index = tappedPoints.indexOf(entri);
              entri.editing = !entri.editing;
              if (isDeleting) {
                index = -1;
                tappedPoints.remove(entri);
              }
              setState(() {});
            },
            onLongPressUp: () => setState(() {
                  index = -1;
                }),
            onLongPress: () {
              index = tappedPoints.indexOf(entri);
              print('teg onLongPress ${index}');

              if (isDeleting) tappedPoints.remove(entri);

              setState(() {});
            },
            onTapUp: (details) => index = -1),
      );
    }).toList();
    final circleMarkers = tappedPoints
        .map((e) => CircleMarker(
            point: e.latLng,
            color: Colors.black.withOpacity(0.2),
            borderStrokeWidth: 1,
            useRadiusInMeter: true,
            borderColor: Colors.white,
            radius: timingDistance * e.timing // 2000 meters | 2 km
            ))
        .toList()
      ..addAll(tappedPoints.map((e) => CircleMarker(
          point: e.latLng,
          color: Colors.black.withOpacity(0.0),
          borderColor: Colors.black,
          borderStrokeWidth: 1,
          useRadiusInMeter: true,
          radius: timingDistance * (e.timing + 1) // 2000 meters | 2 km
          )));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tap to add pins'),
        actions: [
          TextButton(
              onPressed: () => setState(() {
                    isDeleting = !isDeleting;
                  }),
              child: isDeleting
                  ? ColoredBox(
                      color: Colors.white,
                      child: Text('Нажмите на маркер для удаления'))
                  : ColoredBox(
                      color: Colors.white, child: Text('Удалить вышку'))),
          Container(
              width: 100,
              color: Colors.orange,
              child: Row(
                children: [
                  Text(
                      index != -1 ? tappedPoints[index].timing.toString() : ''),
                  Column(
                    children: [
                      IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => setState(() {
                                tappedPoints[index].timing =
                                    tappedPoints[index].timing + 1;
                              }),
                          icon: Icon(Icons.add_circle)),
                      IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => setState(() {
                                if (tappedPoints[index].timing == 0) return;
                                tappedPoints[index].timing =
                                    tappedPoints[index].timing - 1;
                              }),
                          icon: Icon(Icons.do_not_disturb_on))
                    ],
                  )
                ],
              ))
        ],
      ),
      drawer: buildDrawer(context, TapToAddPage.route),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Tap to add pins'),
            ),
            Flexible(
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerMove: (event) {
                  print('teg localDelta x ${event.original?.localDelta.dx}');
                  print('teg localDelta y ${event.original?.localDelta.dy}');
                  if (index < tappedPoints.length && index != -1) {
                    tappedPoints[index] = tappedPoints[index].copyWith(
                        latLng: LatLng(
                            tappedPoints[index].latLng.latitude -
                                (event.original?.localDelta.dy ?? 0) * 0.0002,
                            tappedPoints[index].latLng.longitude +
                                (event.original?.localDelta.dx ?? 0) * 0.0002));
                    setState(() {});
                  }
                },
                child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                      center: LatLng(45.5231, -122.6765),
                      zoom: 13,
                      onTap: _handleTap),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    ),
                    CircleLayer(circles: circleMarkers),
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
      final latLngCircle = LatLngCircle(latLng: latlng, timing: 1, editing: false);
      tappedPoints.add(latLngCircle);
      index = tappedPoints.indexOf(latLngCircle);
    });
  }
}
