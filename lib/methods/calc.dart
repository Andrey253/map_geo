import 'dart:math';

import 'package:latlong2/latlong.dart';

double calculateDistance(LatLng latLng0, LatLng latLng1) {
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((latLng1.latitude - latLng0.latitude) * p) / 2 +
      cos(latLng0.latitude * p) *
          cos(latLng1.latitude * p) *
          (1 - cos((latLng1.longitude - latLng0.longitude) * p)) /
          2;
  return 12742000 * asin(sqrt(a));
}
