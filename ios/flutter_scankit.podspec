#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_hms_scankit.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_hms_scankit'
  s.version          = '0.0.1'
  s.summary          = '华为统一扫码服务 Flutter 版本'
  s.description      = <<-DESC
华为统一扫码服务 Flutter 插件版本
                       DESC
  s.homepage         = 'https://github.com/L-X-J/flutter-hms-scankit'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'ScanKitFrameWork', '~> 1.1.0.303'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
