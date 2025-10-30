# MT Map Plugin

一个用于在iOS和Android平台上集成美团地图SDK的Flutter插件。

## 功能特性

- 🗺️ 地图集成
- 📍 标记点管理
- 🛣️ 路线绘制
- 🔲 多边形绘制
- 📱 位置服务
- 🔍 地点搜索
- 🚗 路线规划
- 🎨 地图样式定制
- 📱 原生地图容器Widget

## 安装

在您的`pubspec.yaml`文件中添加依赖：

```yaml
dependencies:
  mt_map: ^1.0.0
```

## 快速开始

### 使用地图容器Widget

```dart
import 'package:mt_map/mt_map.dart';

// 地图容器会自动处理初始化，无需手动调用initialize
MtMapWidget(
  params: MtMapWidgetParams(
    apiKey: 'your_meituan_map_api_key_here', // 在这里提供API密钥
    initialPosition: MtMapPosition(
      latitude: 39.9042,
      longitude: 116.4074,
      zoom: 15.0,
    ),
  ),
  callbacks: MtMapWidgetCallbacks(
    onMapReady: () => print('地图准备完成'),
    onMapError: (error) => print('地图错误: $error'),
  ),
)
```



### 3. 添加标记点

```dart
// 添加标记点
final marker = MtMapMarker(
  latitude: 39.9042,
  longitude: 116.4074,
  title: '天安门',
  snippet: '中国北京市东城区天安门广场',
  iconPath: 'assets/marker_icon.png',
);

// 在Widget中使用
MtMapWidget(
  params: MtMapWidgetParams(
    apiKey: 'your_api_key',
    initialMarkers: [marker],
  ),
)
```

### 4. 添加路线

```dart
// 添加路线
final polyline = MtMapPolyline(
  points: [
    MtMapPosition(latitude: 39.9042, longitude: 116.4074),
    MtMapPosition(latitude: 39.9142, longitude: 116.4174),
    MtMapPosition(latitude: 39.9242, longitude: 116.4274),
  ],
  color: Colors.blue,
  width: 5.0,
);

// 在Widget中使用
MtMapWidget(
  params: MtMapWidgetParams(
    apiKey: 'your_api_key',
    initialPolylines: [polyline],
  ),
)
```

### 5. 添加多边形

```dart
// 添加多边形
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

// 在Widget中使用
MtMapWidget(
  params: MtMapWidgetParams(
    apiKey: 'your_api_key',
    initialPolygons: [polygon],
  ),
)
```

## API 参考

### MtMapWidget

主要的Flutter Widget，用于显示美团地图。

#### 参数

- `params` (MtMapWidgetParams): 地图初始化参数
- `callbacks` (MtMapWidgetCallbacks?): 地图事件回调
- `style` (MtMapStyle?): 地图样式配置

### MtMapWidgetParams

地图Widget的初始化参数。

```dart
class MtMapWidgetParams {
  final String apiKey;                    // API密钥
  final MtMapPosition? initialPosition;   // 初始位置
  final List<MtMapMarker> initialMarkers; // 初始标记
  final List<MtMapPolyline> initialPolylines; // 初始路线
  final List<MtMapPolygon> initialPolygons;   // 初始多边形
}
```

### MtMapPosition

地图位置信息。

```dart
class MtMapPosition {
  final double latitude;   // 纬度
  final double longitude;  // 经度
  final double? zoom;      // 缩放级别
}
```

### MtMapMarker

地图标记点。

```dart
class MtMapMarker {
  final int? id;           // 标记ID
  final double latitude;   // 纬度
  final double longitude;  // 经度
  final String? title;     // 标题
  final String? snippet;   // 描述
  final String? iconPath;  // 图标路径
  final Color? iconColor;  // 图标颜色
  final double? iconSize;  // 图标大小
}
```

### MtMapPolyline

地图路线。

```dart
class MtMapPolyline {
  final List<MtMapPosition> points; // 路线点
  final Color color;                // 路线颜色
  final double width;               // 路线宽度
  final bool geodesic;              // 是否大地线
}
```

### MtMapPolygon

地图多边形。

```dart
class MtMapPolygon {
  final List<MtMapPosition> points; // 多边形顶点
  final Color fillColor;            // 填充颜色
  final Color strokeColor;          // 边框颜色
  final double strokeWidth;         // 边框宽度
}
```

### MtMapStyle

地图样式配置。

