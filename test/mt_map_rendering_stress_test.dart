import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_map/mt_map.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MtMapWidget Rendering Stress Tests', () {
    testWidgets('should handle rapid state changes without crashing', (WidgetTester tester) async {
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

      // 快速多次重建widget
      for (int i = 0; i < 10; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MtMapWidget(
                params: MtMapWidgetParams(
                  apiKey: 'test_key',
                  initialPosition: MtMapPosition(
                    latitude: 39.9042 + (i * 0.001),
                    longitude: 116.4074 + (i * 0.001),
                    zoom: 15.0 + (i * 0.1),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 50));
      }

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle rapid marker additions without crashing', (WidgetTester tester) async {
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

      // 等待初始化
      await tester.pump(const Duration(milliseconds: 500));

      // 快速添加多个标记
      for (int i = 0; i < 20; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MtMapWidget(
                params: MtMapWidgetParams(
                  apiKey: 'test_key',
                  initialMarkers: List.generate(i + 1, (index) => MtMapMarker(
                    latitude: 39.9042 + (index * 0.001),
                    longitude: 116.4074 + (index * 0.001),
                    title: 'Marker $index',
                  )),
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 30));
      }

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle rapid polyline additions without crashing', (WidgetTester tester) async {
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

      // 等待初始化
      await tester.pump(const Duration(milliseconds: 500));

      // 快速添加多个路线
      for (int i = 0; i < 15; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MtMapWidget(
                params: MtMapWidgetParams(
                  apiKey: 'test_key',
                  initialPolylines: List.generate(i + 1, (index) => MtMapPolyline(
                    points: [
                      MtMapPosition(latitude: 39.9042 + (index * 0.001), longitude: 116.4074 + (index * 0.001)),
                      MtMapPosition(latitude: 39.9142 + (index * 0.001), longitude: 116.4174 + (index * 0.001)),
                    ],
                    color: Colors.blue,
                    width: 2.0 + (index * 0.5),
                  )),
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 30));
      }

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle rapid polygon additions without crashing', (WidgetTester tester) async {
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

      // 等待初始化
      await tester.pump(const Duration(milliseconds: 500));

      // 快速添加多个多边形
      for (int i = 0; i < 10; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MtMapWidget(
                params: MtMapWidgetParams(
                  apiKey: 'test_key',
                  initialPolygons: List.generate(i + 1, (index) => MtMapPolygon(
                    points: [
                      MtMapPosition(latitude: 39.9042 + (index * 0.001), longitude: 116.4074 + (index * 0.001)),
                      MtMapPosition(latitude: 39.9142 + (index * 0.001), longitude: 116.4074 + (index * 0.001)),
                      MtMapPosition(latitude: 39.9142 + (index * 0.001), longitude: 116.4174 + (index * 0.001)),
                    ],
                    fillColor: Colors.green,
                    strokeColor: Colors.green,
                    strokeWidth: 1.0 + (index * 0.2),
                  )),
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 30));
      }

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle rapid style changes without crashing', (WidgetTester tester) async {
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

      // 等待初始化
      await tester.pump(const Duration(milliseconds: 500));

      // 快速切换样式
      final styles = [
        MtMapStyle(showTraffic: true, showBuildings: true, mapType: 'normal'),
        MtMapStyle(showTraffic: false, showBuildings: false, mapType: 'satellite'),
        MtMapStyle(showTraffic: true, showBuildings: false, mapType: 'hybrid'),
        MtMapStyle(showTraffic: false, showBuildings: true, mapType: 'terrain'),
      ];

      for (int i = 0; i < 20; i++) {
        final style = styles[i % styles.length];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MtMapWidget(
                params: MtMapWidgetParams(
                  apiKey: 'test_key',
                ),
                style: style,
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 30));
      }

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle rapid position changes without crashing', (WidgetTester tester) async {
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

      // 等待初始化
      await tester.pump(const Duration(milliseconds: 500));

      // 快速改变位置
      for (int i = 0; i < 25; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MtMapWidget(
                params: MtMapWidgetParams(
                  apiKey: 'test_key',
                  initialPosition: MtMapPosition(
                    latitude: 39.9042 + (i * 0.01),
                    longitude: 116.4074 + (i * 0.01),
                    zoom: 15.0 + (i * 0.5),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 25));
      }

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle rapid callback changes without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
              ),
              callbacks: MtMapWidgetCallbacks(
                onMapReady: () => print('Map ready 1'),
                onMapError: (error) => print('Map error 1: $error'),
              ),
            ),
          ),
        ),
      );

      // 等待初始化
      await tester.pump(const Duration(milliseconds: 500));

      // 快速改变回调
      for (int i = 0; i < 15; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MtMapWidget(
                params: MtMapWidgetParams(
                  apiKey: 'test_key',
                ),
                callbacks: MtMapWidgetCallbacks(
                  onMapReady: () => print('Map ready $i'),
                  onMapError: (error) => print('Map error $i: $error'),
                  onMapClick: (lat, lng) => print('Map click $i: ($lat, $lng)'),
                  onMarkerClick: (marker) => print('Marker click $i: ${marker.title}'),
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 40));
      }

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle rapid API key changes without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key_1',
              ),
            ),
          ),
        ),
      );

      // 等待初始化
      await tester.pump(const Duration(milliseconds: 500));

      // 快速改变API密钥
      final apiKeys = [
        'test_key_1',
        'test_key_2',
        'test_key_3',
        'test_key_4',
        'test_key_5',
      ];

      for (int i = 0; i < 20; i++) {
        final apiKey = apiKeys[i % apiKeys.length];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MtMapWidget(
                params: MtMapWidgetParams(
                  apiKey: apiKey,
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 35));
      }

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle rapid layout changes without crashing', (WidgetTester tester) async {
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

      // 等待初始化
      await tester.pump(const Duration(milliseconds: 500));

      // 快速改变布局尺寸
      final layouts = [
        {'width': 300.0, 'height': 200.0},
        {'width': 400.0, 'height': 300.0},
        {'width': 200.0, 'height': 150.0},
        {'width': 500.0, 'height': 400.0},
        {'width': 250.0, 'height': 180.0},
      ];

      for (int i = 0; i < 18; i++) {
        final layout = layouts[i % layouts.length];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Container(
                width: layout['width'],
                height: layout['height'],
                child: MtMapWidget(
                  params: MtMapWidgetParams(
                    apiKey: 'test_key',
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 30));
      }

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle rapid widget tree changes without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Map Test')),
            body: Column(
              children: [
                Container(height: 50, color: Colors.blue),
                Expanded(
                  child: MtMapWidget(
                    params: MtMapWidgetParams(
                      apiKey: 'test_key',
                    ),
                  ),
                ),
                Container(height: 50, color: Colors.green),
              ],
            ),
          ),
        ),
      );

      // 等待初始化
      await tester.pump(const Duration(milliseconds: 500));

      // 快速改变widget树结构
      for (int i = 0; i < 12; i++) {
        if (i % 2 == 0) {
          // 添加更多元素
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                appBar: AppBar(title: Text('Map Test $i')),
                body: Column(
                  children: [
                    Container(height: 50, color: Colors.blue),
                    Container(height: 30, color: Colors.red),
                    Expanded(
                      child: MtMapWidget(
                        params: MtMapWidgetParams(
                          apiKey: 'test_key',
                        ),
                      ),
                    ),
                    Container(height: 30, color: Colors.orange),
                    Container(height: 50, color: Colors.green),
                  ],
                ),
              ),
            ),
          );
        } else {
          // 简化结构
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
        }
        await tester.pump(const Duration(milliseconds: 40));
      }

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);
    });
  });
}
