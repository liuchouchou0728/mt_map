import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mt_map_method_channel.dart';

abstract class MtMapPlatform extends PlatformInterface {
  /// Constructs a MtMapPlatform.
  MtMapPlatform() : super(token: _token);

  static final Object _token = Object();

  static MtMapPlatform _instance = MethodChannelMtMap();

  /// The default instance of [MtMapPlatform] to use.
  ///
  /// Defaults to [MethodChannelMtMap].
  static MtMapPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MtMapPlatform] when
  /// they register themselves.
  static set instance(MtMapPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> initialize(String apiKey) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<bool> showMap({
    required double latitude,
    required double longitude,
    double? zoom,
    String? title,
    String? snippet,
  }) {
    throw UnimplementedError('showMap() has not been implemented.');
  }

  Future<bool> hideMap() {
    throw UnimplementedError('hideMap() has not been implemented.');
  }

  Future<bool> addMarker({
    required double latitude,
    required double longitude,
    String? title,
    String? snippet,
    String? iconPath,
  }) {
    throw UnimplementedError('addMarker() has not been implemented.');
  }

  Future<bool> removeMarker(int markerId) {
    throw UnimplementedError('removeMarker() has not been implemented.');
  }

  Future<bool> setMapCenter({
    required double latitude,
    required double longitude,
    double? zoom,
  }) {
    throw UnimplementedError('setMapCenter() has not been implemented.');
  }

  Future<Map<String, dynamic>?> getCurrentLocation() {
    throw UnimplementedError('getCurrentLocation() has not been implemented.');
  }

  Future<bool> startLocationUpdates() {
    throw UnimplementedError('startLocationUpdates() has not been implemented.');
  }

  Future<bool> stopLocationUpdates() {
    throw UnimplementedError('stopLocationUpdates() has not been implemented.');
  }

  Future<bool> calculateRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
    String? transportMode,
  }) {
    throw UnimplementedError('calculateRoute() has not been implemented.');
  }

  Future<List<Map<String, dynamic>>?> searchNearby({
    required double latitude,
    required double longitude,
    required double radius,
    String? keyword,
    String? category,
  }) {
    throw UnimplementedError('searchNearby() has not been implemented.');
  }

  // 新增的地图容器相关方法
  Future<bool> addPolyline({
    required List<Map<String, double>> points,
    required int color,
    required double width,
    bool geodesic = true,
  }) {
    throw UnimplementedError('addPolyline() has not been implemented.');
  }

  Future<bool> removePolyline(int polylineId) {
    throw UnimplementedError('removePolyline() has not been implemented.');
  }

  Future<bool> addPolygon({
    required List<Map<String, double>> points,
    required int fillColor,
    required int strokeColor,
    required double strokeWidth,
  }) {
    throw UnimplementedError('addPolygon() has not been implemented.');
  }

  Future<bool> removePolygon(int polygonId) {
    throw UnimplementedError('removePolygon() has not been implemented.');
  }

  Future<bool> animateCamera({
    required double latitude,
    required double longitude,
    double? zoom,
    int? duration,
  }) {
    throw UnimplementedError('animateCamera() has not been implemented.');
  }

  Future<bool> setMapStyle(Map<String, dynamic> style) {
    throw UnimplementedError('setMapStyle() has not been implemented.');
  }

  Future<bool> enableMyLocation(bool enabled) {
    throw UnimplementedError('enableMyLocation() has not been implemented.');
  }

  Future<bool> enableMyLocationButton(bool enabled) {
    throw UnimplementedError('enableMyLocationButton() has not been implemented.');
  }

  Future<bool> enableZoomControls(bool enabled) {
    throw UnimplementedError('enableZoomControls() has not been implemented.');
  }

  Future<bool> enableCompass(bool enabled) {
    throw UnimplementedError('enableCompass() has not been implemented.');
  }

  Future<bool> enableScaleBar(bool enabled) {
    throw UnimplementedError('enableScaleBar() has not been implemented.');
  }
}
