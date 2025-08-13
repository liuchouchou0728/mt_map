import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'mt_map.dart';

/// 美团地图容器Widget
class MtMapWidget extends StatefulWidget {
  /// 地图初始化参数
  final MtMapWidgetParams params;
  
  /// 地图事件回调
  final MtMapWidgetCallbacks? callbacks;
  
  /// 地图样式配置
  final MtMapStyle? style;

  const MtMapWidget({
    super.key,
    required this.params,
    this.callbacks,
    this.style,
  });

  @override
  State<MtMapWidget> createState() => _MtMapWidgetState();
}

class _MtMapWidgetState extends State<MtMapWidget> {
  static const MethodChannel _channel = MethodChannel('mt_map_widget');
  
  bool _isInitialized = false;
  bool _isMapReady = false;
  String? _errorMessage;
  
  // 地图状态
  double _currentLatitude = 39.9042;
  double _currentLongitude = 116.4074;
  double _currentZoom = 15.0;
  List<MtMapMarker> _markers = [];
  List<MtMapPolyline> _polylines = [];
  List<MtMapPolygon> _polygons = [];

  @override
  void initState() {
    super.initState();
    _setupMethodChannel();
    _initializeMap();
  }

  @override
  void dispose() {
    _disposeMap();
    super.dispose();
  }

  /// 初始化地图
  Future<void> _initializeMap() async {
    try {
      // 检查API Key是否有效
      if (widget.params.apiKey.isEmpty) {
        setState(() {
          _errorMessage = 'API Key is required';
        });
        widget.callbacks?.onMapError?.call('API Key is required');
        return;
      }

      // 初始化美团地图SDK
      final success = await MtMap.initialize(widget.params.apiKey);
      if (success) {
        setState(() {
          _isInitialized = true;
        });
        
        // 设置初始位置
        if (widget.params.initialPosition != null) {
          _currentLatitude = widget.params.initialPosition!.latitude;
          _currentLongitude = widget.params.initialPosition!.longitude;
          _currentZoom = widget.params.initialPosition!.zoom ?? 15.0;
        }
        
        // 显示地图
        await _showMap();
        
        // 添加初始标记
        if (widget.params.initialMarkers.isNotEmpty) {
          for (final marker in widget.params.initialMarkers) {
            await _addMarker(marker);
          }
        }
        
        // 添加初始路线
        if (widget.params.initialPolylines.isNotEmpty) {
          for (final polyline in widget.params.initialPolylines) {
            await _addPolyline(polyline);
          }
        }
        
        // 添加初始多边形
        if (widget.params.initialPolygons.isNotEmpty) {
          for (final polygon in widget.params.initialPolygons) {
            await _addPolygon(polygon);
          }
        }
        
        setState(() {
          _isMapReady = true;
        });
        
        widget.callbacks?.onMapReady?.call();
      } else {
        setState(() {
          _errorMessage = 'Failed to initialize map';
        });
        widget.callbacks?.onMapError?.call('Failed to initialize map');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      widget.callbacks?.onMapError?.call(e.toString());
    }
  }

  /// 设置方法通道
  void _setupMethodChannel() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onMapClick':
          final latitude = call.arguments['latitude'] as double;
          final longitude = call.arguments['longitude'] as double;
          widget.callbacks?.onMapClick?.call(latitude, longitude);
          break;
          
        case 'onMarkerClick':
          final markerId = call.arguments['markerId'] as int;
          final marker = _markers.firstWhere((m) => m.id == markerId);
          widget.callbacks?.onMarkerClick?.call(marker);
          break;
          
        case 'onCameraMove':
          final latitude = call.arguments['latitude'] as double;
          final longitude = call.arguments['longitude'] as double;
          final zoom = call.arguments['zoom'] as double;
          setState(() {
            _currentLatitude = latitude;
            _currentLongitude = longitude;
            _currentZoom = zoom;
          });
          widget.callbacks?.onCameraMove?.call(latitude, longitude, zoom);
          break;
          
        case 'onCameraIdle':
          widget.callbacks?.onCameraIdle?.call();
          break;
          
        case 'onLocationUpdate':
          final latitude = call.arguments['latitude'] as double;
          final longitude = call.arguments['longitude'] as double;
          final accuracy = call.arguments['accuracy'] as double;
          widget.callbacks?.onLocationUpdate?.call(latitude, longitude, accuracy);
          break;
      }
    });
  }

  /// 显示地图
  Future<void> _showMap() async {
    if (!_isInitialized) return;
    
    await MtMap.showMap(
      latitude: _currentLatitude,
      longitude: _currentLongitude,
      zoom: _currentZoom,
    );
  }

  /// 添加标记
  Future<void> _addMarker(MtMapMarker marker) async {
    if (!_isMapReady) return;
    
    final success = await MtMap.addMarker(
      latitude: marker.latitude,
      longitude: marker.longitude,
      title: marker.title,
      snippet: marker.snippet,
      iconPath: marker.iconPath,
    );
    
    if (success) {
      // 生成一个简单的ID
      final markerId = _markers.length + 1;
      setState(() {
        _markers.add(marker.copyWith(id: markerId));
      });
    }
  }

  /// 添加路线
  Future<void> _addPolyline(MtMapPolyline polyline) async {
    if (!_isMapReady) return;
    
    // 这里需要调用原生方法添加路线
    await _channel.invokeMethod('addPolyline', {
      'points': polyline.points.map((p) => {'latitude': p.latitude, 'longitude': p.longitude}).toList(),
      'color': polyline.color.value,
      'width': polyline.width,
    });
    
    setState(() {
      _polylines.add(polyline);
    });
  }

  /// 添加多边形
  Future<void> _addPolygon(MtMapPolygon polygon) async {
    if (!_isMapReady) return;
    
    // 这里需要调用原生方法添加多边形
    await _channel.invokeMethod('addPolygon', {
      'points': polygon.points.map((p) => {'latitude': p.latitude, 'longitude': p.longitude}).toList(),
      'fillColor': polygon.fillColor.value,
      'strokeColor': polygon.strokeColor.value,
      'strokeWidth': polygon.strokeWidth,
    });
    
    setState(() {
      _polygons.add(polygon);
    });
  }

  /// 销毁地图
  Future<void> _disposeMap() async {
    await MtMap.hideMap();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Container(
        color: Colors.grey[200],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                '地图加载失败',
                style: TextStyle(fontSize: 16, color: Colors.red[700]),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('正在加载地图...'),
            ],
          ),
        ),
      );
    }

    // 使用PlatformView显示原生地图
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: AndroidView(
            viewType: 'mt_map_view',
            onPlatformViewCreated: (int id) {
              // 地图视图创建完成
              setState(() {
                _isMapReady = true;
              });
              widget.callbacks?.onMapReady?.call();
            },
            creationParams: {
              'apiKey': widget.params.apiKey,
              'latitude': _currentLatitude,
              'longitude': _currentLongitude,
              'zoom': _currentZoom,
              'style': widget.style?.toMap(),
            },
            creationParamsCodec: const StandardMessageCodec(),
          ),
        );
      },
    );
  }
}

