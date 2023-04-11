import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_test/methods/marker_of_circle.dart';

import '../data_class/latlng_position.dart';
import '../pages/tap_to_add.dart';

List<CircleMarker> getListCircles(List<LatLngCircle> tappedPoints) {
  return tappedPoints
      .map((e) => CircleMarker(
          point: e.latLng,
          color: Colors.black.withOpacity(0.2),
          borderStrokeWidth: 1,
          useRadiusInMeter: true,
          borderColor: Colors.white,
          radius: TapToAddPage.timingDistance * e.timing // 2000 meters | 2 km
          ))
      .toList()
    ..addAll(tappedPoints.map((e) => CircleMarker(
        point: e.latLng,
        color: Colors.black.withOpacity(0.0),
        borderColor: Colors.black,
        borderStrokeWidth: 1,
        useRadiusInMeter: true,
        radius:
            TapToAddPage.timingDistance * (e.timing + 1) // 2000 meters | 2 km
        )));
}

List<Marker> getMarkers(
    List<LatLngCircle> tappedPoints,
    void Function(Function()) setS,
    Function(int) setIndex,
    bool isDeleting,
    Function() resetdELETING,
    Function() reDrow) {
  return tappedPoints.map((entri) {
    return Marker(
      width: 80,
      height: 80,
      point: entri.latLng,
      builder: (ctx) => GestureDetector(
          child: Icon(Icons.place),
          onTap: () => setS(() {
                setIndex(tappedPoints.indexOf(entri));
                entri.editing = !entri.editing;
                if (isDeleting) {
                  setIndex(-1);
                  tappedPoints.remove(entri);
                  resetdELETING();
                }
              }),
          onLongPressUp: () => setS(() {
                setIndex(-1);
                entri.listDouobleLatLng =
                    drawCirklePoints(entri.latLng, entri.timing);

                reDrow();
              }),
          onLongPress: () => setS(() {
                setIndex(tappedPoints.indexOf(entri));

                // if (isDeleting) {
                //   tappedPoints.remove(entri);
                //   resetdELETING();
                // }
              }),
          onTapUp: (details) => setIndex(-1)),
    );
  }).toList();
}

List<Widget> actions(
    List<LatLngCircle> tappedPoints,
    void Function(Function()) setS,
    int index,
    bool isDeleting,
    Function() reversIsDeleting,
    Function(int) setIndex,
    Function() reDraw) {
  return [
    TextButton(
        onPressed: reversIsDeleting,
        child: isDeleting
            ? ColoredBox(
                color: Colors.white,
                child: Text('Нажмите на маркер для удаления'))
            : ColoredBox(color: Colors.white, child: Text('Удалить вышку'))),
    IconButton(
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
        onPressed: reDraw,
        icon: const Icon(Icons.refresh_outlined)),
    Container(
        width: 100,
        color: Colors.orange,
        child: Row(
          children: [
            IconButton(
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                onPressed: () => setS(() {
                      setIndex(-1);
                    }),
                icon: const Icon(Icons.highlight_off)),
            SizedBox(
              width: 20,
              child: Center(
                child: Text(
                    index != -1 ? tappedPoints[index].timing.toString() : ''),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    constraints: BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: () => setS(() {
                          if (index == -1) return;
                          tappedPoints[index].timing =
                              tappedPoints[index].timing + 1;
                          tappedPoints[index].listDouobleLatLng =
                              drawCirklePoints(tappedPoints[index].latLng,
                                  tappedPoints[index].timing);

                          reDraw();
                        }),
                    icon: Icon(Icons.add_circle)),
                IconButton(
                    constraints: BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: () => setS(() {
                          if (index == -1) return;
                          if (tappedPoints[index].timing == 0) return;
                          tappedPoints[index].timing =
                              tappedPoints[index].timing - 1;
                          tappedPoints[index].listDouobleLatLng =
                              drawCirklePoints(tappedPoints[index].latLng,
                                  tappedPoints[index].timing);
   
                          reDraw();
                        }),
                    icon: Icon(Icons.do_not_disturb_on))
              ],
            )
          ],
        ))
  ];
}
