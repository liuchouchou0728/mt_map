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
