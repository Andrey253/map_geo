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
  List<LatLngPosition> tappedPoints = [];
  bool isDeleting = false;
  MapController mapController = MapController();
  int index = -1;
  List<Marker> markers = [];
  double x = 0;
  double y = 0;
  @override
  void initState() {
    mapController.mapEventStream.listen((event) {
      print('teg ${event.source.index}');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    markers = tappedPoints.asMap().entries.map((entri) {
      return Marker(
        width: 80,
        height: 80,
        point: entri.value.latLng,
        builder: (ctx) => GestureDetector(
          child: Icon(Icons.place),
          onLongPressMoveUpdate: (details) {
            print('teg localOffsetFromOrigin ${details.localOffsetFromOrigin}');
            print('teg globalPosition ${details.globalPosition}');
            print('teg localPosition ${details.localPosition}');
            print('teg offsetFromOrigin ${details.offsetFromOrigin}');
            tappedPoints[entri.key] = LatLngPosition(
                latLng: LatLng(
                    entri.value.latLng.latitude -
                        (details.globalPosition.dy -entri.value.y) *
                        0.0002,
                    entri.value.latLng.longitude +
                        (details.globalPosition.dx -entri.value.x) *
                        0.0002),
                x:details.globalPosition.dx,y:details.globalPosition.dy
                    );
            setState(() {});
          },
          onLongPressUp: () {
            index = tappedPoints.indexOf(entri.value);
            print('teg onLongPressUp ${index}');
          },
          onLongPress: () {
            index = tappedPoints.indexOf(entri.value);
            print('teg onLongPress ${index}');

            if (isDeleting) tappedPoints.remove(entri);

            setState(() {});
          },
          onTapUp: (details) =>
              {print('teg onTapUp ${details.globalPosition}')},
        ),
      );
    }).toList();
    final circleMarkers = tappedPoints
        .map((e) => CircleMarker(
            point: e.latLng,
            color: Colors.blue.withOpacity(0.3),
            borderStrokeWidth: 2,
            useRadiusInMeter: true,
            radius: 535.19 // 2000 meters | 2 km
            ))
        .toList()
      ..addAll(tappedPoints.map((e) => CircleMarker(
          point: e.latLng,
          color: Colors.blue.withOpacity(0.0),
          borderStrokeWidth: 2,
          useRadiusInMeter: true,
          radius: 1000.19 // 2000 meters | 2 km
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
                      color: Colors.white, child: Text('Удалить вышку')))
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
                  print('teg position ${event.position}');
                  print('teg distance ${event.position.distance}');
                  print(
                      'teg distanceSquared ${event.position.distanceSquared}');
                  print('teg dx ${event.position.dx}');
                  print('teg dy ${event.position.dy}');
                },
                // onPointerHover: (event) {
                //   print('teg direction ${event.position.direction}');
                //   print('teg distance ${event.position.distance}');
                //   print(
                //       'teg distanceSquared ${event.position.distanceSquared}');
                //   print('teg dx ${event.position.dx}');
                //   print('teg dy ${event.position.dy}');
                // },
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
      tappedPoints
          .add(LatLngPosition(latLng: latlng, x: tapPosition.global.dx,y:tapPosition.global.dy ));
      // print('teg x ${tapPosition.relative?.dx} y ${tapPosition.relative?.dy}');
    });
  }
}
