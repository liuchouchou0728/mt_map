import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_map/mt_map.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MtMapWidget Edge Cases Tests', () {
    testWidgets('should handle extreme zoom levels without crashing', (WidgetTester tester) async {
      // 测试极低缩放级别
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
                initialPosition: MtMapPosition(
                  latitude: 39.9042,
                  longitude: 116.4074,
                  zoom: 1.0, // 极低缩放级别
                ),
              ),
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

      // 测试极高缩放级别
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
                initialPosition: MtMapPosition(
                  latitude: 39.9042,
                  longitude: 116.4074,
                  zoom: 20.0, // 极高缩放级别
                ),
              ),
            ),
          ),
        ),
      );

      // 等待初始化
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle boundary coordinates gracefully', (WidgetTester tester) async {
      // 测试边界坐标
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
                initialPosition: MtMapPosition(
                  latitude: 90.0, // 北极
                  longitude: 180.0, // 国际日期变更线
                  zoom: 15.0,
                ),
              ),
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

      // 测试负坐标
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
                initialPosition: MtMapPosition(
                  latitude: -90.0, // 南极
                  longitude: -180.0, // 负经度
                  zoom: 15.0,
                ),
              ),
            ),
          ),
        ),
      );

      // 等待初始化
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle invalid coordinates gracefully', (WidgetTester tester) async {
      // 测试超出范围的坐标
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
                initialPosition: MtMapPosition(
                  latitude: 91.0, // 超出纬度范围
                  longitude: 181.0, // 超出经度范围
                  zoom: 15.0,
                ),
              ),
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
    });

    testWidgets('should handle empty markers list gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
                initialMarkers: const [], // 空标记列表
              ),
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
    });

    testWidgets('should handle empty polylines list gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
                initialPolylines: const [], // 空路线列表
              ),
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
    });

    testWidgets('should handle empty polygons list gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
                initialPolygons: const [], // 空多边形列表
              ),
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
    });

    testWidgets('should handle null style gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
              ),
              style: null, // null样式
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
    });

    testWidgets('should handle null callbacks gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
              ),
              callbacks: null, // null回调
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
    });

    testWidgets('should handle very long API keys gracefully', (WidgetTester tester) async {
      // 测试非常长的API密钥
      final longApiKey = 'a' * 1000; // 1000个字符的API密钥
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: longApiKey,
              ),
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
    });

    testWidgets('should handle special characters in API keys gracefully', (WidgetTester tester) async {
      // 测试包含特殊字符的API密钥
      final specialApiKey = 'test_key_with_special_chars_!@#\$%^&*()_+-=[]{}|;:,.<>?';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: specialApiKey,
              ),
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
    });

    testWidgets('should handle very large marker data gracefully', (WidgetTester tester) async {
      // 创建包含大量数据的标记
      final largeMarkers = List.generate(100, (i) => MtMapMarker(
        latitude: 39.9042 + (i * 0.001),
        longitude: 116.4074 + (i * 0.001),
        title: 'Marker $i with very long title that might cause rendering issues',
        snippet: 'This is a very long snippet that contains a lot of text and might cause layout problems in the UI',
        iconPath: '/path/to/very/long/icon/path/that/might/cause/issues/with/file/system/access',
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
                initialMarkers: largeMarkers,
              ),
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
    });

    testWidgets('should handle very large polyline data gracefully', (WidgetTester tester) async {
      // 创建包含大量点的路线
      final largePolyline = MtMapPolyline(
        points: List.generate(200, (i) => MtMapPosition(
          latitude: 39.9042 + (i * 0.001),
          longitude: 116.4074 + (i * 0.001),
        )),
        color: Colors.blue,
        width: 10.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
                initialPolylines: [largePolyline],
              ),
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
    });

    testWidgets('should handle very large polygon data gracefully', (WidgetTester tester) async {
      // 创建包含大量点的多边形
      final largePolygon = MtMapPolygon(
        points: List.generate(150, (i) => MtMapPosition(
          latitude: 39.9042 + (i * 0.001),
          longitude: 116.4074 + (i * 0.001),
        )),
        fillColor: Colors.green,
        strokeColor: Colors.green,
        strokeWidth: 5.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
                initialPolygons: [largePolygon],
              ),
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
    });

    testWidgets('should handle widget disposal and recreation gracefully', (WidgetTester tester) async {
      // 创建widget
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

      // 等待初始化
      await tester.pump(const Duration(milliseconds: 500));

      // 验证widget存在
      expect(find.byType(MtMapWidget), findsOneWidget);

      // 销毁widget
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Text('Empty'))));

      // 验证widget已被销毁
      expect(find.byType(MtMapWidget), findsNothing);
      expect(find.text('Empty'), findsOneWidget);

      // 重新创建widget
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

      // 等待初始化
      await tester.pump(const Duration(milliseconds: 500));

      // 验证widget重新创建成功
      expect(find.byType(MtMapWidget), findsOneWidget);
    });
  });
}
