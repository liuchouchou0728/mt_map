import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_map/mt_map.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MtMapWidget setSize Tests', () {
    testWidgets('should handle setSize correctly without LayoutBuilder', (WidgetTester tester) async {
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

      // 应该显示加载状态
      expect(find.text('正在加载地图...'), findsOneWidget);

      // 等待一段时间让初始化完成
      await tester.pump(const Duration(milliseconds: 500));

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle setSize correctly with fixed dimensions', (WidgetTester tester) async {
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

      // 等待一段时间让初始化完成
      await tester.pump(const Duration(milliseconds: 500));

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle setSize correctly with infinite dimensions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
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

      // 等待一段时间让初始化完成
      await tester.pump(const Duration(milliseconds: 500));

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle setSize correctly in different screen orientations', (WidgetTester tester) async {
      // 模拟横屏模式
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;

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

      // 等待一段时间让初始化完成
      await tester.pump(const Duration(milliseconds: 500));

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);

      // 恢复默认尺寸
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('should handle setSize correctly with complex layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('地图测试')),
            body: Column(
              children: [
                Container(
                  height: 100,
                  color: Colors.blue,
                  child: const Center(child: Text('顶部区域')),
                ),
                Expanded(
                  child: MtMapWidget(
                    params: MtMapWidgetParams(
                      apiKey: 'test_key',
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  color: Colors.green,
                  child: const Center(child: Text('底部区域')),
                ),
              ],
            ),
          ),
        ),
      );

      // 应该显示加载状态
      expect(find.text('正在加载地图...'), findsOneWidget);

      // 等待一段时间让初始化完成
      await tester.pump(const Duration(milliseconds: 500));

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);
      expect(find.text('顶部区域'), findsOneWidget);
      expect(find.text('底部区域'), findsOneWidget);
    });

    testWidgets('should handle setSize correctly with state changes', (WidgetTester tester) async {
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

      // 等待一段时间让初始化完成
      await tester.pump(const Duration(milliseconds: 500));

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);

      // 模拟状态变化
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

      // 等待状态更新
      await tester.pump(const Duration(milliseconds: 500));

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);
    });
  });
}
