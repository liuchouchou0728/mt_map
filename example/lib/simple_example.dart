import 'package:flutter/material.dart';
import 'package:mt_map/mt_map.dart';

/// 简单的美团地图使用示例
/// 展示如何使用地图容器Widget，无需手动初始化
class SimpleMapExample extends StatelessWidget {
  const SimpleMapExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('简单地图示例'),
        backgroundColor: Colors.orange,
      ),
      body: MtMapWidget(
        params: MtMapWidgetParams(
          apiKey: 'your_meituan_map_api_key_here', // 替换为您的API密钥
          initialPosition: const MtMapPosition(
            latitude: 39.9042,
            longitude: 116.4074,
            zoom: 15.0,
          ),
          initialMarkers: [
            const MtMapMarker(
              latitude: 39.9042,
              longitude: 116.4074,
              title: '天安门',
              snippet: '中国北京市东城区天安门广场',
            ),
          ],
        ),
        style: const MtMapStyle(
          showTraffic: true,
          showBuildings: true,
          mapType: 'normal',
        ),
        callbacks: MtMapWidgetCallbacks(
          onMapReady: () {
            print('地图准备完成');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('地图加载完成')),
            );
          },
          onMapError: (error) {
            print('地图错误: $error');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('地图错误: $error'),
                backgroundColor: Colors.red,
              ),
            );
          },
          onMapClick: (latitude, longitude) {
            print('地图点击: $latitude, $longitude');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('点击位置: $latitude, $longitude'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          onMarkerClick: (marker) {
            print('标记点击: ${marker.title}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('点击了标记: ${marker.title ?? '未命名'}'),
                duration: const Duration(seconds: 2),
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
      ),
    );
  }
}

/// 更简单的使用示例
/// 只显示地图，不添加任何标记或回调
class MinimalMapExample extends StatelessWidget {
  const MinimalMapExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('最简地图示例'),
        backgroundColor: Colors.blue,
      ),
      body: const MtMapWidget(
        params: MtMapWidgetParams(
          apiKey: 'your_meituan_map_api_key_here', // 替换为您的API密钥
          initialPosition: MtMapPosition(
            latitude: 39.9042,
            longitude: 116.4074,
            zoom: 15.0,
          ),
        ),
      ),
    );
  }
}
