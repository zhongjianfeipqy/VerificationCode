Pod::Spec.new do |spec|

  spec.name         = "VerifyCodeSwift"
  spec.version      = "3.0.1"
  spec.summary      = "iOS Custom captcha"
  spec.swift_versions = "5.0"

  spec.description  = <<-DESC
                    iOS Custom captcha, Support for swift.
                   DESC

  spec.homepage     = "https://github.com/zhongjianfeipqy/VerificationCode"
  spec.screenshots  = "https://upload-images.jianshu.io/upload_images/2094754-768de1c89184e230.gif?imageMogr2/auto-orient/strip"

  spec.license      = "MIT"

  spec.author             = { "JF Z" => "378789308@qq.com"}

  spec.social_media_url   = "https://www.jianshu.com/u/2a97371d263b"

  spec.platform     = :ios, "9.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"

  spec.source       = { :git => "https://github.com/zhongjianfeipqy/VerificationCode.git", :tag => "#{spec.version}" }

  # spec.source_files  =  "VerifyCodeDemo/VerifyCodeView/**/*"
  spec.source_files  =  "VerifyCodeDemo/VerifyCodeView/*"

  spec.subspec 'TDWExtension' do |sub|
    sub.source_files  = "VerifyCodeDemo/VerifyCodeView/TDWExtension/*"
  end

  spec.frameworks = "UIKit", "Foundation"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  spec.requires_arc = true

  spec.dependency 'SnapKit'

end
