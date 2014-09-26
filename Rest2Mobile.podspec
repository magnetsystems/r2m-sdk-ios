Pod::Spec.new do |s|
  s.name               =  'Rest2Mobile'
  s.version            =  '1.0.1'
  s.license            =  { :type => 'Commercial', :text => 'See http://www.magnet.com/resources/tos.html' }
  s.summary            =  'Use rest2mobile iOS SDK to develop iOS applications that communicate with REST/JSON APIs.'
  s.homepage           =  'https://developer.magnet.com'
  s.author             =  { 'Magnet Systems, Inc.' => 'support@magnet.com' }
  s.source             =  { :git => 'https://github.com/magnetsystems/r2m-sdk-ios.git', :tag=> '1.0.1', :submodules => true }

  s.platform = :ios, '7.0'
  s.requires_arc = true
  
  s.preserve_paths = 'Rest2Mobile.framework'
  s.public_header_files = "Rest2Mobile.framework/Headers/*.h"
  s.vendored_frameworks = 'Rest2Mobile.framework'
  
  s.frameworks     =  'CFNetwork', 'CoreData', 'Security', 'MobileCoreServices', 'SystemConfiguration', 'CoreLocation', 'Rest2Mobile'
  s.xcconfig       =  { 'OTHER_LDFLAGS' => '-ObjC -all_load', 'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/Rest2Mobile/Rest2Mobile.framework/Headers"' } 
  s.library        =  'c++'
  s.dependency     'AFNetworking', '~> 2.2'
  s.dependency     'Mantle', '~> 1.4'
  s.dependency     'MDMCoreData', '~> 1.0'
  s.dependency     'RNCryptor', '~> 2.2'
  s.dependency     'CocoaLumberjack', '~> 1.8'

end
