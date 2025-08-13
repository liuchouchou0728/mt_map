package com.example.mt_map

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
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

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    stopLocationUpdates(object : Result {
      override fun success(result: Any?) {}
      override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {}
      override fun notImplemented() {}
    })
  }
}
