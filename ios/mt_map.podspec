#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint mt_map.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'mt_map'
  s.version          = '1.0.0'
  s.summary          = 'A Flutter plugin for integrating Meituan Map SDK on iOS and Android platforms.'
  s.description      = <<-DESC
A Flutter plugin that provides integration with Meituan Map SDK for both iOS and Android platforms.
This plugin allows you to display maps, add markers, get current location, search nearby places,
and calculate routes using Meituan's map services.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # 美团地图SDK依赖（需要根据实际SDK版本调整）
  # 注意：这里使用的是示例依赖，实际使用时需要替换为美团官方提供的SDK
  # s.dependency 'MTMapSDK', '~> 1.0.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
