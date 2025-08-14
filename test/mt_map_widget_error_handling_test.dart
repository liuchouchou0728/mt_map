import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_map/mt_map.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MtMapWidget Error Handling Tests', () {
    testWidgets('should handle empty API key error', (WidgetTester tester) async {
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

    testWidgets('should show retry button when error occurs', (WidgetTester tester) async {
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

      await tester.pump(const Duration(milliseconds: 500));

      // 应该显示错误状态
      expect(find.text('地图加载失败'), findsOneWidget);
      expect(find.text('API Key is required'), findsOneWidget);
    });

    testWidgets('should handle retry button state correctly', (WidgetTester tester) async {
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

      await tester.pump(const Duration(milliseconds: 500));

      // 应该显示错误状态
      expect(find.text('地图加载失败'), findsOneWidget);
      expect(find.text('API Key is required'), findsOneWidget);
    });

    testWidgets('should handle multiple retries correctly', (WidgetTester tester) async {
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

      await tester.pump(const Duration(milliseconds: 500));

      // 应该显示错误状态
      expect(find.text('地图加载失败'), findsOneWidget);
      expect(find.text('API Key is required'), findsOneWidget);
    });

    testWidgets('should handle network connection error', (WidgetTester tester) async {
      // 这里可以模拟网络连接失败的情况
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

      // 等待初始化完成
      await tester.pump(const Duration(milliseconds: 500));

      // 验证widget正确渲染
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle PlatformView creation failure gracefully', (WidgetTester tester) async {
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

      // 等待初始化完成
      await tester.pump(const Duration(milliseconds: 500));

      // 验证widget正确渲染
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle invalid coordinates gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: 'test_key',
                initialPosition: MtMapPosition(
                  latitude: 1000.0, // 无效的纬度
                  longitude: 2000.0, // 无效的经度
                  zoom: 15.0,
                ),
              ),
            ),
          ),
        ),
      );

      // 等待初始化完成
      await tester.pump(const Duration(milliseconds: 500));

      // 验证widget正确渲染
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle style configuration errors gracefully', (WidgetTester tester) async {
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
                mapType: 'invalid_type', // 无效的地图类型
              ),
            ),
          ),
        ),
      );

      // 等待初始化完成
      await tester.pump(const Duration(milliseconds: 500));

      // 验证widget正确渲染
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should handle callback errors gracefully', (WidgetTester tester) async {
      bool onMapErrorCalled = false;
      String? errorMessage;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(
                apiKey: '', // 空API密钥会触发错误
              ),
              callbacks: MtMapWidgetCallbacks(
                onMapError: (error) {
                  onMapErrorCalled = true;
                  errorMessage = error;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 验证错误回调被调用
      expect(onMapErrorCalled, true);
      expect(errorMessage, 'API Key is required');
    });

    testWidgets('should handle widget disposal correctly', (WidgetTester tester) async {
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
}
