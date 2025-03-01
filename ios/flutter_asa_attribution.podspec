#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_asa_attribution.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_asa_attribution'
  s.version          = '0.0.1'
  s.summary          = 'A apple search ads attribution plugin for flutter'
  s.description      = <<-DESC
A apple search ads attribution plugin for flutter
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  s.weak_frameworks = ['AdServices']

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
