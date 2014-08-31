#
# Be sure to run `pod lib lint NPLRemoteNotificationManager.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "NPLRemoteNotificationManager"
  s.version          = "1.0.2"
  s.summary          = "An easier way to handle push notification logic around your app."
  s.homepage         = "https://github.com/nickplee/NPLRemoteNotificationManager"
  s.license          = 'MIT'
  s.author           = { "Nick Lee" => "nick@nickplee.com" }
  s.source           = { :git => "https://github.com/nickplee/NPLRemoteNotificationManager.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/nickplee'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.dependency 'Mantle', '~> 1.5'
end
