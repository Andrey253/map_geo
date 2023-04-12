import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../data_class/double_latlng.dart';
import '../pages/tap_to_add.dart';

List<Marker> markerOfCircle(List<LatLng> latLngList, bool big) {
  return latLngList
      .map((e) => Marker(
            point: e,
            builder: (ctx) => Icon(Icons.lens,
                size: 5, color: big ? Colors.blue : Colors.red),
          ))
      .toList();
}

List<DoubleLatLng> drawCirklePoints(LatLng latLng, int timing) {
  List<DoubleLatLng> points = [];
  const t = 1.005;
  for (double alpha = 0; alpha < pi * 2; alpha += 0.1) {
    points.add(DoubleLatLng(
        big: LatLng(
            latLng.latitude +
                sin(alpha) *
                    (timing + 1) *
                    TapToAddPage.timingDistance *t/
                    111195,
            latLng.longitude +
                (cos(alpha) *
                    (timing + 1) *
                    TapToAddPage.timingDistance*t /
                    111195 /
                    (cos(latLng.latitude * pi / 180)))),
        small: LatLng(
            latLng.latitude +
                sin(alpha) * (timing) * TapToAddPage.timingDistance*t / 111195,
            latLng.longitude +
                (cos(alpha) *
                    (timing) *
                    TapToAddPage.timingDistance *t/
                    111195 /
                    (cos(latLng.latitude * pi / 180))))));
  }

  return points;
}
