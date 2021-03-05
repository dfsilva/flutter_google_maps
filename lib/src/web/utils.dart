// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:js_util';
import 'dart:ui' as ui show Color;

import 'package:flinq/flinq.dart';
import 'package:google_directions_api/google_directions_api.dart' show GeoCoord, GeoCoordBounds;
import 'package:google_maps/google_maps.dart';

extension WebLatLngExtensions on LatLng {
  GeoCoord toGeoCoord() => GeoCoord(this.lat, this.lng);
}

extension WebGeoCoordExtensions on GeoCoord {
  LatLng toLatLng() => LatLng(this.latitude, this.longitude);
}

extension WebGeoCoordBoundsExtensions on GeoCoordBounds {
  LatLngBounds toLatLngBounds() => LatLngBounds(
        this.southwest.toLatLng(),
        this.northeast.toLatLng(),
      );

  GeoCoord get center => GeoCoord(
        (this.northeast.latitude + this.southwest.latitude) / 2,
        (this.northeast.longitude + this.southwest.longitude) / 2,
      );
}

extension WebLatLngBoundsExtensions on LatLngBounds {
  GeoCoordBounds toGeoCoordBounds() => GeoCoordBounds(
        northeast: this.northEast.toGeoCoord(),
        southwest: this.southWest.toGeoCoord(),
      );
}

extension WebColorExtensions on ui.Color {
  String toHashString() =>
      '#${this.red.toRadixString(16)}${this.green.toRadixString(16)}${this.blue.toRadixString(16)}';
}

extension WebMapStyleExtension on String {
  List _stylerFromMap(Map<String, dynamic> map) => [
        jsify({'color': map['color']}),
        jsify({'gamma': map['gamma']}),
        jsify({'hue': map['hue']}),
        jsify({'invertLightness': map['invertLightness']}),
        jsify({'lightness': map['lightness']}),
        jsify({'saturation': map['saturation']}),
        jsify({'visibility': map['visibility']}),
        jsify({'weight': map['weight']}),
      ];

  List<MapTypeStyle> parseMapStyle() {
    final List map = json.decode(this);
    return map.mapList(
      (style) => MapTypeStyle()
        ..elementType = style['elementType']
        ..featureType = style['featureType']
        ..stylers = (style['stylers'] as List)?.mapList(
          (styler) => _stylerFromMap(styler),
        ),
    );
  }
}
