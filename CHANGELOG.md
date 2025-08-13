# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-XX

### Added
- 初始版本发布
- 支持iOS和Android平台
- 地图显示和控制功能
- 位置标记和POI管理
- 实时位置获取和更新
- 路线规划和导航
- 附近地点搜索
- 完整的Flutter插件架构
- 示例应用和文档

### Features
- `initialize()` - 初始化美团地图SDK
- `showMap()` - 显示地图到指定位置
- `hideMap()` - 隐藏地图
- `addMarker()` - 添加标记点
- `removeMarker()` - 移除标记点
- `setMapCenter()` - 设置地图中心
- `getCurrentLocation()` - 获取当前位置
- `startLocationUpdates()` - 开始位置更新
- `stopLocationUpdates()` - 停止位置更新
- `calculateRoute()` - 计算路线
- `searchNearby()` - 搜索附近地点

### Technical
- 使用Flutter插件平台接口架构
- 支持方法通道通信
- 完整的错误处理机制
- 权限管理支持
- 跨平台兼容性

## [Unreleased]

### Planned
- 支持更多地图控件
- 添加自定义地图样式
- 支持离线地图
- 添加更多搜索功能
- 性能优化
- 单元测试覆盖

