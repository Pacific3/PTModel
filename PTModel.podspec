#
# Be sure to run `pod lib lint PTModel.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "PTModel"
  s.version          = "0.3.1"
  s.summary          = "PTModel is a simple object store for iOS apps."
  s.homepage         = "https://github.com/Pacific3/PTModel"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Oscar Swanros @ Pacific3" => "hola@pacific3.net" }
  s.source           = { :git => "https://github.com/Pacific3/PTModel.git", :tag => "v0.3.1" }
  # s.social_media_url = 'https://twitter.com/Pacific3'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'PTModel' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
