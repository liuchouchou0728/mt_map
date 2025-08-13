# MT Map Plugin 集成指南

本指南将帮助您将美团地图插件集成到您的Flutter应用中。

## 目录

1. [环境要求](#环境要求)
2. [安装配置](#安装配置)
3. [平台配置](#平台配置)
4. [基本使用](#基本使用)
5. [高级功能](#高级功能)
6. [常见问题](#常见问题)

## 环境要求

- Flutter SDK: >=3.0.0
- Dart SDK: >=3.0.0
- iOS: 12.0+
- Android: API 21+ (Android 5.0+)

## 安装配置

### 1. 添加依赖

在您的`pubspec.yaml`文件中添加依赖：

```yaml
dependencies:
  flutter:
    sdk: flutter
  mt_map: ^1.0.0
```

### 2. 获取美团地图API密钥

1. 访问[美团地图开放平台](https://lbs.amap.com/)
2. 注册开发者账号并创建应用
3. 获取API密钥

## 平台配置

### Android 配置

#### 1. 权限配置

在`android/app/src/main/AndroidManifest.xml`中添加权限：

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- 网络权限 -->
    <uses-permission android:name="android.permission.INTERNET" />
    
    <!-- 位置权限 -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    
    <!-- 网络状态权限 -->
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    
    <application>
        <!-- 其他配置 -->
    </application>
</manifest>
```

#### 2. 美团地图SDK配置

在`android/app/build.gradle`中添加依赖：

```gradle
dependencies {
    // 美团地图SDK（请根据实际SDK版本调整）
    implementation 'com.meituan.android.mapsdk:mapsdk:latest.release'
    
    // 其他依赖...
}
```

#### 3. 混淆配置

在`android/app/proguard-rules.pro`中添加混淆规则：

```proguard
# 美团地图SDK混淆规则
-keep class com.meituan.** { *; }
-keep class com.mtmap.** { *; }
```

### iOS 配置

#### 1. 权限配置

在`ios/Runner/Info.plist`中添加权限描述：

```xml
<dict>
    <!-- 位置权限描述 -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>此应用需要访问位置信息以显示您在地图上的位置</string>
    
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>此应用需要访问位置信息以显示您在地图上的位置</string>
    
    <!-- 网络权限描述 -->
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
    
    <!-- 其他配置 -->
</dict>
```

#### 2. 美团地图SDK配置

在`ios/Podfile`中添加依赖：

```ruby
target 'Runner' do
  # 美团地图SDK
  pod 'MTMapSDK', '~> 1.0.0'
  
  # 其他依赖...
end
```

#### 3. 安装依赖

在iOS项目目录下运行：

```bash
cd ios
pod install
```

## 基本使用

### 1. 使用地图容器Widget（推荐方式）

```dart
import 'package:mt_map/mt_map.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('美团地图')),
      body: MtMapWidget(
        params: MtMapWidgetParams(
          apiKey: 'your_meituan_map_api_key_here', // 在这里提供API密钥
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
          onMapClick: (latitude, longitude) {
            print('地图点击: $latitude, $longitude');
          },
        ),
      ),
    );
  }
}
```

### 2. 手动初始化（已弃用）

```dart
import 'package:mt_map/mt_map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 注意：这种方式已弃用，建议使用MtMapWidget
  await MtMap.initialize('your_meituan_map_api_key_here');
  
  runApp(MyApp());
}

// 然后使用基础API（已弃用）
await MtMap.showMap(
  latitude: 39.9042,
  longitude: 116.4074,
  zoom: 15.0,
);
```

### 3. 添加标记点

```dart
final marker = MtMapMarker(
  latitude: 39.9042,
  longitude: 116.4074,
  title: '天安门',
  snippet: '中国北京市东城区天安门广场',
  iconPath: 'assets/marker_icon.png',
);

MtMapWidget(
  params: MtMapWidgetParams(
    apiKey: 'your_api_key',
    initialMarkers: [marker],
  ),
)
```

### 4. 添加路线

```dart
final polyline = MtMapPolyline(
  points: [
    MtMapPosition(latitude: 39.9042, longitude: 116.4074),
    MtMapPosition(latitude: 39.9142, longitude: 116.4174),
    MtMapPosition(latitude: 39.9242, longitude: 116.4274),
  ],
  color: Colors.blue,
  width: 5.0,
);

MtMapWidget(
  params: MtMapWidgetParams(
    apiKey: 'your_api_key',
    initialPolylines: [polyline],
  ),
)
```

### 5. 添加多边形

```dart
final polygon = MtMapPolygon(
  points: [
    MtMapPosition(latitude: 39.9042, longitude: 116.4074),
    MtMapPosition(latitude: 39.9142, longitude: 116.4074),
    MtMapPosition(latitude: 39.9142, longitude: 116.4174),
    MtMapPosition(latitude: 39.9042, longitude: 116.4174),
  ],
  fillColor: Colors.green.withOpacity(0.3),
  strokeColor: Colors.green,
  strokeWidth: 2.0,
);

MtMapWidget(
  params: MtMapWidgetParams(
    apiKey: 'your_api_key',
    initialPolygons: [polygon],
  ),
)
```

## 高级功能

### 1. 动态添加和移除元素

```dart
class MapController extends StatefulWidget {
  @override
  _MapControllerState createState() => _MapControllerState();
}

class _MapControllerState extends State<MapController> {
  List<MtMapMarker> markers = [];
  List<MtMapPolyline> polylines = [];
  List<MtMapPolygon> polygons = [];

  void addMarker(double latitude, double longitude) {
    setState(() {
      markers.add(MtMapMarker(
        latitude: latitude,
        longitude: longitude,
        title: '标记 ${markers.length + 1}',
      ));
    });
  }

  void removeMarker(int index) {
    setState(() {
      markers.removeAt(index);
    });
  }

  void clearAll() {
    setState(() {
      markers.clear();
      polylines.clear();
      polygons.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MtMapWidget(
        params: MtMapWidgetParams(
          apiKey: 'your_api_key',
          initialMarkers: markers,
          initialPolylines: polylines,
          initialPolygons: polygons,
        ),
        callbacks: MtMapWidgetCallbacks(
          onMapClick: (latitude, longitude) {
            addMarker(latitude, longitude);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: clearAll,
        child: Icon(Icons.clear),
      ),
    );
  }
}
```

### 2. 位置服务

```dart
class LocationService {
  static Future<Map<String, dynamic>?> getCurrentLocation() async {
    return await MtMap.getCurrentLocation();
  }

  static Future<bool> startLocationUpdates() async {
    return await MtMap.startLocationUpdates();
  }

  static Future<bool> stopLocationUpdates() async {
    return await MtMap.stopLocationUpdates();
  }
}

// 使用示例
class LocationWidget extends StatefulWidget {
  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  Map<String, dynamic>? currentLocation;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    final location = await LocationService.getCurrentLocation();
    setState(() {
      currentLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (currentLocation != null)
          Text('当前位置: ${currentLocation!['latitude']}, ${currentLocation!['longitude']}'),
        ElevatedButton(
          onPressed: _getLocation,
          child: Text('刷新位置'),
        ),
      ],
    );
  }
}
```

### 3. 搜索功能

```dart
class SearchService {
  static Future<List<Map<String, dynamic>>?> searchNearby({
    required double latitude,
    required double longitude,
    required double radius,
    String? keyword,
    String? category,
  }) async {
    return await MtMap.searchNearby(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      keyword: keyword,
      category: category,
    );
  }
}

// 使用示例
Future<void> searchRestaurants() async {
  final places = await SearchService.searchNearby(
    latitude: 39.9042,
    longitude: 116.4074,
    radius: 1000.0,
    keyword: '餐厅',
  );
  
  if (places != null) {
    print('找到 ${places.length} 个餐厅');
    for (var place in places) {
      print('${place['name']}: ${place['address']}');
    }
  }
}
```

### 4. 路线规划

```dart
class RouteService {
  static Future<bool> calculateRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
    String transportMode = 'driving',
  }) async {
    return await MtMap.calculateRoute(
      startLatitude: startLatitude,
      startLongitude: startLongitude,
      endLatitude: endLatitude,
      endLongitude: endLongitude,
      transportMode: transportMode,
    );
  }
}

// 使用示例
Future<void> planRoute() async {
  final success = await RouteService.calculateRoute(
    startLatitude: 39.9042,
    startLongitude: 116.4074,
    endLatitude: 39.9087,
    endLongitude: 116.3975,
    transportMode: 'driving',
  );
  
  if (success) {
    print('路线规划成功');
  } else {
    print('路线规划失败');
  }
}
```

### 5. 地图样式定制

```dart
class CustomMapStyle {
  static MtMapStyle get darkStyle => MtMapStyle(
    backgroundColor: Colors.black,
    showTraffic: true,
    showBuildings: true,
    mapType: 'normal',
  );

  static MtMapStyle get satelliteStyle => MtMapStyle(
    mapType: 'satellite',
    showTraffic: false,
    showBuildings: false,
  );

  static MtMapStyle get hybridStyle => MtMapStyle(
    mapType: 'hybrid',
    showTraffic: true,
    showBuildings: true,
  );
}

// 使用示例
MtMapWidget(
  params: MtMapWidgetParams(apiKey: 'your_api_key'),
  style: CustomMapStyle.darkStyle,
)
```

## 常见问题

### 1. 地图不显示

**问题**: 地图容器显示空白或加载失败

**解决方案**:
- 检查API密钥是否正确
- 确认网络连接正常
- 检查平台配置是否正确
- 查看控制台错误信息

### 2. 位置权限问题

**问题**: 无法获取位置信息

**解决方案**:
- 检查权限配置
- 在运行时请求位置权限
- 确认设备位置服务已开启

### 3. 标记点不显示

**问题**: 添加的标记点在地图上不可见

**解决方案**:
- 检查坐标是否正确
- 确认地图已完全加载
- 检查标记点图标路径

### 4. 性能问题

**问题**: 地图加载缓慢或卡顿

**解决方案**:
- 减少同时显示的标记点数量
- 使用适当的缩放级别
- 优化图片资源大小

### 5. 平台兼容性

**问题**: 在特定平台上功能异常

**解决方案**:
- 检查平台版本要求
- 确认SDK版本兼容性
- 查看平台特定的配置

## 调试技巧

### 1. 启用调试模式

```dart
// 在开发环境中启用详细日志
if (kDebugMode) {
  // 添加调试信息
  print('地图状态: $mapState');
  print('标记点数量: ${markers.length}');
}
```

### 2. 错误处理

```dart
try {
  await MtMap.initialize('your_api_key');
} catch (e) {
  print('初始化失败: $e');
  // 显示用户友好的错误信息
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('初始化失败'),
      content: Text('请检查网络连接和API密钥'),
    ),
  );
}
```

### 3. 状态监控

```dart
class MapStateMonitor {
  static void logMapEvent(String event, [Map<String, dynamic>? data]) {
    if (kDebugMode) {
      print('地图事件: $event');
      if (data != null) {
        print('事件数据: $data');
      }
    }
  }
}
```

## 最佳实践

1. **API密钥管理**: 不要在代码中硬编码API密钥，使用环境变量或配置文件
2. **错误处理**: 始终添加适当的错误处理机制
3. **性能优化**: 合理使用标记点和路线，避免过度绘制
4. **用户体验**: 提供加载状态和错误反馈
5. **测试**: 在不同设备和平台上测试功能

## 支持

如果您遇到问题或需要帮助，请：

1. 查看[常见问题](#常见问题)部分
2. 检查[示例代码](example/lib/main.dart)
3. 提交Issue到项目仓库
4. 查看美团地图官方文档

---

希望这个集成指南能帮助您成功集成美团地图插件！如果您有任何问题或建议，请随时联系我们。
