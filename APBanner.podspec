#
# Be sure to run `pod lib lint APBanner.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.platform         = :ios, '8.0'
  s.name             = 'APBanner'
  s.version          = '1.0'
  s.summary          = 'APBanner is a simple and customizable iOS in-app notification you can display from wherever you want.'
  s.description      = <<-DESC
This lib can :
  - Display title, subtitle and body
  - Display auto resizable image
  - Auto expand-collapse with user's gestures 
                       DESC

  s.homepage         = 'https://github.com/appspanel/APBanner'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Pierre Grimault' => 'support@apps-panel.com' }
  s.source           = { :git => 'https://github.com/appspanel/APBanner.git', :tag => s.version.to_s }
  #  s.ios.deployment_target = '8.0'
  s.resource = "APBanner/Classes/**/*.{xib,nib,png,bundle}"
  s.source_files = 'APBanner/Classes/**/*.{h,m}'
  

end
