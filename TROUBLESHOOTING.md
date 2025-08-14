# MT Map Plugin 故障排除指南

本指南将帮助您解决使用美团地图插件时遇到的常见问题。

## 常见问题

### 1. setSize 相关错误

**错误信息**:
```
PlatformException(setSize, setSize called on a PlatformView that has not been created yet, null)
```

**原因**: PlatformView 在创建完成之前就被调用了 setSize 方法。

**解决方案**:

1. **确保正确的布局约束**:
```dart
// ✅ 正确方式
Container(
  width: double.infinity,
  height: 300,
  child: MtMapWidget(
    params: MtMapWidgetParams(
      apiKey: 'your_api_key',
      initialPosition: MtMapPosition(
        latitude: 39.9042,
        longitude: 116.4074,
        zoom: 15.0,
      ),
    ),
  ),
)

// ❌ 错误方式 - 没有明确的尺寸约束
MtMapWidget(
  params: MtMapWidgetParams(
    apiKey: 'your_api_key',
  ),
)
```

2. **使用 LayoutBuilder**:
```dart
LayoutBuilder(
  builder: (context, constraints) {
    return SizedBox(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: MtMapWidget(
        params: MtMapWidgetParams(
          apiKey: 'your_api_key',
          initialPosition: MtMapPosition(
            latitude: 39.9042,
            longitude: 116.4074,
            zoom: 15.0,
          ),
        ),
      ),
    );
  },
)
```

3. **在 Scaffold 中使用**:
```dart
Scaffold(
  appBar: AppBar(title: Text('地图')),
  body: MtMapWidget(
    params: MtMapWidgetParams(
      apiKey: 'your_api_key',
      initialPosition: MtMapPosition(
        latitude: 39.9042,
        longitude: 116.4074,
        zoom: 15.0,
      ),
    ),
  ),
)
```

### 2. PlatformView 创建失败

**错误信息**:
```
PlatformException(create, Failed to create platform view, null)
```

**原因**: 原生地图视图创建失败。

**解决方案**:

1. **检查 API 密钥**:
```dart
// 确保 API 密钥有效且不为空
MtMapWidget(
  params: MtMapWidgetParams(
    apiKey: 'your_valid_api_key', // 确保这是有效的密钥
    initialPosition: MtMapPosition(
      latitude: 39.9042,
      longitude: 116.4074,
      zoom: 15.0,
    ),
  ),
  callbacks: MtMapWidgetCallbacks(
    onMapError: (error) {
      print('地图错误: $error');
      // 处理错误
    },
  ),
)
```

2. **检查平台配置**:
   - Android: 确保在 `android/app/src/main/AndroidManifest.xml` 中添加了必要的权限
   - iOS: 确保在 `ios/Runner/Info.plist` 中添加了位置权限描述

### 3. 地图不显示

**可能原因**:
- API 密钥无效
- 网络连接问题
- 平台配置错误

**解决方案**:

1. **添加错误回调**:
```dart
MtMapWidget(
  params: MtMapWidgetParams(
    apiKey: 'your_api_key',
    initialPosition: MtMapPosition(
      latitude: 39.9042,
      longitude: 116.4074,
      zoom: 15.0,
    ),
  ),
  callbacks: MtMapWidgetCallbacks(
    onMapReady: () {
      print('地图准备完成');
    },
    onMapError: (error) {
      print('地图错误: $error');
      // 显示错误信息给用户
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('地图加载失败: $error')),
      );
    },
  ),
)
```

2. **检查网络权限**:
```xml
<!-- Android: android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### 4. 性能问题

**问题**: 地图加载缓慢或卡顿。

**解决方案**:

1. **使用合适的初始位置**:
```dart
MtMapWidget(
  params: MtMapWidgetParams(
    apiKey: 'your_api_key',
    initialPosition: MtMapPosition(
      latitude: 39.9042,
      longitude: 116.4074,
      zoom: 15.0, // 使用合适的缩放级别
    ),
  ),
)
```

2. **避免频繁的状态更新**:
```dart
// ✅ 正确方式 - 使用 setState 批量更新
setState(() {
  _markers.add(newMarker);
  _polylines.add(newPolyline);
});

