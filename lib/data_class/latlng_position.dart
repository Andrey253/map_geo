import 'package:latlong2/latlong.dart';

import 'package:map_test/data_class/double_latlng.dart';

class LatLngCircle {
  LatLng latLng;
  int timing;
  bool editing;
  List<DoubleLatLng> listDouobleLatLng;
  LatLngCircle({
    required this.latLng,
    required this.timing,
    required this.editing,
    required this.listDouobleLatLng,
  });

  LatLngCircle copyWith({
    LatLng? latLng,
    int? timing,
    bool? editing,
    List<DoubleLatLng>? markersCircle,
  }) {
    return LatLngCircle(
      latLng: latLng ?? this.latLng,
      timing: timing ?? this.timing,
      editing: editing ?? this.editing,
      listDouobleLatLng: markersCircle ?? this.listDouobleLatLng,
    );
  }
}
