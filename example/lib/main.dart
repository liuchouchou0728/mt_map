import 'package:flutter/material.dart';
import 'package:mt_map/mt_map.dart';
import 'map_example.dart';
import 'simple_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await MtMap.getPlatformVersion() ?? 'Unknown platform version';
    } catch (e) {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('美团地图插件示例'),
          backgroundColor: Colors.orange,
        ),
        body: Column(
          children: [
            // 平台版本信息
            Container(
              padding: const EdgeInsets.all(16),
              child: Text('平台版本: $_platformVersion'),
            ),
            
            // 选择示例
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SimpleMapExample(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('简单地图示例（推荐）'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MinimalMapExample(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('最简地图示例'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapExample(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('完整功能示例'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BasicExample(),
                        ),
                      );
                    },
                    child: const Text('基础API示例'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 基础API使用示例
class BasicExample extends StatefulWidget {
  const BasicExample({super.key});

  @override
  State<BasicExample> createState() => _BasicExampleState();
}

class _BasicExampleState extends State<BasicExample> {
  bool _isInitialized = false;
  String _locationInfo = '未获取位置';

  @override
  void initState() {
    super.initState();
    // 基础API示例需要手动初始化
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      final success = await MtMap.initialize('your_meituan_map_api_key_here');
      setState(() {
        _isInitialized = success;
      });
    } catch (e) {
      print('地图初始化失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('基础API示例'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('地图状态: ${_isInitialized ? "已初始化" : "未初始化"}\n'),
            Text('位置信息: $_locationInfo\n'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showMap,
              child: const Text('显示地图'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addMarker,
              child: const Text('添加标记点'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text('获取当前位置'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _searchNearby,
              child: const Text('搜索附近'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _calculateRoute,
              child: const Text('计算路线'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMap() async {
    if (!_isInitialized) {
      _showSnackBar('请先初始化地图');
      return;
    }

    try {
      final success = await MtMap.showMap(
        latitude: 39.9042,
        longitude: 116.4074,
        zoom: 15.0,
        title: '北京天安门',
        snippet: '中国北京市东城区天安门广场',
      );
      if (success) {
        _showSnackBar('地图显示成功');
      } else {
        _showSnackBar('地图显示失败');
      }
    } catch (e) {
      _showSnackBar('显示地图错误: $e');
    }
  }

  Future<void> _addMarker() async {
    if (!_isInitialized) {
      _showSnackBar('请先初始化地图');
      return;
    }

    try {
      final success = await MtMap.addMarker(
        latitude: 39.9042,
        longitude: 116.4074,
        title: '天安门',
        snippet: '中国北京市东城区天安门广场',
      );
      if (success) {
        _showSnackBar('标记点添加成功');
      } else {
        _showSnackBar('标记点添加失败');
      }
    } catch (e) {
      _showSnackBar('添加标记点错误: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final location = await MtMap.getCurrentLocation();
      if (location != null) {
        setState(() {
          _locationInfo = '纬度: ${location['latitude']}, 经度: ${location['longitude']}, 精度: ${location['accuracy']}';
        });
        _showSnackBar('位置获取成功');
      } else {
        _showSnackBar('位置获取失败');
      }
    } catch (e) {
      _showSnackBar('获取位置错误: $e');
    }
  }

  Future<void> _searchNearby() async {
    if (!_isInitialized) {
      _showSnackBar('请先初始化地图');
      return;
    }

    try {
      final places = await MtMap.searchNearby(
        latitude: 39.9042,
        longitude: 116.4074,
        radius: 1000.0,
        keyword: '餐厅',
      );
      if (places != null) {
        _showSnackBar('找到 ${places.length} 个附近地点');
      } else {
        _showSnackBar('搜索失败');
      }
    } catch (e) {
      _showSnackBar('搜索错误: $e');
    }
  }

  Future<void> _calculateRoute() async {
    if (!_isInitialized) {
      _showSnackBar('请先初始化地图');
      return;
    }

    try {
      final success = await MtMap.calculateRoute(
        startLatitude: 39.9042,
        startLongitude: 116.4074,
        endLatitude: 39.9087,
        endLongitude: 116.3975,
        transportMode: 'driving',
      );
      if (success) {
        _showSnackBar('路线计算成功');
      } else {
        _showSnackBar('路线计算失败');
      }
    } catch (e) {
      _showSnackBar('路线计算错误: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
