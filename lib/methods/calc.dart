import 'dart:math';

import 'package:latlong2/latlong.dart';

double calculateDistance(LatLng e1, LatLng e2) {
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((e2.latitude - e1.latitude) * p) / 2 +
      cos(e1.latitude * p) *
          cos(e2.latitude * p) *
          (1 - cos((e2.longitude - e1.longitude) * p)) /
          2;
  return 12742000 * asin(sqrt(a));
}

double calculateDistanceTwo(LatLng latLng0, LatLng latLng1) {

  final d = pow((latLng1.latitude - latLng0.latitude) * 111195, 2) +
      pow((latLng1.longitude - latLng0.longitude) * 111195, 2);
print('teg(latLng1.latitude  ${latLng1.latitude}');
print('teg latLng1.longitude ${latLng1.longitude}');


  return sqrt(d);
}
