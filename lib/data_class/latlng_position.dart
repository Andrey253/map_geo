import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LatLngCircle {
  LatLng latLng;
  int timing;
  bool editing;
  List<Marker> markersBigCircle;
  List<Marker> markersSmallCircle;
  LatLngCircle({
    required this.latLng,
    required this.timing,
    required this.editing,
    required this.markersBigCircle,
    required this.markersSmallCircle,
  });


  LatLngCircle copyWith({
    LatLng? latLng,
    int? timing,
    bool? editing,
    List<Marker>? markersBigCircle,
    List<Marker>? markersSmallCircle,
  }) {
    return LatLngCircle(
      latLng: latLng ?? this.latLng,
      timing: timing ?? this.timing,
      editing: editing ?? this.editing,
      markersBigCircle: markersBigCircle ?? this.markersBigCircle,
      markersSmallCircle: markersSmallCircle ?? this.markersSmallCircle,
    );
  }

 
}
