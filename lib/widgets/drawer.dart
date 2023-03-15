import 'package:flutter/material.dart';

import 'package:map_test/pages/animated_map_controller.dart';
import 'package:map_test/pages/latlng_to_screen_point.dart';
import 'package:map_test/pages/marker_anchor.dart';
import 'package:map_test/pages/on_tap.dart';
import 'package:map_test/pages/plugin_scalebar.dart';
import 'package:map_test/pages/plugin_zoombuttons.dart';
import 'package:map_test/pages/point_to_latlng.dart';
import 'package:map_test/pages/tap_to_add.dart';

Widget _buildMenuItem(
    BuildContext context, Widget title, String routeName, String currentRoute) {
  final isSelected = routeName == currentRoute;

  return ListTile(
    title: title,
    selected: isSelected,
    onTap: () {
      if (isSelected) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, routeName);
      }
    },
  );
}

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(shrinkWrap: false,
      children: <Widget>[



        _buildMenuItem(
          context,
          const Text('Tap to Add Pins'),
          TapToAddPage.route,
          currentRoute,
        ),
       
         
        _buildMenuItem(
          context,
          const Text('Animated MapController'),
          AnimatedMapControllerPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Marker Anchors'),
          MarkerAnchorPage.route,
          currentRoute,
        ),
      
        _buildMenuItem(
          context,
          const Text('ScaleBar Plugins'),
          PluginScaleBar.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('ZoomButtons Plugins'),
          PluginZoomButtons.route,
          currentRoute,
        ),
       
        _buildMenuItem(
          context,
          const Text('OnTap'),
          OnTapPage.route,
          currentRoute,
        ),
 
      
  
       
        _buildMenuItem(context, const Text('Point to LatLng'),
            PointToLatLngPage.route, currentRoute),
        _buildMenuItem(context, const Text('LatLng to ScreenPoint'),
            LatLngScreenPointTestPage.route, currentRoute),


      ],
    ),
  );
}
