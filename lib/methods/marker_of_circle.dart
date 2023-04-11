import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../data_class/latlng_position.dart';
import '../pages/tap_to_add.dart';

Marker markerOfCircle(LatLng latLng, double alpha, int timing, int smalOrBig) {
  return Marker(
    point: LatLng(
       latLng.latitude +
            sin(alpha) *
                ( timing+smalOrBig) *
                TapToAddPage.timingDistance /
                111195,
        latLng.longitude +
            (cos(alpha) *
                ( timing+smalOrBig) *
                TapToAddPage.timingDistance /
                111195 /
                (cos(latLng.latitude * pi / 180)))),
    builder: (ctx) =>
        Icon(Icons.lens, size: 5, color: smalOrBig == 0 ? Colors.blue : Colors.red),
  );
}

List<Marker> drawCirklePoints(LatLng latLng, int timing) {
  List<Marker> points = [];

  for (double alpha = 0; alpha < pi * 2; alpha += 0.1) {
    points.add(markerOfCircle(latLng, alpha,timing, 0));
    points.add(markerOfCircle(latLng, alpha,timing, 1));
  }
  return points;
}
