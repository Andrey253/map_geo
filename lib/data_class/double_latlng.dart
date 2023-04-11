import 'package:latlong2/latlong.dart';

class DoubleLatLng {
  LatLng big;
  LatLng small;
  DoubleLatLng({
    required this.big,
    required this.small,
  });

  DoubleLatLng copyWith({
    LatLng? dig,
    LatLng? small,
  }) {
    return DoubleLatLng(
      big: dig ?? this.big,
      small: small ?? this.small,
    );
  }
}
