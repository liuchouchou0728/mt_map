import 'dart:async';

import 'mt_map_platform_interface.dart';

export 'mt_map_platform_interface.dart';
export 'mt_map_widget.dart';

/// Main class for interacting with Meituan Map SDK
class MtMap {
  static final MtMapPlatform _platform = MtMapPlatform.instance;

  /// Get the platform version
  static Future<String?> getPlatformVersion() {
    return _platform.getPlatformVersion();
  }

  /// Initialize the Meituan Map SDK
  /// Note: This method is now automatically called by MtMapWidget
  /// You don't need to call this manually when using MtMapWidget
  /// @deprecated Use MtMapWidget instead
  static Future<bool> initialize(String apiKey) {
    return _platform.initialize(apiKey);
  }

  /// Show map with specified location
  /// @deprecated Use MtMapWidget instead
  static Future<bool> showMap({
    required double latitude,
    required double longitude,
    double? zoom,
    String? title,
    String? snippet,
  }) {
    return _platform.showMap(
      latitude: latitude,
      longitude: longitude,
      zoom: zoom,
      title: title,
      snippet: snippet,
    );
  }

  /// Hide the map
  static Future<bool> hideMap() {
    return _platform.hideMap();
  }

  /// Add a marker to the map
  static Future<bool> addMarker({
    required double latitude,
    required double longitude,
    String? title,
    String? snippet,
    String? iconPath,
  }) {
    return _platform.addMarker(
      latitude: latitude,
      longitude: longitude,
      title: title,
      snippet: snippet,
      iconPath: iconPath,
    );
  }

  /// Remove a marker from the map
  static Future<bool> removeMarker(int markerId) {
    return _platform.removeMarker(markerId);
  }

  /// Set the center of the map
  static Future<bool> setMapCenter({
    required double latitude,
    required double longitude,
    double? zoom,
  }) {
    return _platform.setMapCenter(
      latitude: latitude,
      longitude: longitude,
      zoom: zoom,
    );
  }

  /// Get current location
  static Future<Map<String, dynamic>?> getCurrentLocation() {
    return _platform.getCurrentLocation();
  }

  /// Start location updates
  static Future<bool> startLocationUpdates() {
    return _platform.startLocationUpdates();
  }

  /// Stop location updates
  static Future<bool> stopLocationUpdates() {
    return _platform.stopLocationUpdates();
  }

  /// Calculate route between two points
  static Future<bool> calculateRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
    String? transportMode,
  }) {
    return _platform.calculateRoute(
      startLatitude: startLatitude,
      startLongitude: startLongitude,
      endLatitude: endLatitude,
      endLongitude: endLongitude,
      transportMode: transportMode,
    );
  }

  /// Search for nearby places
  static Future<List<Map<String, dynamic>>?> searchNearby({
    required double latitude,
    required double longitude,
    required double radius,
    String? keyword,
    String? category,
  }) {
    return _platform.searchNearby(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      keyword: keyword,
      category: category,
    );
  }
}
