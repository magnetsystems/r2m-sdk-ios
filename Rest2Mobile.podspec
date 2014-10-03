Pod::Spec.new do |s|
  s.name     = 'Rest2Mobile'
  s.version  = '1.1.0'
  s.license  = 'Apache License 2.0'
  s.summary  = 'A delightful iOS and OS X networking framework.'
  s.homepage = 'Use rest2mobile iOS SDK to develop iOS applications that communicate with REST/JSON APIs.'
  #s.social_media_url = 'https://developer.magnet.com'
  s.authors  = { 'Magnet Systems, Inc.' => 'support@magnet.com' }
  s.source   = { :git => 'https://github.com/magnetsystems/r2m-sdk-ios.git', :tag => "1.1.0", :submodules => true }
  s.requires_arc = true

  s.ios.deployment_target = '7.0'
  # s.osx.deployment_target = '10.8'

  s.public_header_files = 'Rest2Mobile/*/*.h', 'Rest2Mobile/Rest2Mobile.h'
  s.source_files = 'Rest2Mobile/Rest2Mobile.h'

  s.subspec 'Categories' do |ss|
    ss.source_files = 'Rest2Mobile/Categories/*.{h,m}'
  end
  
  s.subspec 'Utilities' do |ss|
    ss.dependency 'Rest2Mobile/Logging'
    ss.source_files = 'Rest2Mobile/Utilities/*.{h,m}'
  end
  
  s.subspec 'Logging' do |ss|
    ss.dependency     'AFNetworking', '~> 2.2'
    ss.dependency     'CocoaLumberjack', '~> 1.8'
    ss.source_files = 'Rest2Mobile/Logging/*.{h,m}'
  end
  
  s.subspec 'Serialization' do |ss|
    ss.dependency     'AFNetworking', '~> 2.2'
    ss.dependency     'Mantle', '~> 1.4'
  	ss.dependency 'Rest2Mobile/Logging'
	ss.dependency 'Rest2Mobile/Utilities'
    ss.source_files = 'Rest2Mobile/Serialization/*/*.{h,m}'
  end
  
  s.subspec 'Transport' do |ss|
    ss.dependency     'AFNetworking', '~> 2.2'
	ss.dependency     'Mantle', '~> 1.4'
	ss.dependency 'Rest2Mobile/Logging'
	ss.dependency 'Rest2Mobile/Controller'
    ss.source_files = 'Rest2Mobile/Transport/*/*.{h,m}', 'Rest2Mobile/Transport/*.{h,m}'
  end
  
  s.subspec 'Controller' do |ss|
  	ss.dependency 'Rest2Mobile/Categories'
	ss.dependency 'Rest2Mobile/Logging'
	ss.dependency 'Rest2Mobile/Serialization'
	ss.dependency 'Rest2Mobile/Transport'
	ss.dependency 'Rest2Mobile/Utilities'
    ss.source_files = 'Rest2Mobile/Controller/*/*.{h,m}', 'Rest2Mobile/Controller/*.{h,m}'
  end
end
