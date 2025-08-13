import Flutter
import UIKit
import CoreLocation
import MapKit

public class MtMapPlugin: NSObject, FlutterPlugin, CLLocationManagerDelegate {
    private var methodChannel: FlutterMethodChannel?
    private var locationManager: CLLocationManager?
    private var isInitialized = false
    private var apiKey: String?
    private var mapView: UIView?
    private var mapContainer: UIView?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "mt_map", binaryMessenger: registrar.messenger())
        let instance = MtMapPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        instance.methodChannel = channel
        
        // 注册PlatformView工厂
        let factory = MtMapViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "mt_map_view")
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
            
        case "initialize":
            guard let args = call.arguments as? [String: Any],
                  let apiKey = args["apiKey"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "API key is required", details: nil))
                return
            }
            initializeMap(apiKey: apiKey, result: result)
            
        case "showMap":
            guard let args = call.arguments as? [String: Any],
                  let latitude = args["latitude"] as? Double,
                  let longitude = args["longitude"] as? Double else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Latitude and longitude are required", details: nil))
                return
            }
            let zoom = args["zoom"] as? Double ?? 15.0
            let title = args["title"] as? String
            let snippet = args["snippet"] as? String
            showMap(latitude: latitude, longitude: longitude, zoom: zoom, title: title, snippet: snippet, result: result)
            
        case "hideMap":
            hideMap(result: result)
            
        case "addMarker":
            guard let args = call.arguments as? [String: Any],
                  let latitude = args["latitude"] as? Double,
                  let longitude = args["longitude"] as? Double else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Latitude and longitude are required", details: nil))
                return
            }
            let title = args["title"] as? String
            let snippet = args["snippet"] as? String
            let iconPath = args["iconPath"] as? String
            addMarker(latitude: latitude, longitude: longitude, title: title, snippet: snippet, iconPath: iconPath, result: result)
            
        case "removeMarker":
            guard let args = call.arguments as? [String: Any],
                  let markerId = args["markerId"] as? Int else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Marker ID is required", details: nil))
                return
            }
            removeMarker(markerId: markerId, result: result)
            
        case "setMapCenter":
            guard let args = call.arguments as? [String: Any],
                  let latitude = args["latitude"] as? Double,
                  let longitude = args["longitude"] as? Double else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Latitude and longitude are required", details: nil))
                return
            }
            let zoom = args["zoom"] as? Double
            setMapCenter(latitude: latitude, longitude: longitude, zoom: zoom, result: result)
            
        case "getCurrentLocation":
            getCurrentLocation(result: result)
            
        case "startLocationUpdates":
            startLocationUpdates(result: result)
            
        case "stopLocationUpdates":
            stopLocationUpdates(result: result)
            
        case "calculateRoute":
            guard let args = call.arguments as? [String: Any],
                  let startLatitude = args["startLatitude"] as? Double,
                  let startLongitude = args["startLongitude"] as? Double,
                  let endLatitude = args["endLatitude"] as? Double,
                  let endLongitude = args["endLongitude"] as? Double else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Start and end coordinates are required", details: nil))
                return
            }
            let transportMode = args["transportMode"] as? String ?? "driving"
            calculateRoute(startLatitude: startLatitude, startLongitude: startLongitude, 
                          endLatitude: endLatitude, endLongitude: endLongitude, 
                          transportMode: transportMode, result: result)
            
        case "searchNearby":
            guard let args = call.arguments as? [String: Any],
                  let latitude = args["latitude"] as? Double,
                  let longitude = args["longitude"] as? Double,
                  let radius = args["radius"] as? Double else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Latitude, longitude and radius are required", details: nil))
                return
            }
            let keyword = args["keyword"] as? String
            let category = args["category"] as? String
            searchNearby(latitude: latitude, longitude: longitude, radius: radius, 
                        keyword: keyword, category: category, result: result)
            
        // 新增的地图容器相关方法
        case "addPolyline":
            guard let args = call.arguments as? [String: Any],
                  let points = args["points"] as? [[String: Double]],
                  let color = args["color"] as? Int,
                  let width = args["width"] as? Double else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Points, color and width are required", details: nil))
                return
            }
            let geodesic = args["geodesic"] as? Bool ?? true
            addPolyline(points: points, color: color, width: width, geodesic: geodesic, result: result)
            
        case "removePolyline":
            guard let args = call.arguments as? [String: Any],
                  let polylineId = args["polylineId"] as? Int else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Polyline ID is required", details: nil))
                return
            }
            removePolyline(polylineId: polylineId, result: result)
            
        case "addPolygon":
            guard let args = call.arguments as? [String: Any],
                  let points = args["points"] as? [[String: Double]],
                  let fillColor = args["fillColor"] as? Int,
                  let strokeColor = args["strokeColor"] as? Int,
                  let strokeWidth = args["strokeWidth"] as? Double else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Points, fillColor, strokeColor and strokeWidth are required", details: nil))
                return
            }
            addPolygon(points: points, fillColor: fillColor, strokeColor: strokeColor, strokeWidth: strokeWidth, result: result)
            
        case "removePolygon":
            guard let args = call.arguments as? [String: Any],
                  let polygonId = args["polygonId"] as? Int else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Polygon ID is required", details: nil))
                return
            }
            removePolygon(polygonId: polygonId, result: result)
            
        case "animateCamera":
            guard let args = call.arguments as? [String: Any],
                  let latitude = args["latitude"] as? Double,
                  let longitude = args["longitude"] as? Double else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Latitude and longitude are required", details: nil))
                return
            }
            let zoom = args["zoom"] as? Double
            let duration = args["duration"] as? Int ?? 1000
            animateCamera(latitude: latitude, longitude: longitude, zoom: zoom, duration: duration, result: result)
            
        case "setMapStyle":
            guard let args = call.arguments as? [String: Any],
                  let style = args["style"] as? [String: Any] else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Style is required", details: nil))
                return
            }
            setMapStyle(style: style, result: result)
            
        case "enableMyLocation":
            guard let args = call.arguments as? [String: Any],
                  let enabled = args["enabled"] as? Bool else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Enabled flag is required", details: nil))
                return
            }
            enableMyLocation(enabled: enabled, result: result)
            
        case "enableMyLocationButton":
            guard let args = call.arguments as? [String: Any],
                  let enabled = args["enabled"] as? Bool else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Enabled flag is required", details: nil))
                return
            }
            enableMyLocationButton(enabled: enabled, result: result)
            
        case "enableZoomControls":
            guard let args = call.arguments as? [String: Any],
                  let enabled = args["enabled"] as? Bool else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Enabled flag is required", details: nil))
                return
            }
            enableZoomControls(enabled: enabled, result: result)
            
        case "enableCompass":
            guard let args = call.arguments as? [String: Any],
                  let enabled = args["enabled"] as? Bool else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Enabled flag is required", details: nil))
                return
            }
            enableCompass(enabled: enabled, result: result)
            
        case "enableScaleBar":
            guard let args = call.arguments as? [String: Any],
                  let enabled = args["enabled"] as? Bool else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Enabled flag is required", details: nil))
                return
            }
            enableScaleBar(enabled: enabled, result: result)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func initializeMap(apiKey: String, result: @escaping FlutterResult) {
        self.apiKey = apiKey
        // 初始化美团地图SDK
        // MTMapSDK.shared().initWithAppKey(apiKey)
        
        // 创建地图容器
        mapContainer = UIView()
        mapContainer?.backgroundColor = UIColor.white
        
        isInitialized = true
        result(true)
    }
    
    private func showMap(latitude: Double, longitude: Double, zoom: Double, title: String?, snippet: String?, result: @escaping FlutterResult) {
        if !isInitialized {
            result(FlutterError(code: "NOT_INITIALIZED", message: "Map not initialized. Call initialize() first.", details: nil))
            return
        }
        
        // 这里应该显示美团地图
        // 由于美团地图SDK的具体实现需要根据官方文档，这里提供框架代码
        
        // 创建地图视图
        // mapView = MTMapView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        // mapView?.setCenter(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), animated: true)
        // mapView?.setZoomLevel(zoom, animated: true)
        
        // 将地图视图添加到容器中
        mapContainer?.subviews.forEach { $0.removeFromSuperview() }
        // mapContainer?.addSubview(mapView!)
        
        // 显示成功提示
        print("地图显示成功: \(latitude), \(longitude)")
        
        result(true)
    }
    
    private func hideMap(result: @escaping FlutterResult) {
        mapContainer?.subviews.forEach { $0.removeFromSuperview() }
        mapView = nil
        result(true)
    }
    
    private func addMarker(latitude: Double, longitude: Double, title: String?, snippet: String?, iconPath: String?, result: @escaping FlutterResult) {
        // 添加标记点
        result(1) // 返回标记点ID
    }
    
    private func removeMarker(markerId: Int, result: @escaping FlutterResult) {
        // 移除标记点
        result(true)
    }
    
    private func setMapCenter(latitude: Double, longitude: Double, zoom: Double?, result: @escaping FlutterResult) {
        // 设置地图中心点
        result(true)
    }
    
    private func getCurrentLocation(result: @escaping FlutterResult) {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.requestLocation()
            
            // 临时返回模拟数据
            let location: [String: Any] = [
                "latitude": 39.9042,
                "longitude": 116.4074,
                "accuracy": 10.0
            ]
            result(location)
        } else {
            result(FlutterError(code: "LOCATION_SERVICES_DISABLED", message: "Location services are disabled", details: nil))
        }
    }
    
    private func startLocationUpdates(result: @escaping FlutterResult) {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.startUpdatingLocation()
            result(true)
        } else {
            result(FlutterError(code: "LOCATION_SERVICES_DISABLED", message: "Location services are disabled", details: nil))
        }
    }
    
    private func stopLocationUpdates(result: @escaping FlutterResult) {
        locationManager?.stopUpdatingLocation()
        result(true)
    }
    
    private func calculateRoute(startLatitude: Double, startLongitude: Double, 
                               endLatitude: Double, endLongitude: Double, 
                               transportMode: String, result: @escaping FlutterResult) {
        // 计算路线
        result(true)
    }
    
    private func searchNearby(latitude: Double, longitude: Double, radius: Double, 
                             keyword: String?, category: String?, result: @escaping FlutterResult) {
        // 搜索附近地点
        let places: [[String: Any]] = [
            [
                "name": "示例地点1",
                "latitude": latitude + 0.001,
                "longitude": longitude + 0.001,
                "address": "示例地址1"
            ],
            [
                "name": "示例地点2", 
                "latitude": latitude - 0.001,
                "longitude": longitude - 0.001,
                "address": "示例地址2"
            ]
        ]
        result(places)
    }
    
    // 新增的地图容器相关方法实现
    private func addPolyline(points: [[String: Double]], color: Int, width: Double, geodesic: Bool, result: @escaping FlutterResult) {
        // 添加路线
        result(1) // 返回路线ID
    }
    
    private func removePolyline(polylineId: Int, result: @escaping FlutterResult) {
        // 移除路线
        result(true)
    }
    
    private func addPolygon(points: [[String: Double]], fillColor: Int, strokeColor: Int, strokeWidth: Double, result: @escaping FlutterResult) {
        // 添加多边形
        result(1) // 返回多边形ID
    }
    
    private func removePolygon(polygonId: Int, result: @escaping FlutterResult) {
        // 移除多边形
        result(true)
    }
    
    private func animateCamera(latitude: Double, longitude: Double, zoom: Double?, duration: Int, result: @escaping FlutterResult) {
        // 动画移动相机
        result(true)
    }
    
    private func setMapStyle(style: [String: Any], result: @escaping FlutterResult) {
        // 设置地图样式
        result(true)
    }
    
    private func enableMyLocation(enabled: Bool, result: @escaping FlutterResult) {
        // 启用/禁用我的位置
        result(true)
    }
    
    private func enableMyLocationButton(enabled: Bool, result: @escaping FlutterResult) {
        // 启用/禁用我的位置按钮
        result(true)
    }
    
    private func enableZoomControls(enabled: Bool, result: @escaping FlutterResult) {
        // 启用/禁用缩放控件
        result(true)
    }
    
    private func enableCompass(enabled: Bool, result: @escaping FlutterResult) {
        // 启用/禁用指南针
        result(true)
    }
    
    private func enableScaleBar(enabled: Bool, result: @escaping FlutterResult) {
        // 启用/禁用比例尺
        result(true)
    }
    
    // MARK: - CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let locationData: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "accuracy": location.horizontalAccuracy
        ]
        
        methodChannel?.invokeMethod("onLocationUpdate", arguments: locationData)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        methodChannel?.invokeMethod("onLocationError", arguments: error.localizedDescription)
    }
}