```dart
class MtMapStyle {
  final Color? backgroundColor;  // 背景颜色
  final bool? showTraffic;       // 显示交通
  final bool? showBuildings;     // 显示建筑物
  final bool? showIndoorMap;     // 显示室内地图
  final String? mapType;         // 地图类型 ('normal', 'satellite', 'hybrid')
}
```

### MtMapWidgetCallbacks

地图事件回调。

```dart
class MtMapWidgetCallbacks {
  final VoidCallback? onMapReady;           // 地图准备完成
  final Function(String error)? onMapError; // 地图错误
  final Function(double lat, double lng)? onMapClick; // 地图点击
  final Function(MtMapMarker marker)? onMarkerClick;  // 标记点击
  final Function(double lat, double lng, double zoom)? onCameraMove; // 相机移动
  final VoidCallback? onCameraIdle;         // 相机停止移动
  final Function(double lat, double lng, double accuracy)? onLocationUpdate; // 位置更新
}
```

## 原生API（已弃用）

除了Widget接口，插件还提供了原生API用于更细粒度的控制（已弃用，建议使用MtMapWidget）：

### 基础功能

```dart
// 初始化（已弃用，建议使用MtMapWidget）
@deprecated
await MtMap.initialize('your_api_key');

// 显示地图（已弃用，建议使用MtMapWidget）
@deprecated
await MtMap.showMap(
  latitude: 39.9042,
  longitude: 116.4074,
  zoom: 15.0,
  title: '天安门',
  snippet: '中国北京市东城区天安门广场',
);

// 隐藏地图
await MtMap.hideMap();

// 添加标记
await MtMap.addMarker(
  latitude: 39.9042,
  longitude: 116.4074,
  title: '天安门',
  snippet: '中国北京市东城区天安门广场',
);

// 移除标记
await MtMap.removeMarker(markerId);

// 设置地图中心
await MtMap.setMapCenter(
  latitude: 39.9042,
  longitude: 116.4074,
  zoom: 15.0,
);
```

### 位置服务

```dart
// 获取当前位置
final location = await MtMap.getCurrentLocation();

// 开始位置更新
await MtMap.startLocationUpdates();

// 停止位置更新
await MtMap.stopLocationUpdates();
```

### 搜索和路线

```dart
// 搜索附近地点
final places = await MtMap.searchNearby(
  latitude: 39.9042,
  longitude: 116.4074,
  radius: 1000.0,
  keyword: '餐厅',
);

// 计算路线
await MtMap.calculateRoute(
  startLatitude: 39.9042,
  startLongitude: 116.4074,
  endLatitude: 39.9087,
  endLongitude: 116.3975,
  transportMode: 'driving',
);
```

### 新增的地图容器功能

```dart
// 添加路线
await MtMap.addPolyline(
  points: [
    {'latitude': 39.9042, 'longitude': 116.4074},
    {'latitude': 39.9142, 'longitude': 116.4174},
  ],
  color: Colors.blue.value,
  width: 5.0,
);

// 添加多边形
await MtMap.addPolygon(
  points: [
    {'latitude': 39.9042, 'longitude': 116.4074},
    {'latitude': 39.9142, 'longitude': 116.4074},
    {'latitude': 39.9142, 'longitude': 116.4174},
  ],
  fillColor: Colors.green.value,
  strokeColor: Colors.green.value,
  strokeWidth: 2.0,
);

// 动画移动相机
await MtMap.animateCamera(
  latitude: 39.9042,
  longitude: 116.4074,
  zoom: 15.0,
  duration: 1000,
);

// 设置地图样式
await MtMap.setMapStyle({
  'showTraffic': true,
  'showBuildings': true,
  'mapType': 'normal',
});

// 启用/禁用控件
await MtMap.enableMyLocation(true);
await MtMap.enableMyLocationButton(true);
await MtMap.enableZoomControls(true);
await MtMap.enableCompass(true);
await MtMap.enableScaleBar(true);
```

## 平台配置

### Android

在`android/app/src/main/AndroidManifest.xml`中添加权限：

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### iOS

在`ios/Runner/Info.plist`中添加权限描述：

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>此应用需要访问位置信息以显示您在地图上的位置</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>此应用需要访问位置信息以显示您在地图上的位置</string>
```

## 注意事项

1. **API密钥**: 请确保使用有效的美团地图API密钥
2. **权限**: 确保应用有适当的位置权限
3. **网络**: 地图功能需要网络连接
4. **平台支持**: 目前支持iOS和Android平台

## 示例

查看`example/lib/main.dart`文件获取完整的使用示例。

## 许可证

本项目采用MIT许可证。详见[LICENSE](LICENSE)文件。
