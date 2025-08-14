import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_map/mt_map.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MtMapWidget Performance Tests', () {
    testWidgets('should render initial state quickly', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();
      
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

      stopwatch.stop();
      
      // 初始渲染应该在合理时间内完成
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      
      // 应该显示加载状态
      expect(find.text('正在加载地图...'), findsOneWidget);
    });

    testWidgets('should handle large numbers of markers efficiently', (WidgetTester tester) async {
      // 创建大量标记
      final markers = List.generate(500, (i) => MtMapMarker(
        latitude: 39.9042 + (i * 0.001),
        longitude: 116.4074 + (i * 0.001),
        title: 'Marker $i',
        snippet: 'Description $i',
      ));

      final stopwatch = Stopwatch()..start();
      
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

      stopwatch.stop();
      
      // 大量标记的渲染应该在合理时间内完成
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
      
      // 应该显示加载状态
      expect(find.text('正在加载地图...'), findsOneWidget);
    });

    testWidgets('should handle complex polyline configurations efficiently', (WidgetTester tester) async {
      // 创建复杂的路线配置
      final polylines = List.generate(100, (i) {
        final points = List.generate(50, (j) => MtMapPosition(
          latitude: 39.9042 + (i * 0.01) + (j * 0.001),
          longitude: 116.4074 + (i * 0.01) + (j * 0.001),
        ));
        
        return MtMapPolyline(
          points: points,
          color: Colors.primaries[i % Colors.primaries.length],
          width: (i % 10) + 1.0,
        );
      });

      final stopwatch = Stopwatch()..start();
      
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

      stopwatch.stop();
      
      // 复杂路线配置的渲染应该在合理时间内完成
      expect(stopwatch.elapsedMilliseconds, lessThan(3000));
      
      // 应该显示加载状态
      expect(find.text('正在加载地图...'), findsOneWidget);
    });

    testWidgets('should handle complex polygon configurations efficiently', (WidgetTester tester) async {
      // 创建复杂的多边形配置
      final polygons = List.generate(50, (i) {
        final points = List.generate(30, (j) => MtMapPosition(
          latitude: 39.9042 + (i * 0.01) + (j * 0.001),
          longitude: 116.4074 + (i * 0.01) + (j * 0.001),
        ));
        
        return MtMapPolygon(
          points: points,
          fillColor: Colors.primaries[i % Colors.primaries.length],
          strokeColor: Colors.primaries[i % Colors.primaries.length],
          strokeWidth: (i % 5) + 1.0,
        );
      });

      final stopwatch = Stopwatch()..start();
      
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

      stopwatch.stop();
      
      // 复杂多边形配置的渲染应该在合理时间内完成
      expect(stopwatch.elapsedMilliseconds, lessThan(2500));
      
      // 应该显示加载状态
      expect(find.text('正在加载地图...'), findsOneWidget);
    });

    testWidgets('should handle rapid style changes efficiently', (WidgetTester tester) async {
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

      final stopwatch = Stopwatch()..start();
      
      for (int i = 0; i < 50; i++) {
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
        await tester.pump(const Duration(milliseconds: 20));
      }

      stopwatch.stop();
      
      // 快速样式切换应该在合理时间内完成
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));
      
      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle rapid position changes efficiently', (WidgetTester tester) async {
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

      final stopwatch = Stopwatch()..start();
      
      // 快速改变位置
      for (int i = 0; i < 100; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MtMapWidget(
                params: MtMapWidgetParams(
                  apiKey: 'test_key',
                  initialPosition: MtMapPosition(
                    latitude: 39.9042 + (i * 0.01),
                    longitude: 116.4074 + (i * 0.01),
                    zoom: 15.0 + (i * 0.1),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 15));
      }

      stopwatch.stop();
      
      // 快速位置变化应该在合理时间内完成
      expect(stopwatch.elapsedMilliseconds, lessThan(8000));
      
      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle memory pressure scenarios gracefully', (WidgetTester tester) async {
      // 模拟内存压力场景
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                // 添加一些其他widget来增加内存压力
                Container(
                  height: 100,
                  color: Colors.blue,
                  child: const Center(child: Text('Header')),
                ),
                Expanded(
                  child: MtMapWidget(
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
                Container(
                  height: 100,
                  color: Colors.green,
                  child: const Center(child: Text('Footer')),
                ),
              ],
            ),
          ),
        ),
      );

      // 应该显示加载状态
      expect(find.text('正在加载地图...'), findsOneWidget);

      // 等待初始化
      await tester.pump(const Duration(milliseconds: 500));

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);
      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Footer'), findsOneWidget);
    });

    testWidgets('should handle rapid sequential operations efficiently', (WidgetTester tester) async {
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

      final stopwatch = Stopwatch()..start();
      
      // 快速连续添加标记
      for (int i = 0; i < 20; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MtMapWidget(
                params: MtMapWidgetParams(
                  apiKey: 'test_key',
                  initialMarkers: [MtMapMarker(
                    latitude: 39.9042 + (i * 0.001),
                    longitude: 116.4074 + (i * 0.001),
                    title: 'Marker $i',
                  )],
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 20));
      }
      
      // 快速连续添加路线
      for (int i = 0; i < 15; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MtMapWidget(
                params: MtMapWidgetParams(
                  apiKey: 'test_key',
                  initialPolylines: [MtMapPolyline(
                    points: [
                      MtMapPosition(latitude: 39.9042 + (i * 0.001), longitude: 116.4074 + (i * 0.001)),
                      MtMapPosition(latitude: 39.9142 + (i * 0.001), longitude: 116.4174 + (i * 0.001)),
                    ],
                    color: Colors.blue,
                    width: 2.0,
                  )],
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 20));
      }
      
      stopwatch.stop();
      
      // 快速连续操作应该在合理时间内完成
      expect(stopwatch.elapsedMilliseconds, lessThan(10000));
      
      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);
    });
  });
}