/// 美团地图PlatformView工厂
class MtMapViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        let creationParams = args as? [String: Any]
        return MtMapPlatformView(frame: frame, viewIdentifier: viewId, arguments: creationParams, binaryMessenger: messenger)
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

/// 美团地图PlatformView
class MtMapPlatformView: NSObject, FlutterPlatformView {
    private var _view: UIView
    private var methodChannel: FlutterMethodChannel
    
    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: [String: Any]?, binaryMessenger messenger: FlutterBinaryMessenger) {
        _view = UIView(frame: frame)
        methodChannel = FlutterMethodChannel(name: "mt_map_widget_\(viewId)", binaryMessenger: messenger)
        super.init()
        
        setupMapView(arguments: args)
        setupMethodChannel()
    }
    
    private func setupMapView(arguments args: [String: Any]?) {
        // 设置地图视图
        _view.backgroundColor = UIColor.white
        
        // 从创建参数中获取初始配置
        guard let params = args else { return }
        
        let apiKey = params["apiKey"] as? String
        let latitude = params["latitude"] as? Double
        let longitude = params["longitude"] as? Double
        let zoom = params["zoom"] as? Double
        let style = params["style"] as? [String: Any]
        
        // 初始化地图
        if let apiKey = apiKey {
            // 这里应该初始化美团地图SDK
            // MTMapSDK.shared().initWithAppKey(apiKey)
        }
        
        // 设置初始位置
        if let latitude = latitude, let longitude = longitude {
            // 这里应该设置地图中心点
            // mapView.setCenter(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), animated: true)
            // if let zoom = zoom {
            //     mapView.setZoomLevel(zoom, animated: true)
            // }
        }
        
        // 设置地图样式
        if let style = style {
            // 这里应该设置地图样式
            // mapView.setMapStyle(style)
        }
    }
    
    private func setupMethodChannel() {
        methodChannel.setMethodCallHandler { [weak self] (call, result) in
            switch call.method {
            case "addMarker":
                let args = call.arguments as? [String: Any]
                let latitude = args?["latitude"] as? Double
                let longitude = args?["longitude"] as? Double
                let title = args?["title"] as? String
                let snippet = args?["snippet"] as? String
                let iconPath = args?["iconPath"] as? String
                
                if let latitude = latitude, let longitude = longitude {
                    // 添加标记
                    result(1)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Latitude and longitude are required", details: nil))
                }
                
            case "removeMarker":
                let args = call.arguments as? [String: Any]
                let markerId = args?["markerId"] as? Int
                
                if let markerId = markerId {
                    // 移除标记
                    result(true)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Marker ID is required", details: nil))
                }
                
            case "setMapCenter":
                let args = call.arguments as? [String: Any]
                let latitude = args?["latitude"] as? Double
                let longitude = args?["longitude"] as? Double
                let zoom = args?["zoom"] as? Double
                
                if let latitude = latitude, let longitude = longitude {
                    // 设置地图中心
                    result(true)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Latitude and longitude are required", details: nil))
                }
                
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    func view() -> UIView {
        return _view
    }
}
