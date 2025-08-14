import 'package:flutter/material.dart';
import 'package:mt_map/mt_map.dart';

/// 修复了渲染问题的地图示例
class FixedMapExample extends StatefulWidget {
  const FixedMapExample({super.key});

  @override
  State<FixedMapExample> createState() => _FixedMapExampleState();
}

class _FixedMapExampleState extends State<FixedMapExample> {
  List<MtMapMarker> _markers = [];
  List<MtMapPolyline> _polylines = [];
  List<MtMapPolygon> _polygons = [];
  bool _isMapReady = false;
  String? _errorMessage;
  int _mapKey = 0; // 用于强制重建地图

  @override
  void initState() {
    super.initState();
    _addInitialElements();
  }

  void _addInitialElements() {
    // 添加初始标记
    _markers.add(
      const MtMapMarker(
        latitude: 39.9042,
        longitude: 116.4074,
        title: '天安门',
        snippet: '中国北京市东城区天安门广场',
      ),
    );

    // 添加初始路线
    _polylines.add(
      MtMapPolyline(
        points: const [
          MtMapPosition(latitude: 39.9042, longitude: 116.4074),
          MtMapPosition(latitude: 39.9142, longitude: 116.4174),
        ],
        color: Colors.blue,
        width: 5.0,
      ),
    );

    // 添加初始多边形
    _polygons.add(
      MtMapPolygon(
        points: const [
          MtMapPosition(latitude: 39.9042, longitude: 116.4074),
          MtMapPosition(latitude: 39.9142, longitude: 116.4074),
          MtMapPosition(latitude: 39.9142, longitude: 116.4174),
        ],
        fillColor: Colors.green,
        strokeColor: Colors.green,
        strokeWidth: 2.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('地图错误'),
          backgroundColor: Colors.red,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                '地图加载失败',
                style: TextStyle(fontSize: 20, color: Colors.red[700]),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _errorMessage = null;
                    _mapKey++; // 强制重建地图
                  });
                },
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('修复版地图示例'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _mapKey++; // 强制重建地图
              });
            },
            tooltip: '重建地图',
          ),
        ],
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
      key: ValueKey(_mapKey), // 使用key强制重建
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
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('地图准备完成，可以开始操作'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        },
        onMapError: (error) {
          print('地图错误: $error');
          setState(() {
            _errorMessage = error;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('地图错误: $error'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        },
        onMapClick: (latitude, longitude) {
          print('地图点击: $latitude, $longitude');
          _addMarker(latitude, longitude);
        },
        onMarkerClick: (marker) {
          print('标记点击: ${marker.title}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('点击了标记: ${marker.title ?? '未命名'}'),
              backgroundColor: Colors.blue,
              duration: Duration(seconds: 2),
            ),
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
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        children: [
          // 状态指示器
          if (!_isMapReady)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.indigo[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo[700]!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '地图正在加载...',
                    style: TextStyle(color: Colors.indigo[700]),
                  ),
                ],
              ),
            ),
          
          if (_isMapReady) ...[
            // 功能按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _addRandomMarker,
                  icon: const Icon(Icons.add_location),
                  label: const Text('添加标记'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _addPolyline,
                  icon: const Icon(Icons.timeline),
                  label: const Text('添加路线'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _addPolygon,
                  icon: const Icon(Icons.pentagon_outlined),
                  label: const Text('添加多边形'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _clearAll,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('清除所有'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _rebuildMap,
                  icon: const Icon(Icons.refresh),
                  label: const Text('重建地图'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _getCurrentLocation,
                  icon: const Icon(Icons.my_location),
                  label: const Text('获取位置'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 状态信息
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoItem('标记', _markers.length, Colors.blue),
                  _buildInfoItem('路线', _polylines.length, Colors.green),
                  _buildInfoItem('多边形', _polygons.length, Colors.purple),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // 提示信息
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[600], size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '点击地图添加标记，使用按钮添加其他元素',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, int count, Color color) {
    return Column(
      children: [
        Icon(Icons.circle, color: color, size: 16),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
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
      SnackBar(
        content: Text('添加标记: ${marker.title}'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
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
      const SnackBar(
        content: Text('添加路线'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
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
      const SnackBar(
        content: Text('添加多边形'),
        backgroundColor: Colors.purple,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearAll() {
    setState(() {
      _markers.clear();
      _polylines.clear();
      _polygons.clear();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已清除所有元素'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _rebuildMap() {
    setState(() {
      _mapKey++; // 强制重建地图
      _isMapReady = false; // 重置状态
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('正在重建地图...'),
        backgroundColor: Colors.indigo,
        duration: Duration(seconds: 2),
      ),
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
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('无法获取当前位置'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('获取位置错误: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
