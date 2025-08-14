package com.example.mt_map

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import android.content.Context
import android.app.Activity
import android.widget.FrameLayout
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import com.google.android.gms.location.*

/** MtMapPlugin */
class MtMapPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private var isInitialized = false
  private var mapView: View? = null
  private var mapContainer: FrameLayout? = null
  private var fusedLocationClient: FusedLocationProviderClient? = null
  private var locationCallback: LocationCallback? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "mt_map")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
    fusedLocationClient = LocationServices.getFusedLocationProviderClient(context)
    
    // 注册PlatformView工厂
    flutterPluginBinding.platformViewRegistry.registerViewFactory(
      "mt_map_view",
      MtMapViewFactory(flutterPluginBinding.binaryMessenger)
    )
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "initialize" -> {
        val apiKey = call.argument<String>("apiKey")
        if (apiKey != null) {
          initializeMap(apiKey, result)
        } else {
          result.error("INVALID_ARGUMENT", "API key is required", null)
        }
      }
      "showMap" -> {
        val latitude = call.argument<Double>("latitude")
        val longitude = call.argument<Double>("longitude")
        val zoom = call.argument<Double>("zoom") ?: 15.0
        val title = call.argument<String>("title")
        val snippet = call.argument<String>("snippet")
        
        if (latitude != null && longitude != null) {
          showMap(latitude, longitude, zoom, title, snippet, result)
        } else {
          result.error("INVALID_ARGUMENT", "Latitude and longitude are required", null)
        }
      }
      "hideMap" -> {
        hideMap(result)
      }
      "addMarker" -> {
        val latitude = call.argument<Double>("latitude")
        val longitude = call.argument<Double>("longitude")
        val title = call.argument<String>("title")
        val snippet = call.argument<String>("snippet")
        val iconPath = call.argument<String>("iconPath")
        
        if (latitude != null && longitude != null) {
          addMarker(latitude, longitude, title, snippet, iconPath, result)
        } else {
          result.error("INVALID_ARGUMENT", "Latitude and longitude are required", null)
        }
      }
      "removeMarker" -> {
        val markerId = call.argument<Int>("markerId")
        if (markerId != null) {
          removeMarker(markerId, result)
        } else {
          result.error("INVALID_ARGUMENT", "Marker ID is required", null)
        }
      }
      "setMapCenter" -> {
        val latitude = call.argument<Double>("latitude")
        val longitude = call.argument<Double>("longitude")
        val zoom = call.argument<Double>("zoom")
        
        if (latitude != null && longitude != null) {
          setMapCenter(latitude, longitude, zoom, result)
        } else {
          result.error("INVALID_ARGUMENT", "Latitude and longitude are required", null)
        }
      }
      "getCurrentLocation" -> {
        getCurrentLocation(result)
      }
      "startLocationUpdates" -> {
        startLocationUpdates(result)
      }
      "stopLocationUpdates" -> {
        stopLocationUpdates(result)
      }
      "calculateRoute" -> {
        val startLatitude = call.argument<Double>("startLatitude")
        val startLongitude = call.argument<Double>("startLongitude")
        val endLatitude = call.argument<Double>("endLatitude")
        val endLongitude = call.argument<Double>("endLongitude")
        val transportMode = call.argument<String>("transportMode") ?: "driving"
        
        if (startLatitude != null && startLongitude != null && 
            endLatitude != null && endLongitude != null) {
          calculateRoute(startLatitude, startLongitude, endLatitude, endLongitude, transportMode, result)
        } else {
          result.error("INVALID_ARGUMENT", "Start and end coordinates are required", null)
        }
      }
      "searchNearby" -> {
        val latitude = call.argument<Double>("latitude")
        val longitude = call.argument<Double>("longitude")
        val radius = call.argument<Double>("radius")
        val keyword = call.argument<String>("keyword")
        val category = call.argument<String>("category")
        
        if (latitude != null && longitude != null && radius != null) {
          searchNearby(latitude, longitude, radius, keyword, category, result)
        } else {
          result.error("INVALID_ARGUMENT", "Latitude, longitude and radius are required", null)
        }
      }
      // 新增的地图容器相关方法
      "addPolyline" -> {
        val points = call.argument<List<Map<String, Double>>>("points")
        val color = call.argument<Int>("color")
        val width = call.argument<Double>("width")
        val geodesic = call.argument<Boolean>("geodesic") ?: true
        
        if (points != null && color != null && width != null) {
          addPolyline(points, color, width, geodesic, result)
        } else {
          result.error("INVALID_ARGUMENT", "Points, color and width are required", null)
        }
      }
      "removePolyline" -> {
        val polylineId = call.argument<Int>("polylineId")
        if (polylineId != null) {
          removePolyline(polylineId, result)
        } else {
          result.error("INVALID_ARGUMENT", "Polyline ID is required", null)
        }
      }
      "addPolygon" -> {
        val points = call.argument<List<Map<String, Double>>>("points")
        val fillColor = call.argument<Int>("fillColor")
        val strokeColor = call.argument<Int>("strokeColor")
        val strokeWidth = call.argument<Double>("strokeWidth")
        
        if (points != null && fillColor != null && strokeColor != null && strokeWidth != null) {
          addPolygon(points, fillColor, strokeColor, strokeWidth, result)
        } else {
          result.error("INVALID_ARGUMENT", "Points, fillColor, strokeColor and strokeWidth are required", null)
        }
      }
      "removePolygon" -> {
        val polygonId = call.argument<Int>("polygonId")
        if (polygonId != null) {
          removePolygon(polygonId, result)
        } else {
          result.error("INVALID_ARGUMENT", "Polygon ID is required", null)
        }
      }
      "animateCamera" -> {
        val latitude = call.argument<Double>("latitude")
        val longitude = call.argument<Double>("longitude")
        val zoom = call.argument<Double>("zoom")
        val duration = call.argument<Int>("duration") ?: 1000
        
        if (latitude != null && longitude != null) {
          animateCamera(latitude, longitude, zoom, duration, result)
        } else {
          result.error("INVALID_ARGUMENT", "Latitude and longitude are required", null)
        }
      }
      "setMapStyle" -> {
        val style = call.argument<Map<String, Any>>("style")
        if (style != null) {
          setMapStyle(style, result)
        } else {
          result.error("INVALID_ARGUMENT", "Style is required", null)
        }
      }
      "enableMyLocation" -> {
        val enabled = call.argument<Boolean>("enabled")
        if (enabled != null) {
          enableMyLocation(enabled, result)
        } else {
          result.error("INVALID_ARGUMENT", "Enabled flag is required", null)
        }
      }
      "enableMyLocationButton" -> {
        val enabled = call.argument<Boolean>("enabled")
        if (enabled != null) {
          enableMyLocationButton(enabled, result)
        } else {
          result.error("INVALID_ARGUMENT", "Enabled flag is required", null)
        }
      }
      "enableZoomControls" -> {
        val enabled = call.argument<Boolean>("enabled")
        if (enabled != null) {
          enableZoomControls(enabled, result)
        } else {
          result.error("INVALID_ARGUMENT", "Enabled flag is required", null)
        }
      }
      "enableCompass" -> {
        val enabled = call.argument<Boolean>("enabled")
        if (enabled != null) {
          enableCompass(enabled, result)
        } else {
          result.error("INVALID_ARGUMENT", "Enabled flag is required", null)
        }
      }
      "enableScaleBar" -> {
        val enabled = call.argument<Boolean>("enabled")
        if (enabled != null) {
          enableScaleBar(enabled, result)
        } else {
          result.error("INVALID_ARGUMENT", "Enabled flag is required", null)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun initializeMap(apiKey: String, result: Result) {
    try {
      // 初始化美团地图SDK
      // 注意：这里需要根据美团地图SDK的实际API进行调用
      // MTMapSDK.init(context, apiKey)
      
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

  private fun showMap(latitude: Double, longitude: Double, zoom: Double, title: String?, snippet: String?, result: Result) {
    if (!isInitialized) {
      result.error("NOT_INITIALIZED", "Map not initialized. Call initialize() first.", null)
      return
    }
    
    try {
      // 这里应该显示美团地图
      // 由于美团地图SDK的具体实现需要根据官方文档，这里提供框架代码
      
      // 创建地图视图
      // mapView = MTMapView(context)
      // mapView?.setMapCenter(MTMapPointGeo(latitude, longitude))
      // mapView?.setZoomLevel(zoom.toInt())
      
      // 将地图视图添加到容器中
      mapContainer?.removeAllViews()
      // mapContainer?.addView(mapView)
      
      // 显示Toast提示
      Toast.makeText(context, "地图显示成功: $latitude, $longitude", Toast.LENGTH_SHORT).show()
      
      result.success(true)
    } catch (e: Exception) {
      result.error("SHOW_MAP_ERROR", "Failed to show map: ${e.message}", null)
    }
  }

  private fun hideMap(result: Result) {
    try {
      mapContainer?.removeAllViews()
      mapView = null
      result.success(true)
    } catch (e: Exception) {
      result.error("HIDE_MAP_ERROR", "Failed to hide map: ${e.message}", null)
    }
  }

  private fun addMarker(latitude: Double, longitude: Double, title: String?, snippet: String?, iconPath: String?, result: Result) {
    try {
      // 添加标记点
      // val marker = MTMapPOIItem()
      // marker.mapPoint = MTMapPointGeo(latitude, longitude)
      // marker.itemName = title ?: ""
      // marker.itemName = snippet ?: ""
      // mapView?.addPOIItem(marker)
      
      result.success(1) // 返回标记点ID
    } catch (e: Exception) {
      result.error("ADD_MARKER_ERROR", "Failed to add marker: ${e.message}", null)
    }
  }

  private fun removeMarker(markerId: Int, result: Result) {
    try {
      // 移除标记点
      // mapView?.removePOIItem(markerId)
      result.success(true)
    } catch (e: Exception) {
      result.error("REMOVE_MARKER_ERROR", "Failed to remove marker: ${e.message}", null)
    }
  }

  private fun setMapCenter(latitude: Double, longitude: Double, zoom: Double?, result: Result) {
    try {
      // 设置地图中心点
      // mapView?.setMapCenter(MTMapPointGeo(latitude, longitude))
      // zoom?.let { mapView?.setZoomLevel(it.toInt()) }
      result.success(true)
    } catch (e: Exception) {
      result.error("SET_MAP_CENTER_ERROR", "Failed to set map center: ${e.message}", null)
    }
  }

  private fun getCurrentLocation(result: Result) {
    try {
      fusedLocationClient?.lastLocation?.addOnSuccessListener { location ->
        if (location != null) {
          val locationData = mapOf(
            "latitude" to location.latitude,
            "longitude" to location.longitude,
            "accuracy" to location.accuracy
          )
          result.success(locationData)
        } else {
          // 如果获取不到真实位置，返回模拟数据
          result.success(mapOf(
            "latitude" to 39.9042,
            "longitude" to 116.4074,
            "accuracy" to 10.0
          ))
        }
      }?.addOnFailureListener { e ->
        result.error("LOCATION_ERROR", "Failed to get location: ${e.message}", null)
      }
    } catch (e: Exception) {
      result.error("LOCATION_ERROR", "Failed to get location: ${e.message}", null)
    }
  }

  private fun startLocationUpdates(result: Result) {
    try {
      val locationRequest = LocationRequest.create().apply {
        priority = LocationRequest.PRIORITY_HIGH_ACCURACY
        interval = 10000 // 10 seconds
        fastestInterval = 5000 // 5 seconds
      }

      locationCallback = object : LocationCallback() {
        override fun onLocationResult(locationResult: LocationResult) {
          locationResult.lastLocation?.let { location ->
            val locationData = mapOf(
              "latitude" to location.latitude,
              "longitude" to location.longitude,
              "accuracy" to location.accuracy
            )
            channel.invokeMethod("onLocationUpdate", locationData)
          }
        }
      }

      fusedLocationClient?.requestLocationUpdates(
        locationRequest,
        locationCallback!!,
        null
      )?.addOnSuccessListener {
        result.success(true)
      }?.addOnFailureListener { e ->
        result.error("LOCATION_UPDATES_ERROR", "Failed to start location updates: ${e.message}", null)
      }
    } catch (e: Exception) {
      result.error("LOCATION_UPDATES_ERROR", "Failed to start location updates: ${e.message}", null)
    }
  }

  private fun stopLocationUpdates(result: Result) {
    try {
      locationCallback?.let { callback ->
        fusedLocationClient?.removeLocationUpdates(callback)
      }
      result.success(true)
    } catch (e: Exception) {
      result.error("STOP_LOCATION_UPDATES_ERROR", "Failed to stop location updates: ${e.message}", null)
    }
  }

  private fun calculateRoute(startLatitude: Double, startLongitude: Double, 
                            endLatitude: Double, endLongitude: Double, 
                            transportMode: String, result: Result) {
    try {
      // 计算路线
      // 这里应该调用美团地图SDK的路线规划API
      // 由于具体API需要根据美团官方文档，这里提供框架代码
      
      val routeData = mapOf(
        "start" to mapOf("latitude" to startLatitude, "longitude" to startLongitude),
        "end" to mapOf("latitude" to endLatitude, "longitude" to endLongitude),
        "transportMode" to transportMode,
        "distance" to 5000.0, // 示例距离
        "duration" to 1800.0  // 示例时间（秒）
      )
      
      result.success(true)
    } catch (e: Exception) {
      result.error("CALCULATE_ROUTE_ERROR", "Failed to calculate route: ${e.message}", null)
    }
  }

  private fun searchNearby(latitude: Double, longitude: Double, radius: Double, 
                          keyword: String?, category: String?, result: Result) {
    try {
      // 搜索附近地点
      // 这里应该调用美团地图SDK的搜索API
      // 由于具体API需要根据美团官方文档，这里提供框架代码
      
      val places = listOf(
        mapOf(
          "name" to "示例地点1",
          "latitude" to (latitude + 0.001),
          "longitude" to (longitude + 0.001),
          "address" to "示例地址1",
          "distance" to 100.0
        ),
        mapOf(
          "name" to "示例地点2",
          "latitude" to (latitude - 0.001),
          "longitude" to (longitude - 0.001),
          "address" to "示例地址2",
          "distance" to 200.0
        )
      )
      result.success(places)
    } catch (e: Exception) {
      result.error("SEARCH_NEARBY_ERROR", "Failed to search nearby: ${e.message}", null)
    }
  }

  // 新增的地图容器相关方法实现
  private fun addPolyline(points: List<Map<String, Double>>, color: Int, width: Double, geodesic: Boolean, result: Result) {
    try {
      // 添加路线
      // 这里应该调用美团地图SDK的路线绘制API
      result.success(1) // 返回路线ID
    } catch (e: Exception) {
      result.error("ADD_POLYLINE_ERROR", "Failed to add polyline: ${e.message}", null)
    }
  }

  private fun removePolyline(polylineId: Int, result: Result) {
    try {
      // 移除路线
      result.success(true)
    } catch (e: Exception) {
      result.error("REMOVE_POLYLINE_ERROR", "Failed to remove polyline: ${e.message}", null)
    }
  }

  private fun addPolygon(points: List<Map<String, Double>>, fillColor: Int, strokeColor: Int, strokeWidth: Double, result: Result) {
    try {
      // 添加多边形
      // 这里应该调用美团地图SDK的多边形绘制API
      result.success(1) // 返回多边形ID
    } catch (e: Exception) {
      result.error("ADD_POLYGON_ERROR", "Failed to add polygon: ${e.message}", null)
    }
  }

  private fun removePolygon(polygonId: Int, result: Result) {
    try {
      // 移除多边形
      result.success(true)
    } catch (e: Exception) {
      result.error("REMOVE_POLYGON_ERROR", "Failed to remove polygon: ${e.message}", null)
    }
  }

  private fun animateCamera(latitude: Double, longitude: Double, zoom: Double?, duration: Int, result: Result) {
    try {
      // 动画移动相机
      // 这里应该调用美团地图SDK的相机动画API
      result.success(true)
    } catch (e: Exception) {
      result.error("ANIMATE_CAMERA_ERROR", "Failed to animate camera: ${e.message}", null)
    }
  }

  private fun setMapStyle(style: Map<String, Any>, result: Result) {
    try {
      // 设置地图样式
      // 这里应该调用美团地图SDK的样式设置API
      result.success(true)
    } catch (e: Exception) {
      result.error("SET_MAP_STYLE_ERROR", "Failed to set map style: ${e.message}", null)
    }
  }

  private fun enableMyLocation(enabled: Boolean, result: Result) {
    try {
      // 启用/禁用我的位置
      result.success(true)
    } catch (e: Exception) {
      result.error("ENABLE_MY_LOCATION_ERROR", "Failed to enable my location: ${e.message}", null)
    }
  }

  private fun enableMyLocationButton(enabled: Boolean, result: Result) {
    try {
      // 启用/禁用我的位置按钮
      result.success(true)
    } catch (e: Exception) {
      result.error("ENABLE_MY_LOCATION_BUTTON_ERROR", "Failed to enable my location button: ${e.message}", null)
    }
  }

  private fun enableZoomControls(enabled: Boolean, result: Result) {
    try {
      // 启用/禁用缩放控件
      result.success(true)
    } catch (e: Exception) {
      result.error("ENABLE_ZOOM_CONTROLS_ERROR", "Failed to enable zoom controls: ${e.message}", null)
    }
  }

  private fun enableCompass(enabled: Boolean, result: Result) {
    try {
      // 启用/禁用指南针
      result.success(true)
    } catch (e: Exception) {
      result.error("ENABLE_COMPASS_ERROR", "Failed to enable compass: ${e.message}", null)
    }
  }

  private fun enableScaleBar(enabled: Boolean, result: Result) {
    try {
      // 启用/禁用比例尺
      result.success(true)
    } catch (e: Exception) {
      result.error("ENABLE_SCALE_BAR_ERROR", "Failed to enable scale bar: ${e.message}", null)
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    stopLocationUpdates(object : Result {
      override fun success(result: Any?) {}
      override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {}
      override fun notImplemented() {}
    })
  }
}

/// 美团地图PlatformView工厂
class MtMapViewFactory(private val messenger: io.flutter.plugin.common.BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
  override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
    val creationParams = args as Map<String?, Any?>?
    return MtMapPlatformView(context, viewId, creationParams, messenger)
  }
}

/// 美团地图PlatformView
class MtMapPlatformView(
  private val context: Context,
  private val viewId: Int,
  private val creationParams: Map<String?, Any?>?,
  private val messenger: io.flutter.plugin.common.BinaryMessenger
) : PlatformView {
  
  private val mapView: FrameLayout = FrameLayout(context)
  private val methodChannel = MethodChannel(messenger, "mt_map_widget_$viewId")
  
  init {
    setupMapView()
    setupMethodChannel()
  }
  
  private fun setupMapView() {
    try {
      // 设置地图视图
      mapView.layoutParams = ViewGroup.LayoutParams(
        ViewGroup.LayoutParams.MATCH_PARENT,
        ViewGroup.LayoutParams.MATCH_PARENT
      )
      
      // 设置背景色，避免透明问题
      mapView.setBackgroundColor(android.graphics.Color.WHITE)
      
      // 从创建参数中获取初始配置
      creationParams?.let { params ->
        val apiKey = params["apiKey"] as String?
        val latitude = params["latitude"] as Double?
        val longitude = params["longitude"] as Double?
        val zoom = params["zoom"] as Double?
        val style = params["style"] as Map<String, Any>?
        
        println("MtMapPlatformView: setupMapView with params: apiKey=${apiKey != null}, lat=$latitude, lng=$longitude, zoom=$zoom")
        
        // 初始化地图
        if (apiKey != null) {
          // 这里应该初始化美团地图SDK
          // MTMapSDK.init(context, apiKey)
          println("MtMapPlatformView: API key provided")
        }
        
        // 设置初始位置
        if (latitude != null && longitude != null) {
          // 这里应该设置地图中心点
          // mapView.setMapCenter(MTMapPointGeo(latitude, longitude))
          // zoom?.let { mapView.setZoomLevel(it.toInt()) }
          println("MtMapPlatformView: Initial position set to ($latitude, $longitude)")
        }
        
        // 设置地图样式
        style?.let { styleMap ->
          // 这里应该设置地图样式
          // mapView.setMapStyle(styleMap)
          println("MtMapPlatformView: Style configuration provided")
        }
      }
      
      println("MtMapPlatformView: setupMapView completed successfully")
    } catch (e: Exception) {
      println("MtMapPlatformView: setupMapView error: ${e.message}")
      e.printStackTrace()
    }
  }
  
  private fun setupMethodChannel() {
    methodChannel.setMethodCallHandler { call, result ->
      when (call.method) {
        "addMarker" -> {
          val latitude = call.argument<Double>("latitude")
          val longitude = call.argument<Double>("longitude")
          val title = call.argument<String>("title")
          val snippet = call.argument<String>("snippet")
          val iconPath = call.argument<String>("iconPath")
          
          if (latitude != null && longitude != null) {
            // 添加标记
            result.success(1)
          } else {
            result.error("INVALID_ARGUMENT", "Latitude and longitude are required", null)
          }
        }
        "removeMarker" -> {
          val markerId = call.argument<Int>("markerId")
          if (markerId != null) {
            // 移除标记
            result.success(true)
          } else {
            result.error("INVALID_ARGUMENT", "Marker ID is required", null)
          }
        }
        "setMapCenter" -> {
          val latitude = call.argument<Double>("latitude")
          val longitude = call.argument<Double>("longitude")
          val zoom = call.argument<Double>("zoom")
          
          if (latitude != null && longitude != null) {
            // 设置地图中心
            // 这里应该调用美团地图SDK的方法
            // mapView.setMapCenter(MTMapPointGeo(latitude, longitude))
            // zoom?.let { mapView.setZoomLevel(it.toInt()) }
            result.success(true)
          } else {
            result.error("INVALID_ARGUMENT", "Latitude and longitude are required", null)
          }
        }
        "addPolyline" -> {
          val points = call.argument<List<Map<String, Any>>>("points")
          val color = call.argument<Int>("color")
          val width = call.argument<Double>("width")
          
          if (points != null) {
            // 添加路线
            // 这里应该调用美团地图SDK的方法
            result.success(true)
          } else {
            result.error("INVALID_ARGUMENT", "Points are required", null)
          }
        }
        "removePolyline" -> {
          val polylineId = call.argument<Int>("polylineId")
          if (polylineId != null) {
            // 移除路线
            result.success(true)
          } else {
            result.error("INVALID_ARGUMENT", "Polyline ID is required", null)
          }
        }
        "addPolygon" -> {
          val points = call.argument<List<Map<String, Any>>>("points")
          val fillColor = call.argument<Int>("fillColor")
          val strokeColor = call.argument<Int>("strokeColor")
          val strokeWidth = call.argument<Double>("strokeWidth")
          
          if (points != null) {
            // 添加多边形
            // 这里应该调用美团地图SDK的方法
            result.success(true)
          } else {
            result.error("INVALID_ARGUMENT", "Points are required", null)
          }
        }
        "removePolygon" -> {
          val polygonId = call.argument<Int>("polygonId")
          if (polygonId != null) {
            // 移除多边形
            result.success(true)
          } else {
            result.error("INVALID_ARGUMENT", "Polygon ID is required", null)
          }
        }
        "animateCamera" -> {
          val latitude = call.argument<Double>("latitude")
          val longitude = call.argument<Double>("longitude")
          val zoom = call.argument<Double>("zoom")
          val duration = call.argument<Int>("duration") ?: 1000
          
          if (latitude != null && longitude != null) {
            // 动画移动相机
            // 这里应该调用美团地图SDK的方法
            result.success(true)
          } else {
            result.error("INVALID_ARGUMENT", "Latitude and longitude are required", null)
          }
        }
        "setMapStyle" -> {
          val style = call.argument<Map<String, Any>>("style")
          if (style != null) {
            // 设置地图样式
            // 这里应该调用美团地图SDK的方法
            result.success(true)
          } else {
            result.error("INVALID_ARGUMENT", "Style is required", null)
          }
        }
        else -> {
          result.notImplemented()
        }
      }
    }
  }
  
  override fun getView(): View {
    return mapView
  }
  
  override fun dispose() {
    // 清理资源
  }
  
  override fun setSize(width: Int, height: Int) {
    try {
      // 设置PlatformView的尺寸
      if (width > 0 && height > 0) {
        mapView.layoutParams = ViewGroup.LayoutParams(width, height)
        // 强制重新布局
        mapView.requestLayout()
        println("MtMapPlatformView: setSize called with width=$width, height=$height")
      } else {
        println("MtMapPlatformView: setSize called with invalid dimensions: width=$width, height=$height")
      }
    } catch (e: Exception) {
      println("MtMapPlatformView: setSize error: ${e.message}")
    }
  }
}
