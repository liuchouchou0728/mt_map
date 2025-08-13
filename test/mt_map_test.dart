import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_map/mt_map.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('MT Map Widget Tests', () {
    test('MtMapPosition constructor works', () {
      const position = MtMapPosition(
        latitude: 39.9042,
        longitude: 116.4074,
        zoom: 15.0,
      );
      expect(position.latitude, 39.9042);
      expect(position.longitude, 116.4074);
      expect(position.zoom, 15.0);
    });

    test('MtMapMarker constructor works', () {
      const marker = MtMapMarker(
        latitude: 39.9042,
        longitude: 116.4074,
        title: 'Test Marker',
        snippet: 'Test Description',
      );
      expect(marker.latitude, 39.9042);
      expect(marker.longitude, 116.4074);
      expect(marker.title, 'Test Marker');
      expect(marker.snippet, 'Test Description');
    });

    test('MtMapPolyline constructor works', () {
      const polyline = MtMapPolyline(
        points: [
          MtMapPosition(latitude: 39.9042, longitude: 116.4074),
          MtMapPosition(latitude: 39.9142, longitude: 116.4174),
        ],
        color: Colors.blue,
        width: 5.0,
      );
      expect(polyline.points.length, 2);
      expect(polyline.color, Colors.blue);
      expect(polyline.width, 5.0);
    });

    test('MtMapPolygon constructor works', () {
      const polygon = MtMapPolygon(
        points: [
          MtMapPosition(latitude: 39.9042, longitude: 116.4074),
          MtMapPosition(latitude: 39.9142, longitude: 116.4074),
          MtMapPosition(latitude: 39.9142, longitude: 116.4174),
        ],
        fillColor: Colors.green,
        strokeColor: Colors.red,
        strokeWidth: 2.0,
      );
      expect(polygon.points.length, 3);
      expect(polygon.fillColor, Colors.green);
      expect(polygon.strokeColor, Colors.red);
      expect(polygon.strokeWidth, 2.0);
    });

    test('MtMapStyle constructor works', () {
      const style = MtMapStyle(
        showTraffic: true,
        showBuildings: true,
        mapType: 'normal',
      );
      expect(style.showTraffic, true);
      expect(style.showBuildings, true);
      expect(style.mapType, 'normal');
    });

    test('MtMapWidgetParams constructor works', () {
      const params = MtMapWidgetParams(
        apiKey: 'test_api_key',
        initialPosition: MtMapPosition(
          latitude: 39.9042,
          longitude: 116.4074,
          zoom: 15.0,
        ),
        initialMarkers: [
          MtMapMarker(
            latitude: 39.9042,
            longitude: 116.4074,
            title: 'Test Marker',
          ),
        ],
      );
      expect(params.apiKey, 'test_api_key');
      expect(params.initialPosition?.latitude, 39.9042);
      expect(params.initialMarkers.length, 1);
    });

    test('MtMapWidgetCallbacks constructor works', () {
      const callbacks = MtMapWidgetCallbacks(
        onMapReady: null,
        onMapError: null,
        onMapClick: null,
        onMarkerClick: null,
        onCameraMove: null,
        onCameraIdle: null,
        onLocationUpdate: null,
      );
      expect(callbacks.onMapReady, null);
      expect(callbacks.onMapError, null);
      expect(callbacks.onMapClick, null);
      expect(callbacks.onMarkerClick, null);
      expect(callbacks.onCameraMove, null);
      expect(callbacks.onCameraIdle, null);
      expect(callbacks.onLocationUpdate, null);
    });

    test('MtMapMarker copyWith works', () {
      const original = MtMapMarker(
        latitude: 39.9042,
        longitude: 116.4074,
        title: 'Original',
        snippet: 'Original Description',
      );
      
      final updated = original.copyWith(
        id: 1,
        title: 'Updated',
        snippet: 'Updated Description',
      );
      
      expect(updated.id, 1);
      expect(updated.latitude, 39.9042);
      expect(updated.longitude, 116.4074);
      expect(updated.title, 'Updated');
      expect(updated.snippet, 'Updated Description');
    });

    test('MtMapStyle toMap works', () {
      const style = MtMapStyle(
        backgroundColor: Colors.black,
        showTraffic: true,
        showBuildings: true,
        showIndoorMap: false,
        mapType: 'satellite',
      );
      
      final map = style.toMap();
      expect(map['backgroundColor'], Colors.black.value);
      expect(map['showTraffic'], true);
      expect(map['showBuildings'], true);
      expect(map['showIndoorMap'], false);
      expect(map['mapType'], 'satellite');
    });
  });
}
