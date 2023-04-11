// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

class LatLngCircle {
  LatLng latLng;
  int timing;
  bool editing;
  List<Marker> points;
  LatLngCircle({
    required this.latLng,
    required this.timing,
    required this.editing,
    required this.points,
  });



  LatLngCircle copyWith({
    LatLng? latLng,
    int? timing,
    bool? editing,
    List<Marker>? points,
  }) {
    return LatLngCircle(
      latLng: latLng ?? this.latLng,
      timing: timing ?? this.timing,
      editing: editing ?? this.editing,
      points: points ?? this.points,
    );
  }
}
