#
# Be sure to run `pod lib lint HKRxMoya.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HKRxMoya'
  s.version          = '0.1.0'
  s.summary          = 'Swift 5+RxSwift+Moya+HandyJSON'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Using Moya's abstraction and RxSwift's subscription pattern to facilitate network requests, the request results are deserialized using HandyJSON

Built-in Log and toast plugins
                       DESC

  s.homepage         = 'https://github.com/oragekk@163.com/HKRxMoya'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'oragekk@163.com' => 'huangkun@tonshow.cn' }
  s.source           = { :git => 'https://github.com/oragekk@163.com/HKRxMoya.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'HKRxMoya/Classes/**/*'
  
  # s.resource_bundles = {
  #   'HKRxMoya' => ['HKRxMoya/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'CoreTelephony'
   
   s.dependency 'Moya/RxSwift', '15.0'
   s.dependency 'RxSwift','6.5.0'
   s.dependency 'HandyJSON','5.0.1'
   s.dependency 'Toast-Swift','5.0.1'
end
