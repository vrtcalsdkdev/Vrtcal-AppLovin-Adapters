Pod::Spec.new do |s|
    s.name         = "Vrtcal-AppLovin-Adapters"
    s.version      = "1.0.4"
    s.summary      = "Allows mediation with Vrtcal as either the primary or secondary SDK"
    s.homepage     = "http://vrtcal.com"
    s.license = { :type => 'Copyright', :text => <<-LICENSE
                   Copyright 2020 Vrtcal Markets, Inc.
                  LICENSE
                }
    s.author       = { "Scott McCoy" => "scott.mccoy@vrtcal.com" }
    
    s.source       = { :git => "https://github.com/vrtcalsdkdev/Vrtcal-AppLovin-Adapters.git", :tag => "#{s.version}" }
    s.source_files = "Source/**/*.swift"

    s.platform = :ios
    s.ios.deployment_target  = '11.0'

    s.dependency 'AppLovinSDK'
    s.dependency 'VrtcalSDK'

    s.static_framework = true
#    s.pod_target_xcconfig = { 
#        "OTHER_LDFLAGS" => "-ObjC",
#        "VALID_ARCHS" => "i386 x86_64 armv7 arm64",
#        "VALID_ARCHS[sdk=iphoneos*]" => "arm64 arm64e armv7 armv7s",
#        "VALID_ARCHS[sdk=iphonesimulator*]" => "x86_64"
#    }
end
