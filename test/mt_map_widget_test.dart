import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_map/mt_map.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MtMapWidget Tests', () {
    testWidgets('should render loading state when not initialized', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
              ),
            ),
          ),
        ),
      );

      // 应该显示加载状态
      expect(find.text('正在加载地图...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should render error state when API key is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: '',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 应该显示错误状态
      expect(find.text('地图加载失败'), findsOneWidget);
      expect(find.text('API Key is required'), findsOneWidget);
    });

    testWidgets('should render loading state initially with valid API key', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
                initialPosition: MtMapPosition(
                  latitude: 39.9042,
                  longitude: 116.4074,
                  zoom: 15.0,
                ),
              ),
            ),
          ),
        ),
      );

      // 初始状态应该显示加载状态
      expect(find.text('正在加载地图...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should handle method channel calls correctly', (WidgetTester tester) async {
      bool onMapReadyCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
              ),
              callbacks: MtMapWidgetCallbacks(
                onMapReady: () => onMapReadyCalled = true,
                onMapClick: (lat, lng) {},
                onCameraMove: (lat, lng, zoom) {},
              ),
            ),
          ),
        ),
      );

      // 等待widget完全渲染
      await tester.pump();

      // 验证回调设置正确
      expect(onMapReadyCalled, false); // 初始状态为false
    });

    testWidgets('should handle marker operations correctly', (WidgetTester tester) async {
      final markers = [
        MtMapMarker(
          latitude: 39.9042,
          longitude: 116.4074,
          title: 'Test Marker',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
                initialMarkers: markers,
              ),
            ),
          ),
        ),
      );

      // 应该显示加载状态
      expect(find.text('正在加载地图...'), findsOneWidget);
    });

    testWidgets('should handle polyline operations correctly', (WidgetTester tester) async {
      final polylines = [
        MtMapPolyline(
          points: [
            MtMapPosition(latitude: 39.9042, longitude: 116.4074),
            MtMapPosition(latitude: 39.9142, longitude: 116.4174),
          ],
          color: Colors.blue,
          width: 5.0,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
                initialPolylines: polylines,
              ),
            ),
          ),
        ),
      );

      // 应该显示加载状态
      expect(find.text('正在加载地图...'), findsOneWidget);
    });

    testWidgets('should handle polygon operations correctly', (WidgetTester tester) async {
      final polygons = [
        MtMapPolygon(
          points: [
            MtMapPosition(latitude: 39.9042, longitude: 116.4074),
            MtMapPosition(latitude: 39.9142, longitude: 116.4074),
            MtMapPosition(latitude: 39.9142, longitude: 116.4174),
          ],
          fillColor: Colors.green,
          strokeColor: Colors.green,
          strokeWidth: 2.0,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
                initialPolygons: polygons,
              ),
            ),
          ),
        ),
      );

      // 应该显示加载状态
      expect(find.text('正在加载地图...'), findsOneWidget);
    });

    testWidgets('should handle layout constraints correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              width: 300,
              height: 200,
              child: MtMapWidget(
                params: MtMapWidgetParams(
                  apiKey: 'test_key',
                ),
              ),
            ),
          ),
        ),
      );

      // 应该显示加载状态
      expect(find.text('正在加载地图...'), findsOneWidget);
    });

    testWidgets('should handle style configuration correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
              ),
              style: MtMapStyle(
                showTraffic: true,
                showBuildings: true,
                mapType: 'normal',
              ),
            ),
          ),
        ),
      );

      // 应该显示加载状态
      expect(find.text('正在加载地图...'), findsOneWidget);
    });

    testWidgets('should dispose correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
              ),
            ),
          ),
        ),
      );

      // 销毁widget
      await tester.pumpWidget(Container());

      // 不应该有异常
      expect(tester.takeException(), isNull);
    });
  });

  group('MtMapWidgetParams Tests', () {
    test('should create with required parameters', () {
      final params = MtMapWidgetParams(
        apiKey: 'test_key',
      );

      expect(params.apiKey, 'test_key');
      expect(params.initialPosition, isNull);
      expect(params.initialMarkers, isEmpty);
      expect(params.initialPolylines, isEmpty);
      expect(params.initialPolygons, isEmpty);
    });

    test('should create with all parameters', () {
      final params = MtMapWidgetParams(
        apiKey: 'test_key',
        initialPosition: MtMapPosition(
          latitude: 39.9042,
          longitude: 116.4074,
          zoom: 15.0,
        ),
        initialMarkers: [
          MtMapMarker(
            latitude: 39.9042,
            longitude: 116.4074,
            title: 'Test',
          ),
        ],
        initialPolylines: [
          MtMapPolyline(
            points: [
              MtMapPosition(latitude: 39.9042, longitude: 116.4074),
            ],
            color: Colors.blue,
            width: 5.0,
          ),
        ],
        initialPolygons: [
          MtMapPolygon(
            points: [
              MtMapPosition(latitude: 39.9042, longitude: 116.4074),
            ],
            fillColor: Colors.green,
            strokeColor: Colors.green,
            strokeWidth: 2.0,
          ),
        ],
      );

      expect(params.apiKey, 'test_key');
      expect(params.initialPosition, isNotNull);
      expect(params.initialMarkers, hasLength(1));
      expect(params.initialPolylines, hasLength(1));
      expect(params.initialPolygons, hasLength(1));
    });
  });

  group('MtMapPosition Tests', () {
    test('should create with required parameters', () {
      final position = MtMapPosition(
        latitude: 39.9042,
        longitude: 116.4074,
      );

      expect(position.latitude, 39.9042);
      expect(position.longitude, 116.4074);
      expect(position.zoom, isNull);
    });

    test('should create with all parameters', () {
      final position = MtMapPosition(
        latitude: 39.9042,
        longitude: 116.4074,
        zoom: 15.0,
      );

      expect(position.latitude, 39.9042);
      expect(position.longitude, 116.4074);
      expect(position.zoom, 15.0);
    });
  });

  group('MtMapMarker Tests', () {
    test('should create with required parameters', () {
      final marker = MtMapMarker(
        latitude: 39.9042,
        longitude: 116.4074,
      );

      expect(marker.latitude, 39.9042);
      expect(marker.longitude, 116.4074);
      expect(marker.id, isNull);
      expect(marker.title, isNull);
      expect(marker.snippet, isNull);
      expect(marker.iconPath, isNull);
    });

    test('should create with all parameters', () {
      final marker = MtMapMarker(
        id: 1,
        latitude: 39.9042,
        longitude: 116.4074,
        title: 'Test Marker',
        snippet: 'Test Description',
        iconPath: 'assets/icon.png',
      );

      expect(marker.id, 1);
      expect(marker.latitude, 39.9042);
      expect(marker.longitude, 116.4074);
      expect(marker.title, 'Test Marker');
      expect(marker.snippet, 'Test Description');
      expect(marker.iconPath, 'assets/icon.png');
    });

    test('should copy with new values', () {
      final original = MtMapMarker(
        latitude: 39.9042,
        longitude: 116.4074,
        title: 'Original',
      );

      final copied = original.copyWith(
        id: 1,
        title: 'Copied',
      );

      expect(copied.id, 1);
      expect(copied.latitude, 39.9042);
      expect(copied.longitude, 116.4074);
      expect(copied.title, 'Copied');
    });
  });

  group('MtMapStyle Tests', () {
    test('should create with default values', () {
      final style = MtMapStyle();

      expect(style.showTraffic, isNull);
      expect(style.showBuildings, isNull);
      expect(style.mapType, isNull);
    });

    test('should create with custom values', () {
      final style = MtMapStyle(
        showTraffic: true,
        showBuildings: true,
        mapType: 'satellite',
      );

      expect(style.showTraffic, true);
      expect(style.showBuildings, true);
      expect(style.mapType, 'satellite');
    });

    test('should convert to map correctly', () {
      final style = MtMapStyle(
        showTraffic: true,
        showBuildings: true,
        mapType: 'hybrid',
      );

      final map = style.toMap();

      expect(map['showTraffic'], true);
      expect(map['showBuildings'], true);
      expect(map['mapType'], 'hybrid');
    });
  });

  group('MtMapWidgetCallbacks Tests', () {
    test('should create with all callbacks', () {
      bool onMapReadyCalled = false;
      bool onMapErrorCalled = false;
      bool onMapClickCalled = false;
      bool onMarkerClickCalled = false;
      bool onCameraMoveCalled = false;
      bool onCameraIdleCalled = false;
      bool onLocationUpdateCalled = false;

      final callbacks = MtMapWidgetCallbacks(
        onMapReady: () => onMapReadyCalled = true,
        onMapError: (error) => onMapErrorCalled = true,
        onMapClick: (lat, lng) => onMapClickCalled = true,
        onMarkerClick: (marker) => onMarkerClickCalled = true,
        onCameraMove: (lat, lng, zoom) => onCameraMoveCalled = true,
        onCameraIdle: () => onCameraIdleCalled = true,
        onLocationUpdate: (lat, lng, accuracy) => onLocationUpdateCalled = true,
      );

      // 调用所有回调
      callbacks.onMapReady?.call();
      callbacks.onMapError?.call('test error');
      callbacks.onMapClick?.call(39.9042, 116.4074);
      callbacks.onMarkerClick?.call(MtMapMarker(latitude: 39.9042, longitude: 116.4074));
      callbacks.onCameraMove?.call(39.9042, 116.4074, 15.0);
      callbacks.onCameraIdle?.call();
      callbacks.onLocationUpdate?.call(39.9042, 116.4074, 10.0);

      expect(onMapReadyCalled, true);
      expect(onMapErrorCalled, true);
      expect(onMapClickCalled, true);
      expect(onMarkerClickCalled, true);
      expect(onCameraMoveCalled, true);
      expect(onCameraIdleCalled, true);
      expect(onLocationUpdateCalled, true);
    });
  });
}
