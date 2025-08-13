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
}
