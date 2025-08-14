import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_map/mt_map.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MtMapWidget Integration Tests', () {
    testWidgets('should handle PlatformView creation correctly', (WidgetTester tester) async {
      bool onMapReadyCalled = false;
      bool onMapErrorCalled = false;

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
                initialMarkers: [
                  MtMapMarker(
                    latitude: 39.9042,
                    longitude: 116.4074,
                    title: 'Test Marker',
                  ),
                ],
              ),
              callbacks: MtMapWidgetCallbacks(
                onMapReady: () => onMapReadyCalled = true,
                onMapError: (error) => onMapErrorCalled = true,
              ),
            ),
          ),
        ),
      );

      // 初始状态应该显示加载状态
      expect(find.text('正在加载地图...'), findsOneWidget);

      // 等待一段时间让初始化完成
      await tester.pump(const Duration(milliseconds: 500));

      // 验证回调设置正确
      expect(onMapReadyCalled, false); // 在测试环境中可能不会调用
      expect(onMapErrorCalled, false);
    });

    testWidgets('should handle error states correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: '', // 空API密钥
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

      // 验证widget正确渲染
      expect(find.byType(MtMapWidget), findsOneWidget);
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
                mapType: 'satellite',
              ),
            ),
          ),
        ),
      );

      // 应该显示加载状态
      expect(find.text('正在加载地图...'), findsOneWidget);
    });

    testWidgets('should handle complex initialization correctly', (WidgetTester tester) async {
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
                initialMarkers: [
                  MtMapMarker(
                    latitude: 39.9042,
                    longitude: 116.4074,
                    title: 'Marker 1',
                  ),
                  MtMapMarker(
                    latitude: 39.9142,
                    longitude: 116.4174,
                    title: 'Marker 2',
                  ),
                ],
                initialPolylines: [
                  MtMapPolyline(
                    points: [
                      MtMapPosition(latitude: 39.9042, longitude: 116.4074),
                      MtMapPosition(latitude: 39.9142, longitude: 116.4174),
                    ],
                    color: Colors.blue,
                    width: 5.0,
                  ),
                ],
                initialPolygons: [
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
                ],
              ),
              callbacks: MtMapWidgetCallbacks(
                onMapReady: () {},
                onMapError: (error) {},
                onMapClick: (lat, lng) {},
                onMarkerClick: (marker) {},
                onCameraMove: (lat, lng, zoom) {},
                onCameraIdle: () {},
                onLocationUpdate: (lat, lng, accuracy) {},
              ),
            ),
          ),
        ),
      );

      // 应该显示加载状态
      expect(find.text('正在加载地图...'), findsOneWidget);

      // 等待一段时间让初始化完成
      await tester.pump(const Duration(milliseconds: 500));

      // 验证widget仍然存在
      expect(find.byType(MtMapWidget), findsOneWidget);
    });
  });
}
