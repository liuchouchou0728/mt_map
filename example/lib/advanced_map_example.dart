import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mt_map/mt_map.dart';

/// 高级美团地图使用示例
/// 使用PlatformView方法通道动态管理地图元素
class AdvancedMapExample extends StatefulWidget {
  const AdvancedMapExample({super.key});

  @override
  State<AdvancedMapExample> createState() => _AdvancedMapExampleState();
}

class _AdvancedMapExampleState extends State<AdvancedMapExample> {
  List<MtMapMarker> _markers = [];
  List<MtMapPolyline> _polylines = [];
  List<MtMapPolygon> _polygons = [];
  bool _isMapReady = false;
  int? _platformViewId;
  MethodChannel? _platformViewChannel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('高级地图示例'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          // 地图容器
          Expanded(
            child: _buildMapContainer(),
          ),
          
          // 控制面板
          _buildControlPanel(),
        ],
      ),
    );
  }

  Widget _buildMapContainer() {
    return MtMapWidget(
      params: MtMapWidgetParams(
        apiKey: 'your_meituan_map_api_key_here',
        initialPosition: const MtMapPosition(
          latitude: 39.9042,
          longitude: 116.4074,
          zoom: 15.0,
        ),
        initialMarkers: _markers,
        initialPolylines: _polylines,
        initialPolygons: _polygons,
      ),
      style: const MtMapStyle(
        showTraffic: true,
        showBuildings: true,
        mapType: 'normal',
      ),
      callbacks: MtMapWidgetCallbacks(
        onMapReady: () {
          print('地图准备完成');
          setState(() {
            _isMapReady = true;
          });
        },
        onMapError: (error) {
          print('地图错误: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('地图错误: $error')),
          );
        },
        onMapClick: (latitude, longitude) {
          print('地图点击: $latitude, $longitude');
          if (_isMapReady) {
            _addMarkerDynamically(latitude, longitude);
          }
        },
        onMarkerClick: (marker) {
          print('标记点击: ${marker.title}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('点击了标记: ${marker.title ?? '未命名'}')),
          );
        },
        onCameraMove: (latitude, longitude, zoom) {
          print('相机移动: $latitude, $longitude, $zoom');
        },
        onCameraIdle: () {
          print('相机停止移动');
        },
        onLocationUpdate: (latitude, longitude, accuracy) {
          print('位置更新: $latitude, $longitude, 精度: $accuracy');
        },
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 功能按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _isMapReady ? _addRandomMarker : null,
                child: const Text('添加标记'),
              ),
              ElevatedButton(
                onPressed: _isMapReady ? _addPolyline : null,
                child: const Text('添加路线'),
              ),
              ElevatedButton(
                onPressed: _isMapReady ? _addPolygon : null,
                child: const Text('添加多边形'),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _isMapReady ? _clearAll : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('清除所有'),
              ),
              ElevatedButton(
                onPressed: _isMapReady ? _getCurrentLocation : null,
                child: const Text('获取位置'),
              ),
              ElevatedButton(
                onPressed: _isMapReady ? _searchNearby : null,
                child: const Text('搜索附近'),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // 状态信息
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text('地图状态: ${_isMapReady ? '就绪' : '加载中...'}'),
                Text('标记点数量: ${_markers.length}'),
                Text('路线数量: ${_polylines.length}'),
                Text('多边形数量: ${_polygons.length}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 动态添加标记（通过PlatformView方法通道）
  Future<void> _addMarkerDynamically(double latitude, double longitude) async {
    if (!_isMapReady || _platformViewChannel == null) return;
    
    try {
      final marker = MtMapMarker(
        id: _markers.length + 1,
        latitude: latitude,
        longitude: longitude,
        title: '动态标记 ${_markers.length + 1}',
        snippet: '通过方法通道添加的标记',
      );
      
      // 通过PlatformView方法通道添加标记
      final markerId = await _platformViewChannel!.invokeMethod('addMarker', {
        'latitude': marker.latitude,
        'longitude': marker.longitude,
        'title': marker.title,
        'snippet': marker.snippet,
      });
      
      if (markerId != null) {
        setState(() {
          _markers.add(marker.copyWith(id: markerId as int));
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('动态添加标记: ${marker.title}')),
        );
      }
    } catch (e) {
      print('动态添加标记失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('添加标记失败: $e')),
      );
    }
  }

  void _addRandomMarker() {
    if (!_isMapReady) return;
    
    final random = DateTime.now().millisecondsSinceEpoch;
    final latitude = 39.9042 + (random % 1000 - 500) / 10000.0;
    final longitude = 116.4074 + (random % 1000 - 500) / 10000.0;
    
    _addMarkerDynamically(latitude, longitude);
  }

  void _addPolyline() {
    if (!_isMapReady) return;
    
    final polyline = MtMapPolyline(
      points: [
        const MtMapPosition(latitude: 39.9042, longitude: 116.4074),
        const MtMapPosition(latitude: 39.9142, longitude: 116.4174),
        const MtMapPosition(latitude: 39.9242, longitude: 116.4274),
      ],
      color: Colors.blue,
      width: 5.0,
    );
    
    setState(() {
      _polylines.add(polyline);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('添加路线')),
    );
  }

  void _addPolygon() {
    if (!_isMapReady) return;
    
    final polygon = MtMapPolygon(
      points: [
        const MtMapPosition(latitude: 39.9042, longitude: 116.4074),
        const MtMapPosition(latitude: 39.9142, longitude: 116.4074),
        const MtMapPosition(latitude: 39.9142, longitude: 116.4174),
        const MtMapPosition(latitude: 39.9042, longitude: 116.4174),
      ],
      fillColor: Colors.green.withOpacity(0.3),
      strokeColor: Colors.green,
      strokeWidth: 2.0,
    );
    
    setState(() {
      _polygons.add(polygon);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('添加多边形')),
    );
  }

  void _clearAll() {
    if (!_isMapReady) return;
    
    setState(() {
      _markers.clear();
      _polylines.clear();
      _polygons.clear();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已清除所有元素')),
    );
  }

  Future<void> _getCurrentLocation() async {
    if (!_isMapReady) return;
    
    try {
      final location = await MtMap.getCurrentLocation();
      if (location != null) {
        final latitude = location['latitude'] as double;
        final longitude = location['longitude'] as double;
        final accuracy = location['accuracy'] as double;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('当前位置: $latitude, $longitude (精度: ${accuracy}m)'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('无法获取当前位置')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('获取位置错误: $e')),
      );
    }
  }

  Future<void> _searchNearby() async {
    if (!_isMapReady) return;
    
    try {
      final places = await MtMap.searchNearby(
        latitude: 39.9042,
        longitude: 116.4074,
        radius: 1000.0,
        keyword: '餐厅',
      );
      
      if (places != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('找到 ${places.length} 个附近地点')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('搜索失败')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('搜索错误: $e')),
      );
    }
  }
}
