# 美团地图SDK集成指南

本指南将帮助您将真实的美团地图SDK集成到Flutter插件中。

## 1. 获取美团地图SDK

### 访问美团地图开放平台
1. 访问 [美团地图开放平台](https://lbs.amap.com/)
2. 注册开发者账号
3. 创建应用并获取API Key

### 下载SDK
- **Android**: 下载Android SDK包
- **iOS**: 下载iOS SDK包或通过CocoaPods安装

## 2. Android集成

### 2.1 添加SDK依赖

在 `android/build.gradle` 中取消注释并更新SDK依赖：

```gradle
dependencies {
    // 美团地图SDK依赖
    implementation 'com.meituan.android.mapsdk:mapsdk:latest.release'
    // 或者使用具体版本号
    // implementation 'com.meituan.android.mapsdk:mapsdk:1.0.0'
}
```

### 2.2 更新插件代码

在 `android/src/main/kotlin/com/example/mt_map/MtMapPlugin.kt` 中：

1. **添加SDK导入**：
```kotlin
import com.meituan.android.mapsdk.*
```

2. **更新初始化方法**：
```kotlin
private fun initializeMap(apiKey: String, result: Result) {
    try {
        // 初始化美团地图SDK
        MTMapSDK.init(context, apiKey)
        
        // 创建地图容器
        mapContainer = FrameLayout(context)
        mapContainer?.layoutParams = ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )
        
        isInitialized = true
        result.success(true)
    } catch (e: Exception) {
        result.error("INITIALIZATION_ERROR", "Failed to initialize map: ${e.message}", null)
    }
}
```

3. **更新显示地图方法**：
```kotlin
private fun showMap(latitude: Double, longitude: Double, zoom: Double, title: String?, snippet: String?, result: Result) {
    if (!isInitialized) {
        result.error("NOT_INITIALIZED", "Map not initialized. Call initialize() first.", null)
        return
    }
    
    try {
        // 创建地图视图
        mapView = MTMapView(context)
        mapView?.setMapCenter(MTMapPointGeo(latitude, longitude))
        mapView?.setZoomLevel(zoom.toInt())
        
        // 将地图视图添加到容器中
        mapContainer?.removeAllViews()
        mapContainer?.addView(mapView)
        
        result.success(true)
    } catch (e: Exception) {
        result.error("SHOW_MAP_ERROR", "Failed to show map: ${e.message}", null)
    }
}
```

4. **更新添加标记点方法**：
```kotlin
private fun addMarker(latitude: Double, longitude: Double, title: String?, snippet: String?, iconPath: String?, result: Result) {
    try {
        val marker = MTMapPOIItem()
        marker.mapPoint = MTMapPointGeo(latitude, longitude)
        marker.itemName = title ?: ""
        marker.itemName = snippet ?: ""
        
        if (iconPath != null) {
            // 设置自定义图标
            // marker.setCustomImage(iconPath)
        }
        
        mapView?.addPOIItem(marker)
        result.success(marker.tag) // 返回标记点ID
    } catch (e: Exception) {
        result.error("ADD_MARKER_ERROR", "Failed to add marker: ${e.message}", null)
    }
}
```

## 3. iOS集成

### 3.1 添加SDK依赖

在 `ios/mt_map.podspec` 中取消注释并更新SDK依赖：

```ruby
s.dependency 'MTMapSDK', '~> 1.0.0'
```

### 3.2 更新插件代码

在 `ios/Classes/MtMapPlugin.swift` 中：

1. **添加SDK导入**：
```swift
import MTMapSDK
```

2. **更新初始化方法**：
```swift
private func initializeMap(apiKey: String, result: @escaping FlutterResult) {
    self.apiKey = apiKey
    // 初始化美团地图SDK
    MTMapSDK.shared().initWithAppKey(apiKey)
    
    // 创建地图容器
    mapContainer = UIView()
    mapContainer?.backgroundColor = UIColor.white
    
    isInitialized = true
    result(true)
}
```

3. **更新显示地图方法**：
```swift
private func showMap(latitude: Double, longitude: Double, zoom: Double, title: String?, snippet: String?, result: @escaping FlutterResult) {
    if !isInitialized {
        result(FlutterError(code: "NOT_INITIALIZED", message: "Map not initialized. Call initialize() first.", details: nil))
        return
    }
    
    // 创建地图视图
    mapView = MTMapView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    mapView?.setCenter(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), animated: true)
    mapView?.setZoomLevel(zoom, animated: true)
    
    // 将地图视图添加到容器中
    mapContainer?.subviews.forEach { $0.removeFromSuperview() }
    mapContainer?.addSubview(mapView!)
    
    result(true)
}
```

4. **更新添加标记点方法**：
```swift
private func addMarker(latitude: Double, longitude: Double, title: String?, snippet: String?, iconPath: String?, result: @escaping FlutterResult) {
    // 添加标记点
    let annotation = MTMapPOIItem()
    annotation.mapPoint = MTMapPointGeo(latitude: latitude, longitude: longitude)
    annotation.itemName = title ?? ""
    annotation.itemName = snippet ?? ""
    
    if let iconPath = iconPath {
        // 设置自定义图标
        // annotation.setCustomImage(iconPath)
    }
    
    mapView?.addPOIItem(annotation)
    result(annotation.tag) // 返回标记点ID
}
```

## 4. 配置API Key

### 4.1 在应用中配置

在您的Flutter应用中：

```dart
import 'package:mt_map/mt_map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化地图SDK
  await MtMap.initialize('your_meituan_map_api_key_here');
  
  runApp(MyApp());
}
```

### 4.2 环境变量配置

为了安全起见，建议使用环境变量：

```dart
// 从环境变量或配置文件读取API Key
const apiKey = String.fromEnvironment('MEITUAN_MAP_API_KEY');
await MtMap.initialize(apiKey);
```

## 5. 测试集成

### 5.1 运行示例应用

```bash
cd example
flutter run
```

### 5.2 验证功能

1. 检查地图是否正确显示
2. 测试标记点添加功能
3. 验证位置获取功能
4. 测试搜索和路线规划功能

## 6. 常见问题

### 6.1 地图不显示
- 检查API Key是否正确
- 确认网络连接正常
- 验证权限配置

### 6.2 位置获取失败
- 检查位置权限是否已授予
- 确认设备GPS已开启
- 验证位置服务是否正常

### 6.3 编译错误
- 检查SDK版本兼容性
- 确认依赖配置正确
- 验证代码语法

## 7. 注意事项

1. **API Key安全**: 不要在代码中硬编码API Key
2. **版本兼容**: 确保SDK版本与应用兼容
3. **权限管理**: 正确处理位置权限请求
4. **错误处理**: 实现适当的错误处理机制
5. **性能优化**: 注意地图性能优化

## 8. 更多资源

- [美团地图开放平台文档](https://lbs.amap.com/)
- [Android SDK文档](https://lbs.amap.com/api/android-sdk/)
- [iOS SDK文档](https://lbs.amap.com/api/ios-sdk/)
- [Flutter插件开发指南](https://flutter.dev/docs/development/packages-and-plugins/developing-packages)
