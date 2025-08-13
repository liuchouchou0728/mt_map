# MT Map Flutter Plugin

一个用于在Flutter应用中集成美团地图SDK的插件，支持iOS和Android平台。

## 功能特性

- 🗺️ 地图显示和控制
- 📍 位置标记和POI管理
- 📍 实时位置获取和更新
- 🛣️ 路线规划和导航
- 🔍 附近地点搜索
- 📱 跨平台支持（iOS/Android）

## 安装

### 1. 添加依赖

在您的`pubspec.yaml`文件中添加依赖：

```yaml
dependencies:
  mt_map: ^1.0.0
```

### 2. 获取美团地图API Key

1. 访问[美团地图开放平台](https://lbs.amap.com/)
2. 注册开发者账号并创建应用
3. 获取API Key

### 3. 平台配置

#### Android 配置

在`android/app/src/main/AndroidManifest.xml`中添加权限：

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

在`android/app/build.gradle`中添加美团地图SDK依赖：

```gradle
dependencies {
    // 美团地图SDK依赖（需要根据实际SDK版本调整）
    implementation 'com.meituan.android.mapsdk:mapsdk:latest.release'
}
```

#### iOS 配置

在`ios/Runner/Info.plist`中添加权限描述：

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>此应用需要访问位置信息以显示地图和提供导航服务</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>此应用需要访问位置信息以显示地图和提供导航服务</string>
```

在`ios/Podfile`中添加美团地图SDK依赖：

```ruby
target 'Runner' do
  # 美团地图SDK依赖
  pod 'MTMapSDK', '~> 1.0.0'
end
```

## 使用方法

### 1. 初始化地图

```dart
import 'package:mt_map/mt_map.dart';

// 初始化地图SDK
bool success = await MtMap.initialize('your_meituan_map_api_key_here');
if (success) {
  print('地图初始化成功');
} else {
  print('地图初始化失败');
}
```

### 2. 显示地图

```dart
// 显示地图到指定位置
bool success = await MtMap.showMap(
  latitude: 39.9042,
  longitude: 116.4074,
  zoom: 15.0,
  title: '北京天安门',
  snippet: '中国北京市东城区天安门广场',
);
```

### 3. 添加标记点

```dart
// 添加标记点
bool success = await MtMap.addMarker(
  latitude: 39.9042,
  longitude: 116.4074,
  title: '天安门',
  snippet: '中国北京市东城区天安门广场',
);
```

### 4. 获取当前位置

```dart
// 获取当前位置
final location = await MtMap.getCurrentLocation();
if (location != null) {
  print('纬度: ${location['latitude']}');
  print('经度: ${location['longitude']}');
  print('精度: ${location['accuracy']}');
}
```

### 5. 搜索附近地点

```dart
// 搜索附近地点
final places = await MtMap.searchNearby(
  latitude: 39.9042,
  longitude: 116.4074,
  radius: 1000.0,
  keyword: '餐厅',
);
if (places != null) {
  print('找到 ${places.length} 个附近地点');
  for (var place in places) {
    print('${place['name']}: ${place['address']}');
  }
}
```

### 6. 计算路线

```dart
// 计算路线
bool success = await MtMap.calculateRoute(
  startLatitude: 39.9042,
  startLongitude: 116.4074,
  endLatitude: 39.9087,
  endLongitude: 116.3975,
  transportMode: 'driving', // 可选: driving, walking, bicycling, transit
);
```

### 7. 位置更新监听

```dart
// 开始位置更新
bool success = await MtMap.startLocationUpdates();

// 停止位置更新
bool success = await MtMap.stopLocationUpdates();
```

## API 参考

### 主要方法

| 方法 | 描述 | 参数 |
|------|------|------|
| `initialize(apiKey)` | 初始化地图SDK | `apiKey`: 美团地图API Key |
| `showMap()` | 显示地图 | `latitude`, `longitude`, `zoom`, `title`, `snippet` |
| `hideMap()` | 隐藏地图 | 无 |
| `addMarker()` | 添加标记点 | `latitude`, `longitude`, `title`, `snippet`, `iconPath` |
| `removeMarker(markerId)` | 移除标记点 | `markerId`: 标记点ID |
| `setMapCenter()` | 设置地图中心 | `latitude`, `longitude`, `zoom` |
| `getCurrentLocation()` | 获取当前位置 | 无 |
| `startLocationUpdates()` | 开始位置更新 | 无 |
| `stopLocationUpdates()` | 停止位置更新 | 无 |
| `calculateRoute()` | 计算路线 | `startLatitude`, `startLongitude`, `endLatitude`, `endLongitude`, `transportMode` |
| `searchNearby()` | 搜索附近地点 | `latitude`, `longitude`, `radius`, `keyword`, `category` |

## 注意事项

1. **API Key**: 请确保使用有效的美团地图API Key
2. **权限**: 确保应用有适当的位置权限
3. **网络**: 地图功能需要网络连接
4. **SDK版本**: 请根据美团地图SDK的最新版本调整依赖配置

## 示例应用

查看 `example/` 目录中的完整示例应用，了解如何使用所有功能。

## 贡献

欢迎提交Issue和Pull Request来改进这个插件。

## 许可证

MIT License
