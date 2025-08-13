import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mt_map_platform_interface.dart';

/// An implementation of [MtMapPlatform] that uses method channels.
class MethodChannelMtMap extends MtMapPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('mt_map');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> initialize(String apiKey) async {
    final result = await methodChannel.invokeMethod<bool>('initialize', {'apiKey': apiKey});
    return result ?? false;
  }

  @override
  Future<bool> showMap({
    required double latitude,
    required double longitude,
    double? zoom,
    String? title,
    String? snippet,
  }) async {
    final result = await methodChannel.invokeMethod<bool>('showMap', {
      'latitude': latitude,
      'longitude': longitude,
      'zoom': zoom ?? 15.0,
      'title': title,
      'snippet': snippet,
    });
    return result ?? false;
  }

  @override
  Future<bool> hideMap() async {
    final result = await methodChannel.invokeMethod<bool>('hideMap');
    return result ?? false;
  }

  @override
  Future<bool> addMarker({
    required double latitude,
    required double longitude,
    String? title,
    String? snippet,
    String? iconPath,
  }) async {
    final result = await methodChannel.invokeMethod<bool>('addMarker', {
      'latitude': latitude,
      'longitude': longitude,
      'title': title,
      'snippet': snippet,
      'iconPath': iconPath,
    });
    return result ?? false;
  }

  @override
  Future<bool> removeMarker(int markerId) async {
    final result = await methodChannel.invokeMethod<bool>('removeMarker', {
      'markerId': markerId,
    });
    return result ?? false;
  }

  @override
  Future<bool> setMapCenter({
    required double latitude,
    required double longitude,
    double? zoom,
  }) async {
    final result = await methodChannel.invokeMethod<bool>('setMapCenter', {
      'latitude': latitude,
      'longitude': longitude,
      'zoom': zoom,
    });
    return result ?? false;
  }

  @override
  Future<Map<String, dynamic>?> getCurrentLocation() async {
    final result = await methodChannel.invokeMethod<Map<String, dynamic>>('getCurrentLocation');
    return result;
  }

  @override
  Future<bool> startLocationUpdates() async {
    final result = await methodChannel.invokeMethod<bool>('startLocationUpdates');
    return result ?? false;
  }

  @override
  Future<bool> stopLocationUpdates() async {
    final result = await methodChannel.invokeMethod<bool>('stopLocationUpdates');
    return result ?? false;
  }

  @override
  Future<bool> calculateRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
    String? transportMode,
  }) async {
    final result = await methodChannel.invokeMethod<bool>('calculateRoute', {
      'startLatitude': startLatitude,
      'startLongitude': startLongitude,
      'endLatitude': endLatitude,
      'endLongitude': endLongitude,
      'transportMode': transportMode ?? 'driving',
    });
    return result ?? false;
  }

  @override
  Future<List<Map<String, dynamic>>?> searchNearby({
    required double latitude,
    required double longitude,
    required double radius,
    String? keyword,
    String? category,
  }) async {
    final result = await methodChannel.invokeMethod<List<dynamic>>('searchNearby', {
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'keyword': keyword,
      'category': category,
    });
    return result?.cast<Map<String, dynamic>>();
  }

  // 新增的地图容器相关方法实现
  @override
  Future<bool> addPolyline({
    required List<Map<String, double>> points,
    required int color,
    required double width,
    bool geodesic = true,
  }) async {
    final result = await methodChannel.invokeMethod<bool>('addPolyline', {
      'points': points,
      'color': color,
      'width': width,
      'geodesic': geodesic,
    });
    return result ?? false;
  }

  @override
  Future<bool> removePolyline(int polylineId) async {
    final result = await methodChannel.invokeMethod<bool>('removePolyline', {
      'polylineId': polylineId,
    });
    return result ?? false;
  }

  @override
  Future<bool> addPolygon({
    required List<Map<String, double>> points,
    required int fillColor,
    required int strokeColor,
    required double strokeWidth,
  }) async {
    final result = await methodChannel.invokeMethod<bool>('addPolygon', {
      'points': points,
      'fillColor': fillColor,
      'strokeColor': strokeColor,
      'strokeWidth': strokeWidth,
    });
    return result ?? false;
  }

  @override
  Future<bool> removePolygon(int polygonId) async {
    final result = await methodChannel.invokeMethod<bool>('removePolygon', {
      'polygonId': polygonId,
    });
    return result ?? false;
  }

  @override
  Future<bool> animateCamera({
    required double latitude,
    required double longitude,
    double? zoom,
    int? duration,
  }) async {
    final result = await methodChannel.invokeMethod<bool>('animateCamera', {
      'latitude': latitude,
      'longitude': longitude,
      'zoom': zoom,
      'duration': duration ?? 1000,
    });
    return result ?? false;
  }

  @override
  Future<bool> setMapStyle(Map<String, dynamic> style) async {
    final result = await methodChannel.invokeMethod<bool>('setMapStyle', {
      'style': style,
    });
    return result ?? false;
  }

  @override
  Future<bool> enableMyLocation(bool enabled) async {
    final result = await methodChannel.invokeMethod<bool>('enableMyLocation', {
      'enabled': enabled,
    });
    return result ?? false;
  }

  @override
  Future<bool> enableMyLocationButton(bool enabled) async {
    final result = await methodChannel.invokeMethod<bool>('enableMyLocationButton', {
      'enabled': enabled,
    });
    return result ?? false;
  }

  @override
  Future<bool> enableZoomControls(bool enabled) async {
    final result = await methodChannel.invokeMethod<bool>('enableZoomControls', {
      'enabled': enabled,
    });
    return result ?? false;
  }

  @override
  Future<bool> enableCompass(bool enabled) async {
    final result = await methodChannel.invokeMethod<bool>('enableCompass', {
      'enabled': enabled,
    });
    return result ?? false;
  }

  @override
  Future<bool> enableScaleBar(bool enabled) async {
    final result = await methodChannel.invokeMethod<bool>('enableScaleBar', {
      'enabled': enabled,
    });
    return result ?? false;
  }
}
