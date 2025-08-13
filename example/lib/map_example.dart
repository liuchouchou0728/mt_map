import 'package:flutter/material.dart';
import 'package:mt_map/mt_map.dart';

/// 美团地图使用示例
class MapExample extends StatefulWidget {
  const MapExample({super.key});

  @override
  State<MapExample> createState() => _MapExampleState();
}

class _MapExampleState extends State<MapExample> {
  List<MtMapMarker> _markers = [];
  List<MtMapPolyline> _polylines = [];
  List<MtMapPolygon> _polygons = [];

  @override
  void initState() {
    super.initState();
    // 地图容器会自动处理初始化，无需手动初始化
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('美团地图示例'),
        backgroundColor: Colors.orange,
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
        },
        onMapError: (error) {
          print('地图错误: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('地图错误: $error')),
          );
        },
        onMapClick: (latitude, longitude) {
          print('地图点击: $latitude, $longitude');
          _addMarker(latitude, longitude);
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
                onPressed: _addRandomMarker,
                child: const Text('添加标记'),
              ),
              ElevatedButton(
                onPressed: _addPolyline,
                child: const Text('添加路线'),
              ),
              ElevatedButton(
                onPressed: _addPolygon,
                child: const Text('添加多边形'),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _clearAll,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('清除所有'),
              ),
              ElevatedButton(
                onPressed: _getCurrentLocation,
                child: const Text('获取位置'),
              ),
              ElevatedButton(
                onPressed: _searchNearby,
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

  void _addMarker(double latitude, double longitude) {
    final marker = MtMapMarker(
      latitude: latitude,
      longitude: longitude,
      title: '标记 ${_markers.length + 1}',
      snippet: '点击添加的标记',
    );
    
    setState(() {
      _markers.add(marker);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('添加标记: ${marker.title}')),
    );
  }

  void _addRandomMarker() {
    final random = DateTime.now().millisecondsSinceEpoch;
    final latitude = 39.9042 + (random % 1000 - 500) / 10000.0;
    final longitude = 116.4074 + (random % 1000 - 500) / 10000.0;
    
    _addMarker(latitude, longitude);
  }

  void _addPolyline() {
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
