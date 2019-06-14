#
# Be sure to run `pod lib lint CDPickerOperation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CDPickerOperation'
  s.version          = '0.1.0'
  s.summary          = 'UIPickView选择器'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
底部弹窗的时间选择器 或者其他选择器,  只需传入对应的数组即可
                       DESC

  s.homepage         = 'https://github.com/513433750@qq.com/CDPickerOperation'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '513433750@qq.com' => '513433750@qq.com' }
  s.source           = { :git => 'https://gitlab.ttsing.com/ios/CDPickerOperation.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CDPickerOperation/*.{h,m}'
  
  # s.resource_bundles = {
  #   'CDPickerOperation' => ['CDPickerOperation/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
