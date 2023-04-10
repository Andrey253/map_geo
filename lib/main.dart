import 'package:flutter/material.dart';
import 'package:map_test/pages/home.dart';

import 'package:map_test/pages/animated_map_controller.dart';
import 'package:map_test/pages/latlng_to_screen_point.dart';
import 'package:map_test/pages/marker_anchor.dart';
import 'package:map_test/pages/on_tap.dart';
import 'package:map_test/pages/plugin_scalebar.dart';
import 'package:map_test/pages/plugin_zoombuttons.dart';
import 'package:map_test/pages/point_to_latlng.dart';
import 'package:map_test/pages/tap_to_add.dart';
//cd D:/Flutter_apps/fast;flutter build web ; cd build/web;git add .;git commit -m "standart commit"; git push -u origin main
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map Example',
      theme: ThemeData(
        primarySwatch: mapBoxBlue,
      ),
      home: const HomePage(),
      routes: <String, WidgetBuilder>{
        TapToAddPage.route: (context) => const TapToAddPage(),
        AnimatedMapControllerPage.route: (context) =>
            const AnimatedMapControllerPage(),
        MarkerAnchorPage.route: (context) => const MarkerAnchorPage(),
        PluginScaleBar.route: (context) => const PluginScaleBar(),
        PluginZoomButtons.route: (context) => const PluginZoomButtons(),
        OnTapPage.route: (context) => const OnTapPage(),

        PointToLatLngPage.route: (context) => const PointToLatLngPage(),
        LatLngScreenPointTestPage.route: (context) =>
            const LatLngScreenPointTestPage(),

      },
    );
  }
}

// Generated using Material Design Palette/Theme Generator
// http://mcg.mbitson.com/
// https://github.com/mbitson/mcg
const int _bluePrimary = 0xFF395afa;
const MaterialColor mapBoxBlue = MaterialColor(
  _bluePrimary,
  <int, Color>{
    50: Color(0xFFE7EBFE),
    100: Color(0xFFC4CEFE),
    200: Color(0xFF9CADFD),
    300: Color(0xFF748CFC),
    400: Color(0xFF5773FB),
    500: Color(_bluePrimary),
    600: Color(0xFF3352F9),
    700: Color(0xFF2C48F9),
    800: Color(0xFF243FF8),
    900: Color(0xFF172EF6),
  },
);