/// 地图Widget参数
class MtMapWidgetParams {
  /// API密钥
  final String apiKey;
  
  /// 初始位置
  final MtMapPosition? initialPosition;
  
  /// 初始标记
  final List<MtMapMarker> initialMarkers;
  
  /// 初始路线
  final List<MtMapPolyline> initialPolylines;
  
  /// 初始多边形
  final List<MtMapPolygon> initialPolygons;

  const MtMapWidgetParams({
    required this.apiKey,
    this.initialPosition,
    this.initialMarkers = const [],
    this.initialPolylines = const [],
    this.initialPolygons = const [],
  });
}

/// 地图位置
class MtMapPosition {
  final double latitude;
  final double longitude;
  final double? zoom;

  const MtMapPosition({
    required this.latitude,
    required this.longitude,
    this.zoom,
  });
}

/// 地图标记
class MtMapMarker {
  final int? id;
  final double latitude;
  final double longitude;
  final String? title;
  final String? snippet;
  final String? iconPath;
  final Color? iconColor;
  final double? iconSize;

  const MtMapMarker({
    this.id,
    required this.latitude,
    required this.longitude,
    this.title,
    this.snippet,
    this.iconPath,
    this.iconColor,
    this.iconSize,
  });

  MtMapMarker copyWith({
    int? id,
    double? latitude,
    double? longitude,
    String? title,
    String? snippet,
    String? iconPath,
    Color? iconColor,
    double? iconSize,
  }) {
    return MtMapMarker(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      title: title ?? this.title,
      snippet: snippet ?? this.snippet,
      iconPath: iconPath ?? this.iconPath,
      iconColor: iconColor ?? this.iconColor,
      iconSize: iconSize ?? this.iconSize,
    );
  }
}

/// 地图路线
class MtMapPolyline {
  final List<MtMapPosition> points;
  final Color color;
  final double width;
  final bool geodesic;

  const MtMapPolyline({
    required this.points,
    this.color = Colors.blue,
    this.width = 5.0,
    this.geodesic = true,
  });
}

/// 地图多边形
class MtMapPolygon {
  final List<MtMapPosition> points;
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;

  const MtMapPolygon({
    required this.points,
    this.fillColor = Colors.blue,
    this.strokeColor = Colors.blue,
    this.strokeWidth = 2.0,
  });
}

/// 地图样式
class MtMapStyle {
  final Color? backgroundColor;
  final bool? showTraffic;
  final bool? showBuildings;
  final bool? showIndoorMap;
  final String? mapType; // 'normal', 'satellite', 'hybrid'

  const MtMapStyle({
    this.backgroundColor,
    this.showTraffic,
    this.showBuildings,
    this.showIndoorMap,
    this.mapType,
  });

  Map<String, dynamic> toMap() {
    return {
      'backgroundColor': backgroundColor?.value,
      'showTraffic': showTraffic,
      'showBuildings': showBuildings,
      'showIndoorMap': showIndoorMap,
      'mapType': mapType,
    };
  }
}

/// 地图回调
class MtMapWidgetCallbacks {
  /// 地图准备完成
  final VoidCallback? onMapReady;
  
  /// 地图错误
  final Function(String error)? onMapError;
  
  /// 地图点击
  final Function(double latitude, double longitude)? onMapClick;
  
  /// 标记点击
  final Function(MtMapMarker marker)? onMarkerClick;
  
  /// 相机移动
  final Function(double latitude, double longitude, double zoom)? onCameraMove;
  
  /// 相机停止移动
  final VoidCallback? onCameraIdle;
  
  /// 位置更新
  final Function(double latitude, double longitude, double accuracy)? onLocationUpdate;

  const MtMapWidgetCallbacks({
    this.onMapReady,
    this.onMapError,
    this.onMapClick,
    this.onMarkerClick,
    this.onCameraMove,
    this.onCameraIdle,
    this.onLocationUpdate,
  });
}