// ❌ 错误方式 - 频繁调用 setState
setState(() {
  _markers.add(newMarker);
});
setState(() {
  _polylines.add(newPolyline);
});
```

### 5. 地图拖拽错误

**问题**: 地图拖拽后出现错误或崩溃。

**错误信息**:
```
PlatformException(showMap, showMap called on a disposed plugin, null)
```

**原因**: 拖拽过程中调用了已弃用的方法或原生方法未正确实现。

**解决方案**:

1. **使用正确的回调处理**:
```dart
MtMapWidget(
  params: MtMapWidgetParams(
    apiKey: 'your_api_key',
    initialPosition: MtMapPosition(
      latitude: 39.9042,
      longitude: 116.4074,
      zoom: 15.0,
    ),
  ),
  callbacks: MtMapWidgetCallbacks(
    onMapReady: () {
      print('地图准备完成');
    },
    onMapError: (error) {
      print('地图错误: $error');
      // 处理错误，避免应用崩溃
    },
    onCameraMove: (latitude, longitude, zoom) {
      print('相机移动: $latitude, $longitude, $zoom');
      // 处理相机移动事件
    },
    onCameraIdle: () {
      print('相机停止移动');
      // 处理相机停止事件
    },
  ),
)
```

2. **避免在拖拽过程中进行复杂操作**:
```dart
// ✅ 正确方式 - 延迟操作
bool _isDragging = false;

MtMapWidgetCallbacks(
  onCameraMove: (latitude, longitude, zoom) {
    _isDragging = true;
    // 避免在拖拽过程中进行复杂操作
  },
  onCameraIdle: () {
    _isDragging = false;
    // 拖拽结束后进行操作
    _performComplexOperation();
  },
)
```

3. **使用防抖处理**:
```dart
Timer? _debounceTimer;

MtMapWidgetCallbacks(
  onCameraMove: (latitude, longitude, zoom) {
    // 取消之前的定时器
    _debounceTimer?.cancel();
    // 设置新的定时器
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      // 拖拽停止300ms后执行操作
      _updateMapData(latitude, longitude, zoom);
    });
  },
)
```

### 6. 内存泄漏

**问题**: 应用内存使用量持续增长。

**解决方案**:

1. **正确释放资源**:
```dart
class _MapScreenState extends State<MapScreen> {
  Timer? _debounceTimer;
  
  @override
  void dispose() {
    _debounceTimer?.cancel();
    // 清理资源
    super.dispose();
  }
}
```

2. **避免在回调中持有强引用**:
```dart
// ✅ 正确方式 - 使用弱引用
MtMapWidgetCallbacks(
  onMapClick: (latitude, longitude) {
    // 避免在这里持有强引用
    print('点击: $latitude, $longitude');
  },
)

// ❌ 错误方式 - 可能造成内存泄漏
MtMapWidgetCallbacks(
  onMapClick: (latitude, longitude) {
    // 避免在这里持有强引用
    this.someHeavyObject.doSomething();
  },
)
```

## 调试技巧

### 1. 启用详细日志

```dart
// 在开发环境中启用详细日志
if (kDebugMode) {
  MtMapWidget(
    params: MtMapWidgetParams(
      apiKey: 'your_api_key',
      initialPosition: MtMapPosition(
        latitude: 39.9042,
        longitude: 116.4074,
        zoom: 15.0,
      ),
    ),
    callbacks: MtMapWidgetCallbacks(
      onMapReady: () => print('地图准备完成'),
      onMapError: (error) => print('地图错误: $error'),
      onMapClick: (lat, lng) => print('地图点击: $lat, $lng'),
    ),
  )
}
```

### 2. 检查平台版本

```dart
// 检查平台版本
final platformVersion = await MtMap.getPlatformVersion();
print('平台版本: $platformVersion');
```

### 3. 测试网络连接

```dart
// 测试网络连接
import 'package:connectivity_plus/connectivity_plus.dart';

final connectivityResult = await Connectivity().checkConnectivity();
if (connectivityResult == ConnectivityResult.none) {
  print('无网络连接');
}
```

## 获取帮助

如果以上解决方案无法解决您的问题，请：

1. 检查 [GitHub Issues](https://github.com/your-repo/mt_map_plugin/issues)
2. 创建新的 Issue 并提供以下信息：
   - Flutter 版本
   - 平台版本 (Android/iOS)
   - 完整的错误信息
   - 复现步骤
   - 代码示例

## 最佳实践

1. **始终提供错误回调**:
```dart
MtMapWidgetCallbacks(
  onMapError: (error) {
    // 处理错误
  },
)
```

2. **使用合适的布局约束**:
```dart
Container(
  width: double.infinity,
  height: 300,
  child: MtMapWidget(...),
)
```

3. **测试不同设备**:
   - 在不同尺寸的设备上测试
   - 测试横屏和竖屏模式
   - 测试网络连接变化

4. **性能优化**:
   - 避免频繁的地图操作
   - 使用合适的缩放级别
   - 及时清理不需要的资源
