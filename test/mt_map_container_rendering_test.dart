import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_map/mt_map.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MtMapWidget Container Rendering Tests', () {
    testWidgets('should render correctly in different container types', (WidgetTester tester) async {
      // 测试在不同容器类型中的渲染
      final containers = [
        // 基础容器
        Container(
          width: 300,
          height: 200,
          color: Colors.grey[100],
          child: MtMapWidget(
            params: MtMapWidgetParams(apiKey: 'test_key'),
          ),
        ),
        // 卡片容器
        Card(
          child: SizedBox(
            width: 400,
            height: 300,
            child: MtMapWidget(
              params: MtMapWidgetParams(apiKey: 'test_key'),
            ),
          ),
        ),
        // 装饰容器
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(8),
          ),
          child: MtMapWidget(
            params: MtMapWidgetParams(apiKey: 'test_key'),
          ),
        ),
        // 透明容器
        Opacity(
          opacity: 0.9,
          child: Container(
            width: 250,
            height: 180,
            child: MtMapWidget(
              params: MtMapWidgetParams(apiKey: 'test_key'),
            ),
          ),
        ),
      ];

      for (int i = 0; i < containers.length; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: containers[i],
            ),
          ),
        );

        // 应该显示加载状态
        expect(find.text('正在加载地图...'), findsOneWidget);

        // 等待初始化
        await tester.pump(const Duration(milliseconds: 500));

        // 验证widget仍然存在且没有崩溃
        expect(find.byType(MtMapWidget), findsOneWidget);
      }
    });

    testWidgets('should render correctly with different constraints', (WidgetTester tester) async {
      // 测试不同的约束条件
      final constraints = [
        // 固定尺寸
        {'width': 200.0, 'height': 150.0},
        {'width': 500.0, 'height': 400.0},
        {'width': 100.0, 'height': 100.0},
        // 无限尺寸
        {'width': double.infinity, 'height': double.infinity},
        // 部分无限
        {'width': double.infinity, 'height': 200.0},
        {'width': 300.0, 'height': double.infinity},
      ];

      for (final constraint in constraints) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Container(
                width: constraint['width'],
                height: constraint['height'],
                child: MtMapWidget(
                  params: MtMapWidgetParams(apiKey: 'test_key'),
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
      }
    });

    testWidgets('should render correctly in scrollable containers', (WidgetTester tester) async {
      // 测试在可滚动容器中的渲染
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(height: 100, color: Colors.blue),
                  Container(
                    height: 300,
                    child: MtMapWidget(
                      params: MtMapWidgetParams(apiKey: 'test_key'),
                    ),
                  ),
                  Container(height: 100, color: Colors.green),
                  Container(
                    height: 200,
                    child: MtMapWidget(
                      params: MtMapWidgetParams(apiKey: 'test_key_2'),
                    ),
                  ),
                  Container(height: 100, color: Colors.red),
                ],
              ),
            ),
          ),
        ),
      );

      // 应该显示多个加载状态
      expect(find.text('正在加载地图...'), findsNWidgets(2));

      // 等待初始化
      await tester.pump(const Duration(milliseconds: 500));

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsNWidgets(2));
    });

    testWidgets('should render correctly in tab containers', (WidgetTester tester) async {
      // 测试在标签页容器中的渲染
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                bottom: const TabBar(
                  tabs: [
                    Tab(text: '地图1'),
                    Tab(text: '地图2'),
                    Tab(text: '地图3'),
                  ],
                ),
              ),
              body: const TabBarView(
                children: [
                  MtMapWidget(
                    params: MtMapWidgetParams(apiKey: 'test_key_1'),
                  ),
                  MtMapWidget(
                    params: MtMapWidgetParams(apiKey: 'test_key_2'),
                  ),
                  MtMapWidget(
                    params: MtMapWidgetParams(apiKey: 'test_key_3'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // 应该显示加载状态（TabBarView可能只渲染当前可见的tab）
      expect(find.text('正在加载地图...'), findsAtLeastNWidgets(1));

      // 等待初始化
      await tester.pump(const Duration(milliseconds: 500));

      // 验证widget仍然存在且没有崩溃（TabBarView可能只渲染当前可见的tab）
      expect(find.byType(MtMapWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('should render correctly in modal containers', (WidgetTester tester) async {
      // 测试在模态容器中的渲染
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: navigatorKey.currentContext!,
                    builder: (context) => Dialog(
                      child: Container(
                        width: 400,
                        height: 300,
                        child: MtMapWidget(
                          params: MtMapWidgetParams(apiKey: 'test_key'),
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('显示地图'),
              ),
            ),
          ),
        ),
      );

      // 点击按钮显示对话框
      await tester.tap(find.text('显示地图'));
      await tester.pump(const Duration(milliseconds: 500));

      // 应该显示加载状态
      expect(find.text('正在加载地图...'), findsOneWidget);

      // 等待初始化
      await tester.pump(const Duration(milliseconds: 500));

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should render correctly in animated containers', (WidgetTester tester) async {
      // 测试在动画容器中的渲染
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 300,
              height: 200,
              child: MtMapWidget(
                params: MtMapWidgetParams(apiKey: 'test_key'),
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

      // 改变容器尺寸
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 500,
              height: 400,
              child: MtMapWidget(
                params: MtMapWidgetParams(apiKey: 'test_key'),
              ),
            ),
          ),
        ),
      );

      // 等待动画完成
      await tester.pump(const Duration(milliseconds: 500));

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);
    });

    testWidgets('should render correctly in responsive containers', (WidgetTester tester) async {
      // 测试在响应式容器中的渲染
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: constraints.maxWidth * 0.8,
                  height: constraints.maxHeight * 0.6,
                  child: MtMapWidget(
                    params: MtMapWidgetParams(apiKey: 'test_key'),
                  ),
                );
              },
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

    testWidgets('should render correctly in nested containers', (WidgetTester tester) async {
      // 测试在嵌套容器中的渲染
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 200,
                            child: MtMapWidget(
                              params: MtMapWidgetParams(apiKey: 'test_key_1'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 200,
                            child: MtMapWidget(
                              params: MtMapWidgetParams(apiKey: 'test_key_2'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 150,
                    child: MtMapWidget(
                      params: MtMapWidgetParams(apiKey: 'test_key_3'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // 应该显示多个加载状态
      expect(find.text('正在加载地图...'), findsNWidgets(3));

      // 等待初始化
      await tester.pump(const Duration(milliseconds: 500));

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsNWidgets(3));
    });

    testWidgets('should render correctly with container state changes', (WidgetTester tester) async {
      // 测试容器状态变化时的渲染
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              width: 300,
              height: 200,
              color: Colors.blue[100],
              child: MtMapWidget(
                params: MtMapWidgetParams(apiKey: 'test_key'),
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

      // 改变容器状态
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              width: 400,
              height: 300,
              color: Colors.green[100],
              child: MtMapWidget(
                params: MtMapWidgetParams(apiKey: 'test_key'),
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

    testWidgets('should render correctly in different screen orientations', (WidgetTester tester) async {
      // 测试不同屏幕方向下的渲染
      // 模拟竖屏模式
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(apiKey: 'test_key'),
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

      // 模拟横屏模式
      tester.view.physicalSize = const Size(800, 400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MtMapWidget(
              params: MtMapWidgetParams(apiKey: 'test_key'),
            ),
          ),
        ),
      );

      // 等待初始化
      await tester.pump(const Duration(milliseconds: 500));

      // 验证widget仍然存在且没有崩溃
      expect(find.byType(MtMapWidget), findsOneWidget);

      // 恢复默认尺寸
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}

// 全局导航键用于模态对话框测试
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
