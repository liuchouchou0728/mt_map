import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_map/mt_map.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MtMapWidget PlatformView Lifecycle Tests', () {
    testWidgets('should handle PlatformView creation lifecycle correctly', (WidgetTester tester) async {
      bool onMapReadyCalled = false;
      bool onMapErrorCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
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

      // 等待PlatformView创建过程
      await tester.pump(const Duration(milliseconds: 500));

      // 验证回调状态（在测试环境中可能不会调用）
      expect(onMapReadyCalled, false);
      expect(onMapErrorCalled, false);

      // 验证widget仍然存在
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle PlatformView creation failure gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: '', // 空API密钥会触发错误
              ),
            ),
          ),
        ),
      );

      // 等待错误处理
      await tester.pump(const Duration(milliseconds: 500));

      // 应该显示错误状态
      expect(find.text('地图加载失败'), findsOneWidget);
      expect(find.text('API Key is required'), findsOneWidget);
    });

    testWidgets('should handle PlatformView disposal correctly', (WidgetTester tester) async {
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

      // 验证widget存在
      expect(find.byType(MtMapWidget), findsOneWidget);

      // 销毁widget
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Text('Destroyed'))));

      // 验证widget已被销毁
      expect(find.byType(MtMapWidget), findsNothing);
      expect(find.text('Destroyed'), findsOneWidget);
    });

    testWidgets('should handle PlatformView recreation correctly', (WidgetTester tester) async {
      // 第一次创建
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

      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MtMapWidget), findsOneWidget);

      // 销毁
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Text('Destroyed'))));
      expect(find.byType(MtMapWidget), findsNothing);

      // 重新创建
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

      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle PlatformView parameter changes correctly', (WidgetTester tester) async {
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

      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MtMapWidget), findsOneWidget);

      // 改变参数
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
                initialPosition: MtMapPosition(
                  latitude: 39.9142,
                  longitude: 116.4174,
                  zoom: 16.0,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle PlatformView style changes correctly', (WidgetTester tester) async {
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

      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MtMapWidget), findsOneWidget);

      // 改变样式
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
              ),
              style: MtMapStyle(
                showTraffic: false,
                showBuildings: false,
                mapType: 'satellite',
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle PlatformView with complex initial data correctly', (WidgetTester tester) async {
      final markers = <MtMapMarker>[
        MtMapMarker(
          latitude: 39.9042,
          longitude: 116.4074,
          title: 'Test Marker 1',
        ),
        MtMapMarker(
          latitude: 39.9142,
          longitude: 116.4174,
          title: 'Test Marker 2',
        ),
      ];

      final polylines = <MtMapPolyline>[
        MtMapPolyline(
          points: [
            MtMapPosition(latitude: 39.9042, longitude: 116.4074),
            MtMapPosition(latitude: 39.9142, longitude: 116.4174),
          ],
          color: Colors.blue,
          width: 5.0,
        ),
      ];

      final polygons = <MtMapPolygon>[
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
                initialMarkers: markers,
                initialPolylines: polylines,
                initialPolygons: polygons,
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle PlatformView in different container types correctly', (WidgetTester tester) async {
      // 测试在不同容器类型中的表现
      final containers = [
        Container(
          width: 300,
          height: 200,
          child: MtMapWidget(
            params: MtMapWidgetParams(apiKey: 'test_key'),
          ),
        ),
        SizedBox(
          width: 400,
          height: 300,
          child: MtMapWidget(
            params: MtMapWidgetParams(apiKey: 'test_key'),
          ),
        ),
        Column(
          children: [
            Expanded(
              child: MtMapWidget(
                params: MtMapWidgetParams(apiKey: 'test_key'),
              ),
            ),
          ],
        ),
      ];

      for (final container in containers) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: container,
            ),
          ),
        );

        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(MtMapWidget), findsOneWidget);
      }
    });

    testWidgets('should handle PlatformView with navigation correctly', (WidgetTester tester) async {
      // 测试第一页（包含地图）
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(apiKey: 'test_key'),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MtMapWidget), findsOneWidget);

      // 导航到第二页（不包含地图）
      await tester.pumpWidget(
        MaterialApp(
          home: const Scaffold(
            body: Text('Second Page'),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MtMapWidget), findsNothing);
      expect(find.text('Second Page'), findsOneWidget);

      // 返回第一页（重新包含地图）
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(apiKey: 'test_key'),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MtMapWidget), findsOneWidget);
    });
  });
}
